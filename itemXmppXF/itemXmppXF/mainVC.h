//
//  mainVC.h
//  itemXmppXF
//
//  Created by Moon on 16/3/27.
//  Copyright © 2016年 SuDream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "left_View.h"
#import "right_View.h"
@interface mainVC : UIViewController<left_ViewDelegate>


@property (nonatomic,strong) left_View *leftView;
@property (nonatomic,strong) right_View *rightView;

@end
