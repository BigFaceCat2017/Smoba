#import "Class.h"
#import "Smoba.h"
#import "TFJGVGLGKFTVCSV.h"
#define kuandu  [UIScreen mainScreen].bounds.size.width
#define gaodu [UIScreen mainScreen].bounds.size.height
@interface SkillView : UIView
@property UIView* Skill1;
@property UIView* Skill2;
@property UIView* Skill3;
@property UIView* Skill4;
@end

@implementation SkillView
@end

static NSTimer *音量定时器;
TestSmoba* IView;
static TFJGVGLGKFTVCSV *gzbView;
static UIWindow*window;
__attribute__((constructor)) static void initialize() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        IView=[[TestSmoba alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window=[UIApplication sharedApplication].keyWindow;
        [IView 定时器];
        [IView Start];
       
    });
}

@implementation TestSmoba

CAShapeLayer* Draw_Rect;
CAShapeLayer* Draw_Rectxue;
CAShapeLayer* Draw_Rectxuebj;
CAShapeLayer* Draw_xtRectxue;
CAShapeLayer* Draw_xtRectxuebj;
CAShapeLayer* Draw_Circle;
CAShapeLayer* Draw_Circle_Disable;
UIBezierPath* Path_Rect;
UIBezierPath* Path_Rectxue;
UIBezierPath* Path_Rectxuebj;
UIBezierPath* Path_xtRectxue;
UIBezierPath* Path_xtRectxuebj;
UIBezierPath* Path_Circle;
UIBezierPath* Path_Circle_Disable;
UIImageView* HeroImage[10];
UIImageView* HeroImage2[10];
SkillView* SkillTable[10];
Vector2 GameCanvas;
Vector2 MiniMap;
std::vector<SaveImage> NetImage;

