//
//  ViewController.h
//  Radar
//
//  Created by 十三哥 on 2022/8/19.
//

#import "MemUI.h"
#import "Smoba.h"
#import "SpringBoard.h"
#import "TFJGVGLGKFTVCSV.h"
#import <AVFoundation/AVFoundation.h>

#import "SpringBoard.h"
#import "vm_writeData.h"
#include <JRMemory/MemScan.h>

#define kuandu  [UIScreen mainScreen].bounds.size.width
#define gaodu [UIScreen mainScreen].bounds.size.height

@interface MemUI()

@end

@implementation MemUI
+ (void)load
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"9b8"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"9b0"];
        //注销后初始化几个开关状态
        语音开关=[[NSUserDefaults standardUserDefaults] boolForKey:@"语音开关"];
        过直播开关=[[NSUserDefaults standardUserDefaults] boolForKey:@"过直播开关"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"透视开关"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"验证开关"];//默认为NO 验证成功才为YES 测试的时候设置为YES
        [[MemUI alloc] 初始化菜单1配置];
        
    });
}
#pragma mark - 初始化一些控件=========
static NSTimer *音量定时器;

static MemUI *View;
static TFJGVGLGKFTVCSV *gzbView;
static UIScrollView *HDView[5];
static BOOL 显示隐藏,过直播开关,语音开关;
static UIWindow*window;
static MemUI *手势视图;
static UITextField*txtName;
static UILabel*dqlabel;
static UISlider *视距滑条;
static UISlider *地图x;
static UISlider *地图y;
static UILabel*视距label;
static float 搜索值;
#pragma mark - 初始化相关=========
-(void)初始化菜单1配置
{
    [[MemUI alloc] 定时器];
    [[MemUI alloc] 主菜单];
    搜索值 = 1.2;
}

-(void)定时器
{
    //获取当前音量
    音量定时器 = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        dqlabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"到期时间"];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            window=[UIApplication sharedApplication].keyWindow;
            gzbView= [[TFJGVGLGKFTVCSV alloc] initWithFrame:CGRectMake(0, 0, kuandu, gaodu)];
//            gzbView.backgroundColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
            gzbView.hidden=YES;
            gzbView.userInteractionEnabled=NO;
            [self bofang:@"欢迎使用 王者定制绘制"];
        });
       
        //读取过直播开关状态
        过直播开关=[[NSUserDefaults standardUserDefaults] boolForKey:@"过直播开关"];
        if(过直播开关){
            gzbView.hidden=NO;
            [gzbView addSubview:View];
            [window addSubview:gzbView];
        }else{
            gzbView.hidden=YES;
            [window addSubview:View];
        }
        
    }];
    [[NSRunLoop currentRunLoop] addTimer:音量定时器 forMode:NSRunLoopCommonModes];
    
    
}

