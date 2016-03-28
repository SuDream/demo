//
//  taskLeft.m
//  itemXmppXF
//
//  Created by Moon on 16/3/27.
//  Copyright © 2016年 SuDream. All rights reserved.
//

#import "taskLeft.h"
#import "Left_ViewTask.h"
typedef enum{
    SliderNone,
    SliderLeft
    
} SliderDirection;

static BOOL canMoveView = YES;
@interface taskLeft ()

@end

@implementation taskLeft
{
    UIPanGestureRecognizer *panGesture;
    UITapGestureRecognizer *tapGesture;
    CGFloat _curContentOffsetX;
    
    //contentView
    UIView *contentView;
    Left_ViewTask *backView;
    
    CGRect _currentScreenSize;
    
    //偏移最大
    CGFloat maxContentOffsetX;
    //最小
    CGFloat minContentOffSetX;
    
    //
    
    
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentScreenSize=[UIScreen mainScreen].bounds;
    maxContentOffsetX=_currentScreenSize.size.width*0.7;
    minContentOffSetX=_currentScreenSize.size.width*0.3;
    
    
    
    //CreateUi
    backView=[[Left_ViewTask alloc] initWithFrame:CGRectMake(0, 0, _currentScreenSize.size.width, _currentScreenSize.size.height)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,_currentScreenSize.size.width, _currentScreenSize.size.height)];
    contentView.backgroundColor=[UIColor redColor];
    [self.view addSubview:contentView];
    
    //手势
    panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderGesture:)];
    [contentView addGestureRecognizer:panGesture];
    
    
}

-(void) sliderGesture:(UIPanGestureRecognizer *) gesture
{
    
    if (gesture.state==UIGestureRecognizerStateBegan) {
        
        CGFloat viewOffsetx=contentView.transform.tx;
         CGFloat by=[gesture translationInView:contentView].x;
        if ((viewOffsetx>0&&by<0)||by>0) {
            canMoveView=YES;
        }else
        {
            canMoveView=NO;
        }
        NSLog(@"s");
        
        
    }
    
    
    
    if (gesture.state==UIGestureRecognizerStateChanged) {
        
        if (canMoveView) {
            
            CGFloat by=[gesture translationInView:contentView].x;
//            NSLog(@"%f",by);
            contentView.transform=CGAffineTransformMakeTranslation(_curContentOffsetX+by, 0);

            
        }
        
       
        
      
        
    }
    
    if (gesture.state==UIGestureRecognizerStateEnded) {
        
        _curContentOffsetX=contentView.transform.tx;
        
        
        if (_curContentOffsetX<=minContentOffSetX) {
            [self setContentViewTransForm:SliderNone];
        }else if(_curContentOffsetX>maxContentOffsetX ||_curContentOffsetX>minContentOffSetX || _curContentOffsetX<(maxContentOffsetX-minContentOffSetX))
        {
            [self setContentViewTransForm:SliderLeft];
            
        }
        
    }
    
    
    
}

- (void)setContentViewTransForm:(SliderDirection)direction
{
    contentView.userInteractionEnabled = NO;
    backView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        switch (direction)
        {
            case SliderNone:
                contentView.transform = CGAffineTransformMakeTranslation(0, 0);
                break;
            case SliderLeft:
                contentView.transform = CGAffineTransformMakeTranslation(maxContentOffsetX, 0);
                break;
         
            default:
                break;
        }
    } completion:^(BOOL finished) {
        contentView.userInteractionEnabled = YES;
        backView.userInteractionEnabled = YES;
        _curContentOffsetX =contentView.transform.tx;//获取当前偏移量
        
        if (tapGesture)
        {
            [contentView removeGestureRecognizer:tapGesture];
        }
        

        
        if (!direction==SliderNone) {
            
            
            tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesgure:)];
            [contentView addGestureRecognizer:tapGesture];
        }
        
        
        
    }];
}


-(void) tapGesgure:(UITapGestureRecognizer *) gestrue
{
    [self setContentViewTransForm:SliderNone];
}


@end