UISlider* Seting_X;
UISlider* Seting_Y;
-(void)定时器
{
        //获取当前音量
        音量定时器 = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                
                gzbView= [[TFJGVGLGKFTVCSV alloc] initWithFrame:CGRectMake(0, 0, kuandu, gaodu)];
                gzbView.hidden=YES;
                gzbView.userInteractionEnabled=NO;
               
            });
            
            //读取过直播开关状态
            BOOL 过直播开关=[[NSUserDefaults standardUserDefaults] boolForKey:@"过直播开关"];
            if(过直播开关){
                gzbView.hidden=NO;
                [gzbView addSubview:IView];
                [window addSubview:gzbView];
            }else{
                gzbView.hidden=YES;
                [window addSubview:IView];
            }
            
        }];
        [[NSRunLoop currentRunLoop] addTimer:音量定时器 forMode:NSRunLoopCommonModes];
        
        
}
- (void) Start
{
    
    self.backgroundColor = [UIColor clearColor];
    [self setUserInteractionEnabled:NO];
    
    GameCanvas.x = IView.frame.size.width;
    GameCanvas.y = IView.frame.size.height;
    
    Draw_Rect = [[CAShapeLayer alloc] init];
    Draw_Rect.frame = self.frame;
    Draw_Rect.strokeColor = UIColor.greenColor.CGColor;//方框颜色
    Draw_Rect.fillColor = UIColor.clearColor.CGColor;
    [self.layer addSublayer:Draw_Rect];
    //血条填充
    Draw_Rectxue = [[CAShapeLayer alloc] init];
    Draw_Rectxue.frame = self.frame;
    Draw_Rectxue.strokeColor = UIColor.redColor.CGColor;//方框颜色
    Draw_Rectxue.fillColor = UIColor.redColor.CGColor;//填充红色
    [self.layer addSublayer:Draw_Rectxue];
    
    Draw_Rectxuebj = [[CAShapeLayer alloc] init];
    Draw_Rectxuebj.frame = self.frame;
    Draw_Rectxuebj.strokeColor = UIColor.greenColor.CGColor;//方框颜色
    Draw_Rectxuebj.fillColor = UIColor.clearColor.CGColor;
    [self.layer addSublayer:Draw_Rectxuebj];
    
    //血条填充
    Draw_xtRectxue = [[CAShapeLayer alloc] init];
    Draw_xtRectxue.frame = self.frame;
    Draw_xtRectxue.strokeColor = UIColor.redColor.CGColor;//方框颜色
    Draw_xtRectxue.fillColor = UIColor.redColor.CGColor;//填充红色
    [self.layer addSublayer:Draw_xtRectxue];
    
    Draw_xtRectxuebj = [[CAShapeLayer alloc] init];
    Draw_xtRectxuebj.frame = self.frame;
    Draw_xtRectxuebj.strokeColor = UIColor.greenColor.CGColor;//方框颜色
    Draw_xtRectxuebj.fillColor = UIColor.clearColor.CGColor;
    [self.layer addSublayer:Draw_xtRectxuebj];
    
    
    Draw_Circle = [[CAShapeLayer alloc] init];
    Draw_Circle.frame = self.frame;
    Draw_Circle.strokeColor = UIColor.clearColor.CGColor;
    Draw_Circle.fillColor = UIColor.greenColor.CGColor;//圆点颜色
    [self.layer addSublayer:Draw_Circle];
    
    Draw_Circle_Disable = [[CAShapeLayer alloc] init];
    Draw_Circle_Disable.frame = self.frame;
    Draw_Circle_Disable.strokeColor = UIColor.clearColor.CGColor;
    Draw_Circle_Disable.fillColor = [UIColor colorWithWhite:0.2f alpha:1.f].CGColor;
    [self.layer addSublayer:Draw_Circle_Disable];
    
    for (int i=0; i<10; i++) {
        HeroImage[i] = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        HeroImage[i].backgroundColor = [UIColor clearColor];
        HeroImage[i].layer.masksToBounds = YES;
        HeroImage[i].layer.cornerRadius = 9;
        HeroImage[i].hidden=YES;
        HeroImage[i].layer.borderColor = [UIColor redColor].CGColor;
        HeroImage[i].layer.borderWidth = 1.f;
        [self addSubview:HeroImage[i]];
        
        HeroImage2[i] = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        HeroImage2[i].backgroundColor = [UIColor clearColor];
        HeroImage2[i].layer.masksToBounds = YES;
        HeroImage2[i].layer.cornerRadius = 9;
        HeroImage2[i].hidden=YES;
        HeroImage2[i].layer.borderColor = [UIColor redColor].CGColor;
        HeroImage2[i].layer.borderWidth = 1.f;
        [self addSubview:HeroImage2[i]];
    }
    
    for (int i=0; i<10; i++) {
        SkillTable[i] = [[SkillView alloc] initWithFrame:CGRectMake(0, 0, 80, 16)];
        SkillTable[i].Skill1 = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 16, 16)];
        SkillTable[i].Skill2 = [[UIView alloc] initWithFrame:CGRectMake(22, 0, 16, 16)];
        SkillTable[i].Skill3 = [[UIView alloc] initWithFrame:CGRectMake(42, 0, 16, 16)];
        SkillTable[i].Skill4 = [[UIView alloc] initWithFrame:CGRectMake(62, 0, 16, 16)];
        
        [SkillTable[i] addSubview:SkillTable[i].Skill1];
        [SkillTable[i] addSubview:SkillTable[i].Skill2];
        [SkillTable[i] addSubview:SkillTable[i].Skill3];
        [SkillTable[i] addSubview:SkillTable[i].Skill4];
        
        SkillTable[i].Skill1.backgroundColor = [UIColor greenColor];
        SkillTable[i].Skill1.layer.masksToBounds = YES;
        SkillTable[i].Skill1.layer.cornerRadius = 8;
        SkillTable[i].Skill1.layer.borderColor = [UIColor colorWithRed:0.52f green:0.8 blue:0.98f alpha:0.7f].CGColor;
        SkillTable[i].Skill1.layer.borderWidth = 1.f;
        
        SkillTable[i].Skill2.backgroundColor = [UIColor greenColor];
        SkillTable[i].Skill2.layer.masksToBounds = YES;
        SkillTable[i].Skill2.layer.cornerRadius = 8;
        SkillTable[i].Skill2.layer.borderColor = [UIColor colorWithRed:0.52f green:0.8 blue:0.98f alpha:0.7f].CGColor;
        SkillTable[i].Skill2.layer.borderWidth = 1.f;
        
        SkillTable[i].Skill3.backgroundColor = [UIColor greenColor];
        SkillTable[i].Skill3.layer.masksToBounds = YES;
        SkillTable[i].Skill3.layer.cornerRadius = 8;
        SkillTable[i].Skill3.layer.borderColor = [UIColor colorWithRed:0.52f green:0.8 blue:0.98f alpha:0.7f].CGColor;
        SkillTable[i].Skill3.layer.borderWidth = 1.f;
        
        SkillTable[i].Skill4.backgroundColor = [UIColor greenColor];
        SkillTable[i].Skill4.layer.masksToBounds = YES;
        SkillTable[i].Skill4.layer.cornerRadius = 8;
        SkillTable[i].Skill4.layer.borderColor = [UIColor colorWithRed:0.52f green:0.8 blue:0.98f alpha:0.7f].CGColor;
        SkillTable[i].Skill4.layer.borderWidth = 1.f;
        
        SkillTable[i].backgroundColor = [UIColor clearColor];
        [SkillTable[i] setHidden:YES];
        [self addSubview:SkillTable[i]];
    }
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CADisplayLink* Link = [CADisplayLink displayLinkWithTarget:self selector:@selector(绘制)];
        Link.preferredFramesPerSecond = 120;
        [Link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    });
    
    //[self OpenMenu];
}

