#include <stdio.h>
#include "Class.h"
#import <mach-o/dyld.h>
#import <mach/mach.h>
#include <sys/sysctl.h>
long Imageaddress,Game_Data,Game_Viewport;
Matrix ViewMatrix;
static vm_map_t get_task() {
    mach_port_t task;
    size_t length = 0;
    static const int name[] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    int err = sysctl((int *)name, (sizeof(name) / sizeof(*name)) - 1, NULL, &length, NULL, 0);
    if (err == -1) err = errno;
    if (err == 0) {
        struct kinfo_proc *procBuffer = (struct kinfo_proc *)malloc(length);
        if(procBuffer == NULL) return -1;
        sysctl((int *)name, (sizeof(name) / sizeof(*name)) - 1, procBuffer, &length, NULL, 0);
        int count = (int)length / sizeof(struct kinfo_proc);
        for (int i = 0; i < count; ++i) {
            const char *procname = procBuffer[i].kp_proc.p_comm;
            NSString *进程名字=[NSString stringWithFormat:@"%s",procname];
            pid_t pid = procBuffer[i].kp_proc.p_pid;
            //自己写判断进程名
            if([进程名字 containsString:@"smoba"])
            {
                kern_return_t kret = task_for_pid(mach_task_self(), pid, &task);
                if (kret == KERN_SUCCESS) {
                    return task;
                }
            }
            
        }
    }
    
    return  -1;
}

void Read_Data(long Src,int Size,void* Dst)
{
//    vm_copy(get_task(),(vm_address_t)Src,Size,(vm_address_t)Dst);//跨进程
    vm_copy( mach_task_self(),(vm_address_t)Src,Size,(vm_address_t)Dst);//注入
   
}

long Read_Long(long src)
{
    long Buff=0;
    Read_Data(src,8,&Buff);
    return Buff;
}

int Read_Int(long src)
{
    int Buff=0;
    Read_Data(src,4,&Buff);
    return Buff;
}

int Read_Short(long src)
{
    int Buff=0;
    Read_Data(src,2,&Buff);
    return Buff;
}

float Read_Float(long src)
{
    float Buff=0;
    Read_Data(src,4,&Buff);
    return Buff;
}

bool ToScreen(Vector2 GameCanvas,Vector2 HeroPos,Vector2* Screen)
{
    Screen->x=0;Screen->y=0;
    float ViewW;
    ViewW = ViewMatrix._13 * HeroPos.x + ViewMatrix._33 * HeroPos.y + ViewMatrix._43;
    if (ViewW < 0.01) return false;
    ViewW = 1/ViewW;
    Screen->x = (1+(ViewMatrix._11 * HeroPos.x + ViewMatrix._31 * HeroPos.y + ViewMatrix._41) * ViewW)*GameCanvas.x/2;
    Screen->y = (1-(ViewMatrix._12 * HeroPos.x + ViewMatrix._32 * HeroPos.y + ViewMatrix._42) * ViewW)*GameCanvas.y/2;
    return true;
}

Vector2 ToMiniMap(Vector2 MiniMap,Vector2 HeroPos)
{
    Vector2 Pos;
    float transformation = ViewMatrix._11>0?1:-1;
    Pos.x = (50 + HeroPos.x*transformation)/100;
    Pos.y = (50 - HeroPos.y*transformation)/100;
    
    return {MiniMap.x + Pos.x*MiniMap.y,Pos.y*MiniMap.y};
}

bool RefreshMatrix()
{
    long P_Level1 = Read_Long(Game_Viewport+0x18);
    long P_Level2 = Read_Long(Read_Long(P_Level1+0xA8));
    long P_Level3 = Read_Long(Read_Long(P_Level2+0xA0));
    long Ptr_View = Read_Long(P_Level3 + 0x50);
    if (Ptr_View < Imageaddress) return false;
    long P_ViewMatrix = Read_Long(Ptr_View+0x10)+0xC0;
    Read_Data(P_ViewMatrix,64,&ViewMatrix);
    return true;
}

