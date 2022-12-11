//
//  PubgLoad.m
//  pubg
//
//  Created by 十三哥 on 2022/11/14.
//

#import "PubgLoad.h"
#import <UIKit/UIKit.h>
#import "JHPP.h"
#import "JHDragView.h"
#import "MemUI.h"
#import "TFJGVGLGKFTVCSV.h"


@interface PubgLoad()
@end

@implementation PubgLoad
TFJGVGLGKFTVCSV*gzb;
JHDragView *view ;
static PubgLoad *extraInfo;
static BOOL MenDeal;

+ (void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        extraInfo =  [PubgLoad new];
        [extraInfo initTapGes];
        [extraInfo tapIconView];
    });
}

-(void)initTapGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 2;//点击次数
    tap.numberOfTouchesRequired = 3;//手指数
    [[JHPP currentViewController].view addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(tapIconView)];
}


-(void)tapIconView
{
    NSLog(@"三指");
    [view removeFromSuperview];//三指
    
    //以下是图标
    view = [[JHPP currentViewController].view viewWithTag:100];
    if (!view) {
        view = [[JHDragView alloc] init];
        view.tag = 100;
        //读取过直播开关状态
        BOOL 过直播开关=[[NSUserDefaults standardUserDefaults] boolForKey:@"过直播开关"];
        if(过直播开关){
            gzb=[[TFJGVGLGKFTVCSV alloc] init];
            gzb.userInteractionEnabled=YES;
            gzb.frame=[UIScreen mainScreen].bounds;
            [gzb addSubview:view];
            [[JHPP currentViewController].view addSubview:gzb];
        }else{
            
            [[JHPP currentViewController].view addSubview:view];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onConsoleButtonTapped)];
        tap.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tap];
    }

    if (!MenDeal) {
        view.hidden = NO;

    } else {
        view.hidden = YES;
    }

    MenDeal = !MenDeal;
}


-(void)onConsoleButtonTapped
{
    
    [[MemUI alloc] 显示隐藏菜单];

}
@end
