//
//  SetPasswordViewController.h
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-19.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "BaseViewController.h"

@interface SetPasswordViewController : BaseViewController
@property (retain, nonatomic) IBOutlet UITextField *passwordField;
@property (retain, nonatomic) IBOutlet UIButton *hidePass;
@property (retain, nonatomic) IBOutlet UIButton *submit;
- (IBAction)hidePass:(id)sender;
- (IBAction)submitPass:(id)sender;

@end
