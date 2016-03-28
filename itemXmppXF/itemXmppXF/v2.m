//
//  v2.m
//  itemXmppXF
//
//  Created by Moon on 16/3/26.
//  Copyright © 2016年 SuDream. All rights reserved.
//

#import "v2.h"
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechUtility.h>
#import <QuartzCore/QuartzCore.h>



@interface v2 ()

@end

@implementation v2

-(instancetype) init
{
    if (self=[super init]) {
        
        self.tabBarItem.title=@"读取";
        [self initMUS];
    }
    return self;
}


-(void) initMUS
{
    
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",AppID_VALUE,TIMEOUT_VALUE]];
    
    //合成
    self.synthesizer=[IFlySpeechSynthesizer sharedInstance];
    self.synthesizer.delegate=self;
    
    
    [self.synthesizer setParameter:@"30" forKey:[IFlySpeechConstant SPEED]];
    [self.synthesizer setParameter:@"100" forKey:[IFlySpeechConstant VOLUME]];
    [self.synthesizer setParameter:@"vils" forKey:[IFlySpeechConstant VOICE_NAME]];
    [self.synthesizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [self.synthesizer setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //销毁语音合成并设置委托为nil
    [self.synthesizer stopSpeaking];//停止合成会话
    [self.synthesizer setDelegate:nil];
    [IFlySpeechSynthesizer destroy];//销毁合成对象
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    
    self.tView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, 300, 300)];
    self.tView.text = @"Cocoa是苹果公司为Mac OS X所创建的原生面向对象的API，是Mac OS X上五大API之一（其它四个是Carbon、POSIX、X11和Java）。苹果的面向对象开发框架，用来生成 Mac OS X 的应用程序。主要的开发语言为 Objective-c, 一个c 的超集。 Cocoa 开始于1989年9月上市的NeXTSTEP 1.0，当时没有Foundation框架，只有动态运行库， 称为 kit, 最重要的是AppKit. 1993 年 NeXTSTEP 3.1 被移植到了 Intel, Sparc, HP 的平台上，Foundation 首次被加入，同时Sun 和 NeXT 合作开发OpenStep 也可以运行在Windows 系统上VCV。";
    self.tView.backgroundColor = [UIColor lightGrayColor];
    self.tView.textColor = [UIColor blueColor];
    self.tView.font = [UIFont systemFontOfSize:18];
    self.tView.editable = NO;
    self.tView.layer.cornerRadius = 10;
    self.tView.layer.masksToBounds = YES;
    [self.view addSubview:self.tView];
    
    //
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"开始合成会话" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    startBtn.backgroundColor = [UIColor redColor];
    startBtn.layer.cornerRadius = 5;
    startBtn.layer.masksToBounds = YES;
    startBtn.frame = CGRectMake(10, self.tView.frame.origin.y+self.tView.frame.size.height+40, 150, 40);
    [startBtn addTarget:self action:@selector(beginToSay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    //
    UIButton *prBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [prBtn setTitle:@"暂停播放" forState:UIControlStateNormal];
    [prBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    prBtn.backgroundColor = [UIColor greenColor];
    prBtn.layer.cornerRadius = 5;
    prBtn.layer.masksToBounds = YES;
    prBtn.frame = CGRectMake(startBtn.frame.origin.x+startBtn.frame.size.width+10, startBtn.frame.origin.y, 140, 40);
    [prBtn addTarget:self action:@selector(pauseOrResumePlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prBtn];
    
    //
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(10, self.tView.frame.origin.y+self.tView.frame.size.height+10, 300, 10);
    self.progressView.progress = 0.0;
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = [UIColor greenColor];
    [self.view addSubview:self.progressView];
    
    
    
}

//开始合成
-(void) beginToSay
{
    if (self.tView.text.length && ![self.synthesizer isSpeaking]) {
        
        
        [self.synthesizer startSpeaking:self.tView.text];
        
    }
    
    
}

//暂停
-(void)  pauseOrResumePlay:(UIButton *) btn
{
    if ([btn.currentTitle isEqualToString:@"暂停播放"]) {
        
        [btn setTitle:@"恢复播放" forState:UIControlStateNormal];
        [self.synthesizer pauseSpeaking];
        
        
    }else
    {
        [btn  setTitle:@"暂停播放" forState:UIControlStateNormal];
        [self.synthesizer resumeSpeaking];
    }
    
    
}
- (void)show:(NSString*)info
{
    if (!self.HUD)
    {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
    }
    
    self.HUD.labelText = info;
    self.HUD.mode = MBProgressHUDModeText;//设置模式为文本
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:1.5];
}
#pragma mark - IFlySpeechSynthesizerDelegate
/** 结束回调
 当整个合成结束之后会回调此函数
 @param error 错误码
 */
- (void) onCompleted:(IFlySpeechError*) error
{
    [self show:@"合成会话结束了"];
}

/** 开始合成回调 */
- (void) onSpeakBegin
{
    [self show:@"开始合成会话"];
}

/** 播放进度回调
 @param progress 播放进度，0-100
 */
- (void) onSpeakProgress:(int) progress
{
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.progress = progress/100.0;
    }];
}

/** 暂停播放回调 */
- (void) onSpeakPaused
{
    [self show:@"暂停播放了"];
}

/** 恢复播放回调 */
- (void) onSpeakResumed
{
    [self show:@"恢复播放了"];
}




@end
