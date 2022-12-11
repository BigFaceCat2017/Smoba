#import <UIKit/UIKit.h>
#include <vector>

struct Vector2
{
    float x,y;
};

struct Vector3
{
    float x,y,z;
};

struct Matrix
{
    float _11;
    float _12;
    float _13;
    float _14;
    float _21;
    float _22;
    float _23;
    float _24;
    float _31;
    float _32;
    float _33;
    float _34;
    float _41;
    float _42;
    float _43;
    float _44;
};

struct SmobaHeroData
{
    int HeroID;
    int HeroTeam;
    float HeroXue;
    Vector2 Pos;
    bool Dead;
    bool Skill1;
    bool Skill2;
    bool Skill3;
    bool Skill4;
};

struct SaveImage
{
    UIImage* Image;
    int HeroID;
};


bool Gameinitialization();
bool RefreshMatrix();
bool ToScreen(Vector2 GameCanvas,Vector2 HeroPos,Vector2* Screen);
Vector2 ToMiniMap(Vector2 MiniMap,Vector2 HeroPos);
void GetPlayers(std::vector<SmobaHeroData> *Players);
