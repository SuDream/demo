//
//  v2.h
//  itemXmppXF
//
//  Created by Moon on 16/3/26.
//  Copyright © 2016年 SuDream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iflyMSC/IFlySpeechSynthesizer.h>
#import <iflyMSC/IFlySpeechSynthesizerDelegate.h>
#import "MBProgressHUD.h"

@interface v2 : UIViewController<IFlySpeechSynthesizerDelegate>

@property (nonatomic,strong) IFlySpeechSynthesizer *synthesizer;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UITextView *tView;


@end
