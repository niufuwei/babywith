//
//  ShareDeviceViewController.h
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-18.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "BaseViewController.h"
@interface ShareDeviceViewController : BaseViewController

@property (retain, nonatomic) IBOutlet UITextField *phoneNumber;
@property (retain, nonatomic)  UIButton *submit;
@property (assign, nonatomic) BOOL result;

@end