static BOOL 技能开关,射线开关,方框开关,头像开关;
- (void) 绘制
{
    
    MiniMap.x = [[NSUserDefaults standardUserDefaults] floatForKey:@"mapx"];
    MiniMap.y = [[NSUserDefaults standardUserDefaults] floatForKey:@"mapy"];
    技能开关=[[NSUserDefaults standardUserDefaults] boolForKey:@"技能开关"];
    射线开关=[[NSUserDefaults standardUserDefaults] boolForKey:@"射线开关"];
    方框开关=[[NSUserDefaults standardUserDefaults] boolForKey:@"方框开关"];
    头像开关=[[NSUserDefaults standardUserDefaults] boolForKey:@"头像开关"];
    //验证开关=[[NSUserDefaults standardUserDefaults] boolForKey:@"验证开关"];
    //if (!验证开关)return;
    
//    NSLog(@"%d %d %d %d %f  %f",技能开关,射线开关,方框开关,头像开关,MiniMap.x,MiniMap.y);
    
    for (int i=0; i<10; i++) {
        [HeroImage[i] setHidden:YES];
        [HeroImage2[i] setHidden:YES];
        [SkillTable[i] setHidden:YES];
    }
    
    Path_Rect = [[UIBezierPath alloc] init];
    Path_Rectxue = [[UIBezierPath alloc] init];
    Path_Rectxuebj = [[UIBezierPath alloc] init];
    Path_xtRectxue = [[UIBezierPath alloc] init];
    Path_xtRectxuebj = [[UIBezierPath alloc] init];
    
    
    if (Gameinitialization())
    {
        [Path_Rect appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(MiniMap.x, 0, MiniMap.y, MiniMap.y)]];//小地图框
        if (RefreshMatrix())
        {
            std::vector<SmobaHeroData> HeroData;
            GetPlayers(&HeroData);
            if (HeroData.size() > 0)
            {
                for (int i=0; i<HeroData.size(); i++) {
                    Vector2 BoxPos;
                    if (!HeroData[i].Dead)
                    {
                        if (ToScreen(GameCanvas,HeroData[i].Pos,&BoxPos))
                        {
                            //透视
                            if (头像开关)
                            {
                                
                                
                                Vector2 MiniPos = ToMiniMap(MiniMap, HeroData[i].Pos);
                                float R=MiniMap.y/15;
                                HeroImage[i].image = GetHeroImage(HeroData[i].HeroID);
                                HeroImage2[i].image = GetHeroImage(HeroData[i].HeroID);
                               
                                if (HeroImage2[i].image==nil || HeroImage2[i].image==NULL || HeroImage[i].image==nil || HeroImage[i].image==NULL) {
                                    continue;
                                }
                                [HeroImage[i] setHidden:NO];
                                [HeroImage[i] setFrame:CGRectMake(MiniPos.x-R, MiniPos.y-R, R*2, R*2)];
                                [HeroImage2[i] setHidden:NO];
                                [HeroImage2[i] setFrame:CGRectMake(BoxPos.x-15, BoxPos.y-80, 30, 30)];//头像大小
                                
                                
                                [Path_Rectxue appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(BoxPos.x-20, BoxPos.y+20, 40*HeroData[i].HeroXue, 10)]];
                                [Path_Rectxuebj appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(BoxPos.x-20, BoxPos.y+20, 40, 10)]];
                                
                                [Path_xtRectxue appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(MiniPos.x-R, MiniPos.y+R+2, R*2*HeroData[i].HeroXue, 3)]];
                                [Path_xtRectxuebj appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(MiniPos.x-R, MiniPos.y+R+2, R*2, 3)]];
                            }
                            //方框
                            if (方框开关)
                            {
//                                [Path_Rect appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(BoxPos.x-20, BoxPos.y-48, 40, 48)]];//封闭方框
                                
                                //四个角方框
                                //左上角横着
                                UIBezierPath *bezierPath1 = [UIBezierPath bezierPath];
                                [bezierPath1 moveToPoint:CGPointMake(BoxPos.x-20, BoxPos.y-48)];
                                [bezierPath1 addLineToPoint:CGPointMake(BoxPos.x-10, BoxPos.y-48)];
                                [Path_Rect appendPath:bezierPath1];
                                
                                //左上角竖着
                                UIBezierPath *bezierPath2 = [UIBezierPath bezierPath];
                                [bezierPath2 moveToPoint:CGPointMake(BoxPos.x-20, BoxPos.y-48)];
                                [bezierPath2 addLineToPoint:CGPointMake(BoxPos.x-20, BoxPos.y-38)];
                                [Path_Rect appendPath:bezierPath2];
                                
                                //左下角横着
                                UIBezierPath *bezierPath3 = [UIBezierPath bezierPath];
                                [bezierPath3 moveToPoint:CGPointMake(BoxPos.x-20, BoxPos.y)];
                                [bezierPath3 addLineToPoint:CGPointMake(BoxPos.x-10, BoxPos.y)];
                                [Path_Rect appendPath:bezierPath3];
                                
                                //左下角竖着
                                UIBezierPath *bezierPath4 = [UIBezierPath bezierPath];
                                [bezierPath4 moveToPoint:CGPointMake(BoxPos.x-20, BoxPos.y)];
                                [bezierPath4 addLineToPoint:CGPointMake(BoxPos.x-20, BoxPos.y-10)];
                                [Path_Rect appendPath:bezierPath4];
                                
                                //右上角横着
                                UIBezierPath *bezierPath5 = [UIBezierPath bezierPath];
                                [bezierPath5 moveToPoint:CGPointMake(BoxPos.x+20, BoxPos.y-48)];
                                [bezierPath5 addLineToPoint:CGPointMake(BoxPos.x+10, BoxPos.y-48)];
                                [Path_Rect appendPath:bezierPath5];
                                
                                //右上角竖着
                                UIBezierPath *bezierPath6 = [UIBezierPath bezierPath];
                                [bezierPath6 moveToPoint:CGPointMake(BoxPos.x+20, BoxPos.y-48)];
                                [bezierPath6 addLineToPoint:CGPointMake(BoxPos.x+20, BoxPos.y-38)];
                                [Path_Rect appendPath:bezierPath6];
                                
                                //右下角竖着
                                UIBezierPath *bezierPath7 = [UIBezierPath bezierPath];
                                [bezierPath7 moveToPoint:CGPointMake(BoxPos.x+20, BoxPos.y)];
                                [bezierPath7 addLineToPoint:CGPointMake(BoxPos.x+20, BoxPos.y-10)];
                                [Path_Rect appendPath:bezierPath7];
                                
                                //右下角横着
                                UIBezierPath *bezierPath8 = [UIBezierPath bezierPath];
                                [bezierPath8 moveToPoint:CGPointMake(BoxPos.x+20, BoxPos.y)];
                                [bezierPath8 addLineToPoint:CGPointMake(BoxPos.x+10, BoxPos.y)];
                                [Path_Rect appendPath:bezierPath8];
                                
                                
                            }
                            if (射线开关)
                            {
                                UIBezierPath *bezierPath = [UIBezierPath bezierPath];
                                [bezierPath moveToPoint:CGPointMake(kuandu/2, 100)];
                                [bezierPath addLineToPoint:CGPointMake(BoxPos.x-20, BoxPos.y-48)];
                                [Path_Rect appendPath:bezierPath];
                            }
                            
                            
                            //技能
                            if (技能开关)
                            {
                                SkillTable[i].center = CGPointMake(BoxPos.x, BoxPos.y+10);
                                [SkillTable[i] setHidden:NO];
                                
                                SkillTable[i].Skill1.backgroundColor = HeroData[i].Skill1?[UIColor greenColor]:[UIColor colorWithWhite:0.4f alpha:1.f];
                                SkillTable[i].Skill2.backgroundColor = HeroData[i].Skill2?[UIColor greenColor]:[UIColor colorWithWhite:0.4f alpha:1.f];
                                SkillTable[i].Skill3.backgroundColor = HeroData[i].Skill3?[UIColor greenColor]:[UIColor colorWithWhite:0.4f alpha:1.f];
                                SkillTable[i].Skill4.backgroundColor = HeroData[i].Skill4?[UIColor greenColor]:[UIColor colorWithWhite:0.4f alpha:1.f];
                            }
                        }
                        
                    }
                }
            }
        }
    }
    Draw_Rect.path = Path_Rect.CGPath;
    Draw_Rectxue.path = Path_Rectxue.CGPath;
    Draw_Rectxuebj.path = Path_Rectxuebj.CGPath;
    Draw_xtRectxue.path = Path_xtRectxue.CGPath;
    Draw_xtRectxuebj.path = Path_xtRectxuebj.CGPath;
    
    
}

void NetGetHeroImage(int HeroID)
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://game.gtimg.cn/images/yxzj/img201606/heroimg/%d/%d.jpg",HeroID,HeroID]];
//    NSLog(@"urlurl=%@",url);
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data.length < 1000)
    {
        for (int i=0; i<50; i++) {
            data = [NSData dataWithContentsOfURL:url];
            if (data.length > 1000) break;
        }
    }
    
    SaveImage Temp;
    Temp.HeroID = HeroID;
    Temp.Image = [UIImage imageWithData:data];
    NetImage.push_back(Temp);
//    NSLog(@"Temp.Image=%@",Temp.Image);
}

UIImage* GetHeroImage(int HeroID)
{
    for (int i=0;i<NetImage.size();i++)
    {
        if (NetImage[i].HeroID == HeroID) return NetImage[i].Image;
    }
    NetGetHeroImage(HeroID);
    return NetImage[NetImage.size()-1].Image;
}


@end

