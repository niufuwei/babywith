//
//  Activity.m
//  ELiuYan
//
//  Created by laoniu on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "Activity.h"

@implementation Activity
{
    UIActivityIndicatorView * activity;
}

-(id)initWithActivity:(UIView *)view
{
    self = [super init];
    if(self)
    {
        //初始化菊花
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        //设置显示样式,见UIActivityIndicatorViewStyle的定义
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        //设置背景色
        activity.backgroundColor = [UIColor blackColor];
        //设置背景透明
        activity.alpha = 0.5;
        
        //设置背景为圆角矩形
        activity.layer.cornerRadius = 6;
        activity.layer.masksToBounds = YES;
        //设置显示位置
        [activity setCenter:CGPointMake(view.frame.size.width / 2.0, view.frame.size.height / 2.0)];
        
        [view addSubview:activity];
        [view bringSubviewToFront:activity];
   
    }
    return self;
    
}
-(void)start
{
    //开始显示Loading动画
    [activity startAnimating];
}
-(void)stop
{
    //开始显示Loading动画
    [activity stopAnimating];
}
@end
