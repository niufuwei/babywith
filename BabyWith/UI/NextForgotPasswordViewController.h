//
//  NextForgotPasswordViewController.h
//  BabyWith_
//
//  Created by shanchen on 14-3-12.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "BaseViewController.h"

@interface NextForgotPasswordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCheckCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong,nonatomic) NSString *configPhoneNum;
- (IBAction)getCheckCode:(id)sender;
- (IBAction)showOrHidePassword:(id)sender;

- (IBAction)submit:(id)sender;
@end
