//
//  PCMToWAV.h
//  PCMPlay
//
//  Created by 钱老师 on 14-5-8.
//  Copyright (c) 2014年 钱老师. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCMToWAV : NSObject

+ (PCMToWAV*)sharePCM;

/**
 @功能：给pcm添加wav头并转成wav音频文件
 @参数：文件全路径数组(wav的全路径 pcm的全路径)
 @返回值：无
 */
- (void)pcmToWav:(NSArray*)array;

@end
