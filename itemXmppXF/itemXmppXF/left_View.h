//
//  left_View.h
//  itemXmppXF
//
//  Created by Moon on 16/3/27.
//  Copyright © 2016年 SuDream. All rights reserved.
//

#import <UIKit/UIKit.h>
@class left_View;

@protocol left_ViewDelegate <NSObject>

-(void) left_ViewWith:(int) row;

@end
@interface left_View : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak) id<left_ViewDelegate> delegate;




@end
