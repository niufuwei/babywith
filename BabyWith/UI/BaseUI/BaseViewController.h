//
//  BaseViewController.h
//  meiliyue
//
//  Created by Fly on 12-11-22.
//  Copyright (c) 2012年 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppGlobal.h"
#import "Configuration.h"
#import "UIViewController+Alert.h"
@interface BaseViewController : UIViewController

//- (void)showAlertView:(NSString*)msg;
- (void)configurationForGreenButton:(UIButton *)button;   //把按钮配置为绿色
- (void)leftButtonItemWithImageName:(NSString *)imageName;//导航条左item 的Image
- (void)rightButtonItemWithImageName:(NSString *)imageName;
- (void)titleSet:(NSString *)aTitle;


@end
