//
//  BaseTabBarController.h
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentView.h"

@interface BaseTabBarController : UITabBarController<CustomSegmentViewDelegate>

@property (unsafe_unretained, nonatomic,readonly) CustomSegmentView *mSegmentBar;

@end
