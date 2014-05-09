//
//  LoginViewController.h
//  AiJiaJia
//
//  Created by wangminhong on 13-4-2.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegPhoneViewController;
@class ForgetPasswordViewController;
@class PersonInfoInitViewController;
@class FamilyEntryViewController;

@interface LoginViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>{
    UITextField *_username;
    UITextField *_password;
    RegPhoneViewController *_regPhoneViewController;
    ForgetPasswordViewController *_forgetPasswordViewController;
    PersonInfoInitViewController *_personInfoInitViewController;
    FamilyEntryViewController *_familyEntryViewController;
    
    int _blank;
}

@end
