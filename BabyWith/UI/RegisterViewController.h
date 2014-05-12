//
//  RegisterViewController.h
//  BabyWith
//
//  Created by shanchen on 14-3-11.
//  Copyright (c) 2014年 shancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController<UITextFieldDelegate ,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)skipRegistration:(UIButton *)sender;
- (IBAction)startRegister:(UIButton *)sender;

@end
