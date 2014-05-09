//
//  LoginRegisterViewController.h
//  BabyWith_
//
//  Created by shanchen on 14-3-12.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginRegisterViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (weak, nonatomic) IBOutlet UIButton *agreeMentBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


- (IBAction)startRegister:(id)sender;
- (IBAction)agreeOrNot:(id)sender;

@end
