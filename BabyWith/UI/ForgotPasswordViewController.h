//
//  ForgotPasswordViewController.h
//  BabyWith_
//
//  Created by shanchen on 14-3-12.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "BaseViewController.h"

@interface ForgotPasswordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)next:(id)sender;
@end
