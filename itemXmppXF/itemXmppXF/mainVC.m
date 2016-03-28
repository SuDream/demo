//
//  mainVC.m
//  itemXmppXF
//
//  Created by Moon on 16/3/27.
//  Copyright © 2016年 SuDream. All rights reserved.
//




#import "mainVC.h"

//设置最大，最小内容偏移量
//#define  MaxContentOffSetX  230
//#define  MinContentOffSetX 60

#import "push1.h"
#import "push2.h"

typedef enum {
    SliderNone,
    SliderFromLeft,
    SliderFromRight
} SliderDirection;

@interface mainVC ()
{
    CGFloat  curContentOffSetX;
    BOOL boundsSlider;
    UIPanGestureRecognizer *panGesture;
    UITapGestureRecognizer *tapGesture;
    CGRect _currentScreenSize;
    
    CGFloat MinContentOffSetX;
    CGFloat  MaxContentOffSetX;
    
    
}

@property (nonatomic,strong) UIView  *contentView; //内容视图
@property (nonatomic,strong) UIView  *navBakView;//左右的父视图
@property (nonatomic,strong) UIViewController *mainvc;

@end

@implementation mainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取当前屏幕
    _currentScreenSize=[UIScreen mainScreen].bounds;
    MinContentOffSetX=_currentScreenSize.size.width*0.3;
    MaxContentOffSetX=_currentScreenSize.size.width*0.7;
    
    
    
    //添加内容视图
    self.contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _currentScreenSize.size.width, _currentScreenSize.size.height)];
    self.contentView.backgroundColor=[UIColor yellowColor];
    self.navBakView=[[UIView alloc] initWithFrame:self.contentView.frame];
    [self.view addSubview:self.navBakView];
    [self.view addSubview:self.contentView];
    
    //添加左右视图
    self.leftView=[[left_View alloc] initWithFrame:self.navBakView.frame];
    self.leftView.delegate=self;
    self.rightView=[[right_View alloc] initWithFrame:self.navBakView.frame];
    [self.navBakView addSubview:self.leftView];
    [self.navBakView addSubview:self.rightView];
    
    //给内容视图添加手势
    panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(sliderGesgure:)];
    [self.contentView addGestureRecognizer:panGesture];
    
    boundsSlider = YES;//内容视图在边界
    
    
}

-(void) sliderGesgure:(UIPanGestureRecognizer *) gesture
{
    
    if (gesture.state==UIGestureRecognizerStateChanged) {
        
        //设置内容视图偏移量
        CGFloat transX=[gesture translationInView:self.contentView].x;
        self.contentView.transform=CGAffineTransformMakeTranslation(curContentOffSetX+transX, 0);
        
        //偏移来判断显示那个视图
        if (self.contentView.transform.tx>0) {
            [self.navBakView bringSubviewToFront:self.leftView];
        }else
        {
            [self.navBakView bringSubviewToFront:self.rightView];
        }
        
    }
    
    
    //手势结束
    if (gesture.state==UIGestureRecognizerStateEnded) {
        
        curContentOffSetX=self.contentView.transform.tx;
        
        if (boundsSlider) {
            if (fabs(curContentOffSetX)<=MinContentOffSetX) {
                
                [self setContentViewTransForm:SliderNone];
                
            }else if (curContentOffSetX>MinContentOffSetX)
            {
                [self setContentViewTransForm:SliderFromLeft];
            }else
            {
                [self setContentViewTransForm:SliderFromRight];
                
            }
            
            
        }else
        {
            
            
            if (fabs(curContentOffSetX) <= (MaxContentOffSetX-MinContentOffSetX))
            {
                [self setContentViewTransForm:SliderNone];
            }
            else if (curContentOffSetX > (MaxContentOffSetX-MinContentOffSetX))
            {
                [self setContentViewTransForm:SliderFromLeft];
            }
            else
            {
                [self setContentViewTransForm:SliderFromRight];
            }
            
        }
        
    }
    
    
}

- (void)setContentViewTransForm:(SliderDirection)direction
{
    self.contentView.userInteractionEnabled = NO;
    self.navBakView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        switch (direction)
        {
            case SliderNone:
                self.contentView.transform = CGAffineTransformMakeTranslation(0, 0);
                break;
            case SliderFromLeft:
                self.contentView.transform = CGAffineTransformMakeTranslation(MaxContentOffSetX, 0);
                break;
            case SliderFromRight:
                self.contentView.transform = CGAffineTransformMakeTranslation(-MaxContentOffSetX, 0);
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
        self.navBakView.userInteractionEnabled = YES;
        curContentOffSetX = self.contentView.transform.tx;//获取当前偏移量
        
        if (tapGesture) [self.contentView removeGestureRecognizer:tapGesture];
        
        if (direction == SliderNone)
        {
            boundsSlider = YES;//内容视图在边界
        }
        else
        {
            
            tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesgure:)];
            [self.contentView addGestureRecognizer:tapGesture];
            boundsSlider = NO;//内容视图不在边界
        }
    }];
}

-(void) tapGesgure:(UITapGestureRecognizer *) ges
{
    [self setContentViewTransForm:SliderNone];
}

-(void) left_ViewWith:(int)row
{
    if (row==1) {
        
        push1 *push=[[push1 alloc] init];
        [self.navigationController pushViewController:push animated:YES];
        
    }else
    {
        push2 *pus=[[push2 alloc] init];
        [self.navigationController pushViewController:pus animated:YES];
        
    }
    [self setContentViewTransForm:SliderNone];
    
}



@end