#pragma mark - 视图相关=========
- (void)主菜单
{
    //背景视图
    gzbView= [[TFJGVGLGKFTVCSV alloc] init];
    View= [[MemUI alloc] init];
    View.userInteractionEnabled=YES;
    View.multipleTouchEnabled = YES;
    
    View.frame=CGRectMake(kuandu/2-150, 50, 350, 350);
    //默认桌面是竖屏 游戏横屏 旋转视图
    View.layer.cornerRadius=15;
    View.hidden=YES;//默认是隐藏的 音量键才开启
    View.layer.borderColor = [[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] CGColor];
    View.backgroundColor =  [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];//主菜单背景颜色
    
    
    //标题
    UILabel *BT = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, View.frame.size.width, 30)];
    BT.numberOfLines = 0;
    BT.lineBreakMode = NSLineBreakByCharWrapping;
    BT.text = @"跨进程绘制-WX:NongShiFu123";
    BT.textAlignment = NSTextAlignmentCenter;
    BT.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    BT.textColor = [UIColor redColor];
    [View addSubview:BT];
    
    //选项卡
    NSArray *array = [NSArray arrayWithObjects:@"功能",@"其他功能",@"公告",nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    segment.userInteractionEnabled=YES;
    segment.frame = CGRectMake(10, 40, View.frame.size.width-20, 30);
    segment.selectedSegmentIndex = 0;//默认选项卡
    segment.apportionsSegmentWidthsByContent = NO;
    segment.layer.cornerRadius = 20.00;//圆角
    //绑定点击事件
    [segment addTarget:self action:@selector(选项卡调用:) forControlEvents:UIControlEventValueChanged];
    [View addSubview:segment];
    [self 菜单1];
    [self 菜单2];
    [self 菜单3];
    
}
-(void)菜单1
{
    //第一个选项卡滑动视图
    HDView[0]= [[UIScrollView alloc] init];
    HDView[0].userInteractionEnabled=YES;
    HDView[0].hidden=NO;
    HDView[0].layer.cornerRadius=10;
    HDView[0].frame=CGRectMake(10, 80, View.frame.size.width-20, View.frame.size.height-80);//子视图按总视图大小一致
    HDView[0].backgroundColor =  [UIColor clearColor];
    //滑动的高度根据 按钮数量 10个按钮 每个50 =500
    HDView[0].contentSize=CGSizeMake(View.frame.size.width-20, 420);//滚动高度
    
    [View addSubview:HDView[0]];
    //开关控件
    for (int i=0; i<9; i++) {
        // 透视按钮背景
        UIView*fgx=[[UIView alloc] initWithFrame:CGRectMake(0, i*42, HDView[0].frame.size.width, 40)];
        fgx.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        fgx.layer.cornerRadius=10;
        fgx.layer.borderWidth = 0.1;
        fgx.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor];
        [HDView[0] addSubview:fgx];
    }
    
    //透视开关=================
    UISwitch*开关 = [[UISwitch alloc] init];
    开关.frame=CGRectMake(10, 5, 80, 40);//这个 x y 宽度 搞定 是基于上面的View视图中的 不是按屏幕
    BOOL 开关状态=[[NSUserDefaults standardUserDefaults] boolForKey:@"透视开关"];
    开关.on=开关状态;//设置开关状态
    //设置开启状态的风格颜色
    [开关 setOnTintColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:0.5]];
    //设置开关圆按钮的风格颜色
    [开关 setThumbTintColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:1]];
    //设置整体风格颜色,按钮的白色是整个父布局的背景颜色
    [开关 setTintColor:[UIColor redColor]];
    //p3:事件响应时的事件类型UIControlEventValueChanged状态发生变化时触发函数
    [开关 addTarget:self action:@selector(透视调用:) forControlEvents:UIControlEventValueChanged];
    [HDView[0] addSubview:开关];//添加到视图上显示
    //透视文字
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, HDView[0].frame.size.width-120, 40)];
    label.text=@"绘制透视";
    label.textColor=[UIColor blackColor];
    label.numberOfLines = 2;//行数
    //设置文字字体大小
    label.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
    label.textAlignment = NSTextAlignmentRight;//居中
    //设置文字颜色
    label.textColor=[UIColor blackColor];
    [HDView[0] addSubview:label]; //将label 显示在屏幕上''
    
    //方框====================
    UISwitch*方框 = [[UISwitch alloc] init];
    方框.frame=CGRectMake(10, 44, 80, 40);//这个 x y 宽度 搞定 是基于上面的View视图中的 不是按屏幕
    BOOL 方框开关状态=[[NSUserDefaults standardUserDefaults] boolForKey:@"方框开关"];
    方框.on=方框开关状态;//设置开关状态
    //设置开启状态的风格颜色
    [方框 setOnTintColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:0.5]];
    //设置开关圆按钮的风格颜色
    [方框 setThumbTintColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:1]];
    //设置整体风格颜色,按钮的白色是整个父布局的背景颜色
    [方框 setTintColor:[UIColor redColor]];
    //p3:事件响应时的事件类型UIControlEventValueChanged状态发生变化时触发函数
    [方框 addTarget:self action:@selector(方框调用:) forControlEvents:UIControlEventValueChanged];
    [HDView[0] addSubview:方框];//添加到视图上显示
    //方框文字
    UILabel*labelfk=[[UILabel alloc] initWithFrame:CGRectMake(100, 44, HDView[0].frame.size.width-120, 40)];
    labelfk.text=@"方框";
    labelfk.textColor=[UIColor blackColor];
    labelfk.numberOfLines = 2;//行数
    //设置文字字体大小
    labelfk.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
    labelfk.textAlignment = NSTextAlignmentRight;//居中
    //设置文字颜色
    labelfk.textColor=[UIColor blackColor];
    [HDView[0] addSubview:labelfk]; //将label 显示在屏幕上''
    
    //技能========================
    UISwitch*技能 = [[UISwitch alloc] init];
    技能.frame=CGRectMake(10, 86, 80, 40);//这个 x y 宽度 搞定 是基于上面的View视图中的 不是按屏幕
    BOOL 技能开关状态=[[NSUserDefaults standardUserDefaults] boolForKey:@"技能开关"];
    技能.on=技能开关状态;//设置开关状态
    //设置开启状态的风格颜色
    [技能 setOnTintColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:0.5]];
    //设置开关圆按钮的风格颜色
    [技能 setThumbTintColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:1]];
    //设置整体风格颜色,按钮的白色是整个父布局的背景颜色
    [技能 setTintColor:[UIColor redColor]];
    //p3:事件响应时的事件类型UIControlEventValueChanged状态发生变化时触发函数
    [技能 addTarget:self action:@selector(技能调用:) forControlEvents:UIControlEventValueChanged];
    [HDView[0] addSubview:技能];//添加到视图上显示
    //技能
    UILabel*labeljn=[[UILabel alloc] initWithFrame:CGRectMake(100, 86, HDView[0].frame.size.width-120, 40)];
    labeljn.text=@"技能";
    labeljn.textColor=[UIColor blackColor];
    labeljn.numberOfLines = 2;//行数
    //设置文字字体大小
    labeljn.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
    labeljn.textAlignment = NSTextAlignmentRight;//居中
    //设置文字颜色
    labeljn.textColor=[UIColor blackColor];
    [HDView[0] addSubview:labeljn]; //将label 显示在屏幕上''
    
    //射线=================
    UISwitch*射线 = [[UISwitch alloc] init];
    射线.frame=CGRectMake(10, 128, 80, 40);//这个 x y 宽度 搞定 是基于上面的View视图中的 不是按屏幕
    BOOL 射线开关状态=[[NSUserDefaults standardUserDefaults] boolForKey:@"射线开关"];
    射线.on=射线开关状态;//设置开关状态
    //设置开启状态的风格颜色
    [射线 setOnTintColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:0.5]];
    //设置开关圆按钮的风格颜色
    [射线 setThumbTintColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:1]];
    //设置整体风格颜色,按钮的白色是整个父布局的背景颜色
    [射线 setTintColor:[UIColor redColor]];
    //p3:事件响应时的事件类型UIControlEventValueChanged状态发生变化时触发函数
    [射线 addTarget:self action:@selector(射线调用:) forControlEvents:UIControlEventValueChanged];
    [HDView[0] addSubview:射线];//添加到视图上显示
    //射线文字
    UILabel*labelsx=[[UILabel alloc] initWithFrame:CGRectMake(100, 128, HDView[0].frame.size.width-120, 40)];
    labelsx.text=@"射线";
    labelsx.textColor=[UIColor blackColor];
    labelsx.numberOfLines = 2;//行数
    //设置文字字体大小
    labelsx.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
    labelsx.textAlignment = NSTextAlignmentRight;//居中
    //设置文字颜色
    labelsx.textColor=[UIColor blackColor];
    [HDView[0] addSubview:labelsx]; //将label 显示在屏幕上''
    
    //2视距开关==========
    UISwitch*头像开关 = [[UISwitch alloc] init];
    头像开关.frame=CGRectMake(10, 170, 84, 40);//这个 x y 宽度 搞定 是基于上面的View视图中的 不是按屏幕
    BOOL 头像开关状态=[[NSUserDefaults standardUserDefaults] boolForKey:@"头像开关"];
    头像开关.on=头像开关状态;//设置开关状态
    //设置开启状态的风格颜色
    [头像开关 setOnTintColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:0.5]];
    //设置开关圆按钮的风格颜色
    [头像开关 setThumbTintColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:1]];
    //设置整体风格颜色,按钮的白色是整个父布局的背景颜色
    [头像开关 setTintColor:[UIColor redColor]];
    //p3:事件响应时的事件类型UIControlEventValueChanged状态发生变化时触发函数
    [头像开关 addTarget:self action:@selector(头像开启调用:) forControlEvents:UIControlEventValueChanged];
    [HDView[0] addSubview:头像开关];//添加到视图上显示
    //2视距文字
    UILabel*labela=[[UILabel alloc] initWithFrame:CGRectMake(100, 170, HDView[0].frame.size.width-120, 40)];
    labela.text=@"头像开关";
    labela.textColor=[UIColor blackColor];
    labela.numberOfLines = 2;//行数
    //设置文字字体大小
    labela.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
    labela.textAlignment = NSTextAlignmentRight;//居中
    //设置文字颜色
    labela.textColor=[UIColor blackColor];
    [HDView[0] addSubview:labela]; //将label 显示在屏幕上''
    
    
    //视距滑条============
    视距滑条=[[UISlider alloc]initWithFrame:CGRectMake(10, 210, HDView[0].frame.size.width-110, 40)];
    视距滑条.backgroundColor = [UIColor clearColor];//滑条背景色
    视距滑条.userInteractionEnabled=YES;
    视距滑条.minimumValue=1.2;//滑条最小值
    视距滑条.maximumValue=10;//滑条最大值
    视距滑条.value=1.2;
    视距滑条.minimumTrackTintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1]; //背景变色
    视距滑条.maximumTrackTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    视距滑条.thumbTintColor = [UIColor colorWithRed:1 green:0 blue:6 alpha:1];//滑块色
    视距滑条.transform = CGAffineTransformMakeScale(1, 1);//缩放
    [视距滑条 addTarget:self action:@selector(滑动时候调用:) forControlEvents:UIControlEventValueChanged];
    [视距滑条 addTarget:self action:@selector(滑动结束调用:) forControlEvents:UIControlEventTouchUpInside];
    [HDView[0] addSubview:视距滑条]; //将label 显示在屏幕上''
    //视距滑条文字
    视距label=[[UILabel alloc] initWithFrame:CGRectMake(100, 210, HDView[0].frame.size.width-120, 40)];
    视距label.text=@"视距";
    视距label.textColor=[UIColor blackColor];
    视距label.numberOfLines = 2;//行数
    //设置文字字体大小
    视距label.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
    视距label.textAlignment = NSTextAlignmentRight;//居中
    //设置文字颜色
    视距label.textColor=[UIColor blackColor];
    [HDView[0] addSubview:视距label]; //将label 显示在屏幕上''
    
    
    
    //地图x滑条=================
    地图x=[[UISlider alloc]initWithFrame:CGRectMake(10, 252, HDView[0].frame.size.width-110, 40)];
    地图x.backgroundColor = [UIColor clearColor];//滑条背景色
    地图x.userInteractionEnabled=YES;
    地图x.minimumValue=0;//滑条最小值
    地图x.maximumValue=400;//滑条最大值
    地图x.value=30;
    地图x.minimumTrackTintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1]; //背景变色
    地图x.maximumTrackTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    地图x.thumbTintColor = [UIColor colorWithRed:1 green:0 blue:6 alpha:1];//滑块色
    地图x.transform = CGAffineTransformMakeScale(1, 1);//缩放
    [地图x addTarget:self action:@selector(地图x调用:) forControlEvents:UIControlEventValueChanged];
    [HDView[0] addSubview:地图x]; //将label 显示在屏幕上''
    
    //地图x文字
    UILabel*labelax=[[UILabel alloc] initWithFrame:CGRectMake(100, 252, HDView[0].frame.size.width-120, 40)];
    labelax.text=@"地图横轴";
    labelax.textColor=[UIColor blackColor];
    labelax.numberOfLines = 2;//行数
    //设置文字字体大小
    labelax.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
    labelax.textAlignment = NSTextAlignmentRight;//居中
    //设置文字颜色
    labelax.textColor=[UIColor blackColor];
    [HDView[0] addSubview:labelax]; //将label 显示在屏幕上''
    
    
    
    
    //地图y滑条=================
    地图y=[[UISlider alloc]initWithFrame:CGRectMake(10, 294, HDView[0].frame.size.width-110, 40)];
    地图y.backgroundColor = [UIColor clearColor];//滑条背景色
    地图y.userInteractionEnabled=YES;
    地图y.minimumValue=0;//滑条最小值
    地图y.maximumValue=300;//滑条最大值
    地图y.value=0;
    地图y.minimumTrackTintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1]; //背景变色
    地图y.maximumTrackTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    地图y.thumbTintColor = [UIColor colorWithRed:1 green:0 blue:6 alpha:1];//滑块色
    地图y.transform = CGAffineTransformMakeScale(1, 1);//缩放
    [地图y addTarget:self action:@selector(地图y调用:) forControlEvents:UIControlEventValueChanged];
    [HDView[0] addSubview:地图y]; //将label 显示在屏幕上''
    //地图y滑条文字
    UILabel*labelay=[[UILabel alloc] initWithFrame:CGRectMake(100, 294, HDView[0].frame.size.width-120, 40)];
    labelay.text=@"地图大小";
    labelay.textColor=[UIColor blackColor];
    labelay.numberOfLines = 2;//行数
    //设置文字字体大小
    labelay.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
    labelay.textAlignment = NSTextAlignmentRight;//居中
    //设置文字颜色
    labelay.textColor=[UIColor blackColor];
    [HDView[0] addSubview:labelay]; //将label 显示在屏幕上''
    
    
    
    
}
static NSInteger 绘制频率选项卡;
-(void)菜单2
{
    //菜单2 不读取配置 个性化存储
    int 菜单2列表数量=5;
    //第2个选项卡滑动视图
    HDView[1]= [[UIScrollView alloc] init];
    HDView[1].userInteractionEnabled=YES;
    HDView[1].hidden=YES;//第二个选项卡默认隐藏
    HDView[1].layer.cornerRadius=10;
    HDView[1].frame=CGRectMake(10, 80, View.frame.size.width-20, View.frame.size.height-80);//子视图按总视图大小一致
    HDView[1].backgroundColor =  [UIColor clearColor];
    HDView[1].contentSize=CGSizeMake(View.frame.size.width-20, 50*7);
    
    for (int i=0; i<菜单2列表数量; i++) {
        // 按钮背景
        UIView*fgx=[[UIView alloc] initWithFrame:CGRectMake(0, i*42, HDView[1].frame.size.width, 40)];
        fgx.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        fgx.layer.cornerRadius=10;
        fgx.layer.borderWidth = 0.1;
        fgx.userInteractionEnabled=YES;
        fgx.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor];
        [HDView[1] addSubview:fgx];
        //验证输入框
        NSString*dqsj=[[NSUserDefaults standardUserDefaults] objectForKey:@"到期时间"];
        if (i==0) {
            if(dqsj.length>5 && ![dqsj containsString:@"2099"]){
                dqlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, i*42, HDView[1].frame.size.width-20, 40)];
                dqlabel.text=dqsj;
                dqlabel.textColor=[UIColor blackColor];
                dqlabel.numberOfLines = 2;//行数
                //设置文字字体大小
                dqlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
                dqlabel.textAlignment = NSTextAlignmentCenter;//居中
                //设置文字颜色
                dqlabel.textColor=[UIColor blackColor];
                [HDView[1] addSubview:dqlabel]; //将label 显示在屏幕上''
                
                
            }else{
                txtName=[[UITextField alloc] initWithFrame:CGRectMake(0, i*42, HDView[1].frame.size.width, 40)];
                txtName.placeholder = @"请复制激活码-粘贴到这";
                txtName.borderStyle = UITextBorderStyleRoundedRect;
                txtName.clearButtonMode = UITextFieldViewModeAlways;
                txtName.keyboardType = UIKeyboardTypeDefault;//默认键盘
                txtName.returnKeyType =UIReturnKeyDefault;//确认键
                txtName.layer.masksToBounds=YES;
                txtName.delegate = self;
                txtName.layer.borderWidth = 0.1;
                txtName.layer.cornerRadius = 10;
                txtName.layer.borderColor = [UIColor blackColor].CGColor;
                txtName.enabled = YES;
                [HDView[1] addSubview:txtName]; //将label 显示在屏幕
            }
            
        }
        //激活和公告
        if (i==1) {
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置button的坐标和位置大小
            btn.frame = CGRectMake(10, i*42, HDView[1].frame.size.width-20, 40);
            //设置button的默认状态下显示的文字
            NSString*公告=[[NSUserDefaults standardUserDefaults] objectForKey:@"公告"];
            [btn setTitle:公告 forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            //设置button风格颜色
            [btn setTintColor:[UIColor clearColor]];
            //设置button中文字大小
            btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
            //设置button的背景颜色
            btn.backgroundColor = [UIColor clearColor];
            
            [HDView[1] addSubview:btn]; //将label 显示在屏幕上''
            
        }
        
        //过直播开关
        if (i==2) {
            UISwitch*开关 = [[UISwitch alloc] init];
            开关.frame=CGRectMake(10, i*42+5, 80, 40);//这个 x y 宽度 搞定 是基于上面的View视图中的 不是按屏幕
            开关.tag=i;//设置一个编号 区分哪个开关
            开关.on=过直播开关;//设置开关状态
            //设置开启状态的风格颜色
            [开关 setOnTintColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:0.5]];
            //设置开关圆按钮的风格颜色
            [开关 setThumbTintColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:1]];
            //设置整体风格颜色,按钮的白色是整个父布局的背景颜色
            [开关 setTintColor:[UIColor redColor]];
            //p3:事件响应时的事件类型UIControlEventValueChanged状态发生变化时触发函数
            [开关 addTarget:self action:@selector(过直播开关调用:) forControlEvents:UIControlEventValueChanged];
            [HDView[1] addSubview:开关];//添加到视图上显示
            
            UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(100, i*42+3, HDView[0].frame.size.width-120, 40)];
            label.text=@"直播开关";
            label.textColor=[UIColor blackColor];
            label.numberOfLines = 2;//行数
            //设置文字字体大小
            label.font = [UIFont fontWithName:@"AlNile-Bold" size:15];
            label.textAlignment = NSTextAlignmentRight;//居中
            //设置文字颜色
            label.textColor=[UIColor orangeColor];
            [HDView[1] addSubview:label]; //将label 显示在屏幕上''
        }
        
        //语音开关
        if (i==3) {
            UISwitch*开关 = [[UISwitch alloc] init];
            开关.frame=CGRectMake(10, i*42+5, 80, 40);//这个 x y 宽度 搞定 是基于上面的View视图中的 不是按屏幕
            开关.tag=i;//设置一个编号 区分哪个开关
            开关.on=语音开关;//设置开关状态
            //设置开启状态的风格颜色
            [开关 setOnTintColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:0.5]];
            //设置开关圆按钮的风格颜色
            [开关 setThumbTintColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:1]];
            //设置整体风格颜色,按钮的白色是整个父布局的背景颜色
            [开关 setTintColor:[UIColor redColor]];
            //p3:事件响应时的事件类型UIControlEventValueChanged状态发生变化时触发函数
            [开关 addTarget:self action:@selector(语音开关调用:) forControlEvents:UIControlEventValueChanged];
            [HDView[1] addSubview:开关];//添加到视图上显示
            
            UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(100, i*42+3, HDView[0].frame.size.width-120, 40)];
            label.text=@"语音开关";
            label.textColor=[UIColor blackColor];
            label.numberOfLines = 2;//行数
            //设置文字字体大小
            label.font = [UIFont fontWithName:@"AlNile-Bold" size:15];
            label.textAlignment = NSTextAlignmentRight;//居中
            //设置文字颜色
            label.textColor=[UIColor orangeColor];
            [HDView[1] addSubview:label]; //将label 显示在屏幕上''
        }
        //绘制频率选项卡
        if (i==4) {
            NSArray *array = [NSArray arrayWithObjects:@"60帧",@"90帧",@"120帧",nil];
            UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
            segment.userInteractionEnabled=YES;
            
            segment.frame=CGRectMake(10, i*42+5, 180, 30);//这个 x y 宽度 搞定 是基于上面的View视图中的 不是按屏幕
            //默认选项卡
            绘制频率选项卡=[[NSUserDefaults standardUserDefaults] integerForKey:@"绘制频率选项卡"];
            if (绘制频率选项卡==0) {
                segment.selectedSegmentIndex = 0;//默认选项卡
            }
            if (绘制频率选项卡==1) {
                segment.selectedSegmentIndex = 1;//默认选项卡
            }
            if (绘制频率选项卡==2) {
                segment.selectedSegmentIndex = 2;//默认选项卡
            }
            
            segment.apportionsSegmentWidthsByContent = NO;
            segment.layer.cornerRadius = 20.00;//圆角
            //绑定点击事件
            [segment addTarget:self action:@selector(绘制频率选项卡调用:) forControlEvents:UIControlEventValueChanged];
            [HDView[1] addSubview:segment];
            
            UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(150, i*42+3, HDView[0].frame.size.width-170, 40)];
            
            label.text=@"游戏帧率";
            label.textColor=[UIColor blackColor];
            label.numberOfLines = 2;//行数
            //设置文字字体大小
            label.font = [UIFont fontWithName:@"AlNile-Bold" size:15];
            label.textAlignment = NSTextAlignmentRight;//居中
            //设置文字颜色
            label.textColor=[UIColor orangeColor];
            [HDView[1] addSubview:label]; //将label 显示在屏幕上''
        }
        
    }
    [View addSubview:HDView[1]];
    
}
-(void)菜单3
{
    //第2个选项卡滑动视图
    HDView[2]= [[UIScrollView alloc] init];
    HDView[2].userInteractionEnabled=YES;
    HDView[2].hidden=YES;//第二个选项卡默认隐藏
    HDView[2].layer.cornerRadius=10;
    HDView[2].frame=CGRectMake(10, 80, View.frame.size.width-20, View.frame.size.height-80);//子视图按总视图大小一致
    HDView[2].backgroundColor =  [UIColor clearColor];
    
    //到期时间
    NSString*dqsj=[[NSUserDefaults standardUserDefaults] objectForKey:@"到期时间"];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, HDView[2].frame.size.width-20, 40)];
    label.text=dqsj;
    label.textColor=[UIColor blackColor];
    label.numberOfLines = 1;//行数
    //设置文字字体大小
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;//居中
    //设置文字颜色
    label.textColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [HDView[2] addSubview:label]; //将label 显示在屏幕上''
    
    //公告
    NSString*gg=[[NSUserDefaults standardUserDefaults] objectForKey:@"公告"];
    UILabel*gglabel=[[UILabel alloc] init];
    gglabel.text=gg;
    gglabel.textColor=[UIColor blackColor];
    
    NSArray *arr = [gg componentsSeparatedByString:@"\n"];
    gglabel.numberOfLines = 0;//行数
    //根据行数设置搞定
    gglabel.frame=CGRectMake(10, 42, HDView[2].frame.size.width-20, 42*arr.count);
    //设置文字字体大小
    gglabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    gglabel.textAlignment = NSTextAlignmentCenter;//居中
    //设置文字颜色
    gglabel.textColor=[UIColor blackColor];
    [HDView[2] addSubview:gglabel]; //将label 显示在屏幕上
    [gglabel sizeToFit];
    
    [View addSubview:HDView[2]];
    //根据换行数自动重新设置高度宽度
    HDView[2].contentSize=CGSizeMake(View.frame.size.width-20, gglabel.frame.size.height+42);
    gglabel.frame=CGRectMake(HDView[2].frame.size.width/2-gglabel.frame.size.width/2, 42, gglabel.frame.size.width, gglabel.frame.size.height);
}
#pragma mark - 菜单调用相关=========
- (void)点击关闭菜单
{
    显示隐藏=!显示隐藏;
    View.hidden=YES;
    gzbView.hidden=YES;
    gzbView.userInteractionEnabled=NO;
}

