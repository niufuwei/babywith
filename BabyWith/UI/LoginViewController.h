//
//  LoginViewController.h
//  BabyWith_
//
//  Created by shanchen on 14-3-12.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;





- (IBAction)login:(UIButton *)sender;
- (IBAction)accountRegister:(UIButton *)sender;
- (IBAction)forgotPassword:(UIButton *)sender;

@end
