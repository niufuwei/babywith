//
//  UIViewController+Alert.h
//  BabyWith
//
//  Created by wangminhong on 13-6-27.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)<UIAlertViewDelegate>

- (void)makeAlert:(NSString *)title;
- (void)makeAlertForServerUseTitle:(NSString *)title Code:(NSString *)code;
- (void)ShowPrePage;
- (BOOL)checkTel:(NSString *)tel Type:(int)type;
- (BOOL)checkEmail:(NSString *)email;
- (int)checkTelAndEmail:(NSString *)string Type:(int)type;
- (int)judgeTelAndEmail:(NSString *)string Type:(int)type;
- (NSString *)GetNowTime;
- (NSString *)getLocalMacAddress;
- (int)getRandomNumber:(int)from to:(int)to;
- (NSString *)getAstroWithMonth:(NSInteger)month day:(NSInteger)day;


@end