//选项卡调用
- (void)选项卡调用:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex == 0) {
        View.hidden=NO;
        HDView[0].hidden=NO;
        HDView[1].hidden=YES;
        HDView[2].hidden=YES;
        [[MemUI alloc] bofang:@"功能"];
    }else if (sender.selectedSegmentIndex == 1) {
        [HDView[1] removeFromSuperview];
        [self 菜单2];
        View.hidden=NO;
        HDView[0].hidden=YES;
        HDView[1].hidden=NO;
        HDView[2].hidden=YES;
        [[MemUI alloc] bofang:@"卡密"];
    }
    else if (sender.selectedSegmentIndex == 2) {
       
        [self 菜单3];
        View.hidden=NO;
        HDView[0].hidden=YES;
        HDView[1].hidden=YES;
        HDView[2].hidden=NO;
         [[MemUI alloc] bofang:@"公告"];
    }
}

- (void)绘制频率选项卡调用:(UISegmentedControl *)sender{
    //判断选项卡按钮 :sender.selectedSegmentIndex
    if (sender.selectedSegmentIndex==0) {
        //按下第一个选项卡
    }
    if (sender.selectedSegmentIndex==1) {
        //按下第2个选项卡
    }
   
}

//菜单1开关调用
- (void)透视调用:(UISwitch*)sw{
    
    if(sw.on){
        [self bofang:@"绘制开启"];
    }else{
        //这里写透视关闭代码
        [self bofang:@"绘制关闭"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"透视开关"];
}

- (void)方框调用:(UISwitch*)sw{
    
    if(sw.on){
        [self bofang:@"方框开启"];

    }else{
        //这里写透视关闭代码
        [self bofang:@"方框关闭"];
        
    }
    [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"方框开关"];
}
- (void)技能调用:(UISwitch*)sw{
   
    if(sw.on){
        [self bofang:@"技能开启"];
    }else{
        //这里写透视关闭代码
        [self bofang:@"技能关闭"];
        
    }
    [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"技能开关"];
}
- (void)射线调用:(UISwitch*)sw{
    
    if(sw.on){
        [self bofang:@"射线开启"];
    }else{
        //这里写透视关闭代码
        [self bofang:@"射线关闭"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"射线开关"];
}

-(void)滑动时候调用:(UISlider *)slider
{
    视距label.text=[NSString stringWithFormat:@"%.1f倍 视距",slider.value];
   
}

-(void)滑动结束调用:(UISlider *)slider
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JRMemoryEngine engine = JRMemoryEngine(mach_task_self());
        AddrRange range = (AddrRange){0x100000000,0x200000000};    // 搜索范围
        engine.JRScanMemory(range, &搜索值, JR_Search_Type_Float); // 搜索
        vector<void*>results = engine.getAllResults();
        float modify =slider.value;
        for(int i =0;i<results.size();i++){
            NSString *str =[NSString stringWithFormat:@"%zx", (long)results[i]];
            if([str hasSuffix:@"9b8"] || [str hasSuffix:@"9b0"]){
                engine.JRWriteMemory((unsigned long long)(results[i]),&modify,JR_Search_Type_Float);  // 修改第几个
            }
        }
        搜索值=slider.value;
    });
   
}

