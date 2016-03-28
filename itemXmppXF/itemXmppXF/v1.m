//
//  v1.m
//  itemXmppXF
//
//  Created by Moon on 16/3/26.
//  Copyright © 2016年 SuDream. All rights reserved.
//

#import "v1.h"
#import <iflyMSC/IFlySpeechUtility.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import <QuartzCore/QuartzCore.h>

#import "PCMToWAV.h"
@interface v1 ()<IFlySpeechRecognizerDelegate>

@end

@implementation v1

-(instancetype) init
{
    if (self=[super init]) {
        
        
        self.tabBarItem.title=@"语音输入";
        self.result=[NSMutableString string];
        [self initMSC];
        
    }
    return self;
}



-(void) initMSC
{
    //创建语音配置
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",AppID_VALUE,TIMEOUT_VALUE]];
    
    //创建语音识别单利
    self.IFlySpeenchRecognizer=[IFlySpeechRecognizer sharedInstance];
    self.IFlySpeenchRecognizer.delegate=self;
    //设置搜索
    [self.IFlySpeenchRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //设置采样
    [self.IFlySpeenchRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    //设置识别录音保存路径，默认目录是documents。asr.pcm为保存的文件名
    [self.IFlySpeenchRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置返回的结果
    [self.IFlySpeenchRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [self.IFlySpeenchRecognizer setParameter:@"100" forKey:[IFlySpeechConstant VOLUME]];
    
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >=70000
    
    
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    
    
    self.tView=[[UITextView alloc] initWithFrame:CGRectMake(10, 20, 300, 300)];
    self.tView.text = @"点击开始说话按钮，进行语音识别!";
    self.tView.backgroundColor = [UIColor lightGrayColor];
    self.tView.textColor = [UIColor blueColor];
    self.tView.font = [UIFont systemFontOfSize:18];
    self.tView.editable = NO;
    self.tView.layer.cornerRadius = 10;
    self.tView.layer.masksToBounds = YES;
    [self.view addSubview:self.tView];
    
    
    //
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startBtn setTitle:@"按钮开始说话" forState:UIControlStateNormal];
    [self.startBtn setTitle:@"松开停止说话" forState:UIControlStateHighlighted];
    [self.startBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    self.startBtn.backgroundColor = [UIColor redColor];
    self.startBtn.layer.cornerRadius = 5;
    self.startBtn.layer.masksToBounds = YES;
    self.startBtn.frame = CGRectMake(10, self.tView.frame.origin.y+self.tView.frame.size.height+40, 150, 40);
    [self.startBtn addTarget:self action:@selector(beginToSay) forControlEvents:UIControlEventTouchDown];
    [self.startBtn addTarget:self action:@selector(endToSay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startBtn];
    
    
    
    //
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [readBtn setTitle:@"播放录音" forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    readBtn.backgroundColor = [UIColor greenColor];
    readBtn.layer.cornerRadius = 5;
    readBtn.layer.masksToBounds = YES;
    readBtn.frame = CGRectMake(self.startBtn.frame.origin.x+self.startBtn.frame.size.width+10, self.startBtn.frame.origin.y, 140, 40);
    [readBtn addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readBtn];
    
    //
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(10, self.tView.frame.origin.y+self.tView.frame.size.height+10, 300, 10);
    self.progressView.progress = 0.0;
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = [UIColor greenColor];
    [self.view addSubview:self.progressView];
    
    
    
    
    
    
    
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //销毁语音识别并设置委托为nil
    [self.IFlySpeenchRecognizer stopListening];//停止语音识别
    [self.IFlySpeenchRecognizer setDelegate:nil];
    [self.IFlySpeenchRecognizer destroy];//销毁识别对象
    
    [self.play stop];//停止播放
}


//开始说话
-(void) beginToSay
{
    NSLog(@"ss");
    self.startBtn.enabled=NO;
    [self.result deleteCharactersInRange:NSMakeRange(0, self.result.length)];
    if (![self.IFlySpeenchRecognizer isListening]) {
        [self.IFlySpeenchRecognizer stopListening];
       
        
    }
    BOOL  speen=[self.IFlySpeenchRecognizer startListening];
    if (!speen) {
        [self show:@"启动识别服务失败,请稍后重试"];
        
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

- (void) endToSay
{
    self.startBtn.enabled = YES;
    [self.IFlySpeenchRecognizer stopListening];
}


-(void) playSound
{
    NSArray *originPcmPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",originPcmPaths[0]);
    NSString *pcmPath = [[originPcmPaths objectAtIndex:0] stringByAppendingPathComponent:@"asr.pcm"];
    NSArray *newWAVPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *wavPath = [[newWAVPaths objectAtIndex:0] stringByAppendingPathComponent:@"asr.wav"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pcmPath]) {
        
        
        //pcm格式转换成wav格式文件
        NSArray  *array=@[wavPath,pcmPath];
        [[PCMToWAV sharePCM] pcmToWav:array];
        
        self.play=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:wavPath] error:nil];
        self.play.volume=1.0;
        [self.play play];
        
        
    }
    
}

- (NSString*)resolveNetworkJson:(NSString*)json
{
    if (json && json.length)
    {
        NSDictionary *dic = nil;
        
        //ios5.0以后使用系统自带的json解析，之前的使用第三方库jsonkit
        if (IOS5_OR_LATER)
        {
            NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
            dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
        
        
        if (dic)
        {
            NSMutableString *str = [NSMutableString string];
            NSArray *array = [dic objectForKey:@"ws"];
            for (NSDictionary *dic in array)
            {
                NSArray *wordsAry = [dic objectForKey:@"cw"];
                for (NSDictionary *wordDic in wordsAry)
                {
                    [str appendString:[wordDic objectForKey:@"w"]];
                }
            }
            
            return str;
        }
    }
    
    return @"";
}

#pragma mark - IFlySpeechRecognizerDelegate
/** 开始录音回调
 当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onError:函数
 */
- (void) onBeginOfSpeech
{
    self.progressView.progress = 0;
    [self show:@"正在录音"];
}

/** 停止录音回调
 当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。如果发生错误则回调onError:函数
 */
- (void) onEndOfSpeech
{
    self.progressView.progress = 0;
    [self show:@"停止录音"];
}

/** 取消识别回调
 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 */
- (void) onCancel
{
    [self show:@"语音识别取消了"];
}

/** 音量变化回调
 在录音过程中，回调音频的音量。
 @param volume -[out] 音量，范围从1-100
 */
- (void) onVolumeChanged: (int)volume
{
    self.progressView.progress = volume/100.0;//设置进度
}

/** 识别结果回调
 在进行语音识别过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理，当errorCode没有错误时，表示此次会话正常结束；否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
 @param errorCode 错误描述类，
 */
- (void) onError:(IFlySpeechError *) error
{
    if (error.errorCode ==0)
    {
        if (self.result.length==0)
        {
            [self show:@"囧! 没识别出来〜〜"];
        }
        else
        {
            self.tView.text = self.result;//最终识别的文本
        }
    }
}

/** 识别结果回调
 在识别过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 @param   results     -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度。
 @param   isLast      -[out] 是否最后一个结果
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSDictionary *dic = results[0];
    for (NSString *key in dic)
    {
        [self.result appendString:[self resolveNetworkJson:key]];//不断追加来自网络的文本
    }
}

@end