Vector2 GetPlayerPos(long Target)
{
    long Target_P1 = Read_Long(Target+0x1B8);
    long Target_P2 = Read_Long(Target_P1+0x10);
    long Target_P3 = Read_Long(Target_P2);
    long Target_P4 = Read_Long(Target_P3 + 0x10);
    
    int x1 = Read_Short(Target_P4);
    int x2 = Read_Short(Target_P4+2);
    
    int y1 = Read_Short(Target_P4+8);
    int y2 = Read_Short(Target_P4+10);
    
    return {(float)(x1-x2)/(float)1000,(float)(y1-y2)/(float)1000};
}

bool GetKillActivate(long P_Skill)
{
    if (Read_Int(P_Skill+0x10)==0) return false;
    return Read_Int(P_Skill+0x34)==1;
}

void GetHeroSkill(long Target,bool *Skill1,bool *Skill2,bool *Skill3,bool *Skill4)
{
    long SkillList = Read_Long(Target+0xF8);
    long P_Skill1 = Read_Long(SkillList+0xD8);
    long P_Skill2 = Read_Long(SkillList+0xF0);
    long P_Skill3 = Read_Long(SkillList+0x108);
    long P_Skill4 = Read_Long(SkillList+0x150);
    
    
    *Skill1 = GetKillActivate(P_Skill1);
    *Skill2 = GetKillActivate(P_Skill2);
    *Skill3 = GetKillActivate(P_Skill3);
    *Skill4 = GetKillActivate(P_Skill4);
}

int GetPlayerTeam(long Target)
{
    return Read_Int(Target+0x2C);
}

bool GetPlayerDead(long Target)
{
    long PlayerHP = Read_Long(Target+0x110);
    return Read_Int(PlayerHP+0x98)==0;
}

int GetPlayerHero(long Target)
{
    return Read_Int(Target+0x20);
}
static float GetPlayerHeroHp(long Target)
{
    long PlayerHP = Read_Long(Target+0x110);
    
    int hp = Read_Int(PlayerHP+0x98) / 8192;
    
    int v5= Read_Int(PlayerHP+0xA8);

    if(hp == 0 || v5 == 0) return 0;
    
    return (float)hp/v5;
    
}
void GetPlayers(std::vector<SmobaHeroData> *Players)
{
    Players->clear();
    long PDatas = Read_Long(Read_Long(Game_Data)+0x390);
    if (PDatas > Imageaddress)
    {
        int MyTeam = ViewMatrix._11>0?1:2;
        long Array = Read_Long(PDatas+0x60);
        int ArraySize = Read_Int(PDatas+0x7C);
        if (ArraySize > 0 && ArraySize <= 20)
        {
            for (int i=0; i < ArraySize; i++) {
                long P_player = Read_Long(Array+i*0x18);
                if (P_player > Imageaddress)
                {
                    SmobaHeroData HeroData;
                    HeroData.HeroID = GetPlayerHero(P_player);
                    HeroData.HeroTeam = GetPlayerTeam(P_player);
                    HeroData.HeroXue = GetPlayerHeroHp(P_player);
                    HeroData.Dead = GetPlayerDead(P_player);
                    HeroData.Pos = GetPlayerPos(P_player);
                    GetHeroSkill(P_player,&HeroData.Skill1,&HeroData.Skill2,&HeroData.Skill3,&HeroData.Skill4);
                    if (HeroData.HeroTeam != MyTeam) Players->push_back(HeroData);
                }
            }
        }
    }
}

bool Gameinitialization()
{
    Imageaddress = _dyld_get_image_vmaddr_slide(0);
    Game_Data = Read_Long(Imageaddress+0x10ACEC258);
    Game_Viewport = Read_Long(Imageaddress+0x10BFF74B8);
    return Game_Data > Imageaddress && Game_Viewport > Imageaddress;
}