-(void)地图x调用:(UISlider *)slider
{
    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"mapx"];
   
}
-(void)地图y调用:(UISlider *)slider
{
    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"mapy"];
   
}

- (void)头像开启调用:(UISwitch*)sw{
    
    [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"头像开关"];
    
}
- (void)显示隐藏菜单
{
    显示隐藏=!显示隐藏;
    if (显示隐藏) {
        View.hidden=NO;
        gzbView.userInteractionEnabled=YES;
    }else{
        View.hidden=YES;
        gzbView.userInteractionEnabled=NO;
    }
}
- (void)过直播开关调用:(UISwitch*)sw{
    过直播开关 =sw.on;
    if (过直播开关) {
        [self bofang:@"过直播已开启"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"过直播开关"];
   
}
- (void)语音开关调用:(UISwitch*)sw{
    语音开关 =sw.on;
    if (语音开关) {
        [self bofang:@"语音提示已开启"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"语音开关"];
}


//文字转语言
- (void)bofang:(NSString*)str{
    
    if (!语音开关) {
        return;
    }
    
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//汉语
    AVSpeechUtterance *txt = [[AVSpeechUtterance alloc] initWithString:str];
    txt.pitchMultiplier = 1.0;
    txt.volume = 1.0;//音量
    txt.rate = 0.5;
    txt.voice = voice;
    [synth speakUtterance:txt];
    [synth continueSpeaking];
    //读取语音条长度
    
    
}



#pragma mark - 触摸手势相关 设置视图可以拖动 并且超出屏幕会自动回弹=========
//当开始触摸屏幕的时候调用
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
//触摸时开始移动时调用(移动时会持续调用)
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //做UIView拖拽
    UITouch *touch = [touches anyObject];
    //求偏移量 = 手指当前点的X - 手指上一个点的X
    CGPoint curP = [touch locationInView:self];
    CGPoint preP = [touch previousLocationInView:self];
    NSLog(@"curP====%@",NSStringFromCGPoint(curP));
    NSLog(@"preP====%@",NSStringFromCGPoint(preP));
    
    CGFloat offsetX = curP.x - preP.x;
    CGFloat offsetY = curP.y - preP.y;
    
    //平移
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    
}

//当手指离开屏幕时调用
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     NSLog(@"%s",__func__);
    float x=View.frame.origin.x;
    float y=View.frame.origin.y;
    float w=View.frame.size.width;
    float h=View.frame.size.height;
    //横屏状态
    if (kuandu>gaodu) {
        //横屏
        //超出左边
        if (x<0) {
            x=0;
        }
        //上面
        if (y<0) {
            y=0;
        }
        //超出右边
        if (x+w>kuandu) {
            x=kuandu-w;
        }
        if (y+h>gaodu) {
            y=gaodu-h;
        }
    }
    
    //更新视图
    View.frame=CGRectMake(x, y, w, h);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    //判断点击菜单的次数
    if (touch.tapCount == 1) {
        //单击 不操作
        
    }else if(touch.tapCount == 2)
    {
        //双击 关闭菜单
        [self bofang:@"关闭"];
        [self performSelector:@selector(显示隐藏菜单) withObject:[NSValue valueWithCGPoint:touchPoint] afterDelay:0.3];
        View.hidden=YES;
        gzbView.hidden=YES;
        gzbView.userInteractionEnabled=NO;
    }
    
}


//当发生系统事件时就会调用该方法(电话打入,自动关机)自动隐藏菜单
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    显示隐藏=!显示隐藏;
    View.hidden=YES;
    gzbView.hidden=YES;
    gzbView.userInteractionEnabled=NO;
}
//将菜单视图设置成第一响应视图 响应手势操作
-(BOOL)canBecomeFirstResponse
{
    return YES;
}
@end

