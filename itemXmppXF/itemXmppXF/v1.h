//
//  v1.h
//  itemXmppXF
//
//  Created by Moon on 16/3/26.
//  Copyright © 2016年 SuDream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>
#import <iflyMSC/IFlySpeechRecognizer.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
@interface v1 : UIViewController


@property (nonatomic,strong) IFlySpeechRecognizer *IFlySpeenchRecognizer;
@property (nonatomic,strong) UITextView *tView;
@property (nonatomic,strong) UIButton *startBtn;
@property (nonatomic,strong) AVAudioPlayer *play;
@property (nonatomic,strong ) MBProgressHUD *HUD;
@property (nonatomic,strong) NSMutableString *result;
@property (nonatomic,strong) UIProgressView *progressView;


@end
