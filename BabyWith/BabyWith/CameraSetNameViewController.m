//
//  CameraSetNameViewController.m
//  BabyWith
//
//  Created by wangminhong on 13-7-26.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "CameraSetNameViewController.h"
#import "Configuration.h"
#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+Alert.h"

@implementation CameraSetNameViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    UIView *view = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] applicationFrame].size.height)];
    view.backgroundColor = babywith_background_color;
    self.view = view;
    [view release];
}

-(void)viewDidLoad{
    
    
    [super viewDidLoad];
    
    //导航条设置
    {
        //左导航-主选择页面
        UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        navButton.tag = 3;
        [navButton setImage:[UIImage imageNamed:@"goBack.png"] forState:UIControlStateNormal];
        [navButton setImage:[UIImage imageNamed:@"goBack_highlight.png"] forState:UIControlStateHighlighted];
        [navButton addTarget:self action:@selector(ShowPrePage) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        [navButton release];
        [leftItem release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [[appDelegate.appDefault objectForKey:@"Device_selected"] objectForKey:@"name"];
        titleLabel.textColor = babywith_text_background_color;
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
    }
    
    //家庭文本区域
     _cameraTextField= [[UITextField alloc] initWithFrame:CGRectMake(11, 10, 298, 40)];
    _cameraTextField.placeholder = @"请输入看护器名称";
    _cameraTextField.delegate = self;
    _cameraTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_cameraTextField becomeFirstResponder];
    [_cameraTextField setKeyboardType:UIKeyboardTypeDefault];
    _cameraTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _cameraTextField.backgroundColor = babywith_text_background_color;
    _cameraTextField.layer.cornerRadius = 5.0;
    
    UILabel *paddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
    paddingLabel.backgroundColor = [UIColor clearColor];
    _cameraTextField.leftView = paddingLabel;
    _cameraTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_cameraTextField];
    [paddingLabel release];
    
//    //提示字串
//    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 40)];
//    bottomLabel.font = [UIFont systemFontOfSize:14];
//    bottomLabel.textAlignment = UITextAlignmentCenter;
//    bottomLabel.textColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1.0];
//    bottomLabel.numberOfLines = 0;
//    bottomLabel.lineBreakMode = UILineBreakModeWordWrap;
//    bottomLabel.text = @"请给你的家庭编写给名字\n通过新建家庭。您可以更好的为宝宝建立家庭";
//    bottomLabel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:bottomLabel];
//    [bottomLabel release];
    
    
    //下一步按钮
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
    [nextButton setBackgroundColor:babywith_green_color];
    
    CGSize imageSize = CGSizeMake(300, 40);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [babywith_green_color_hightlight set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [nextButton setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
    
    [nextButton setTitle:@"看护器重命名" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [nextButton.layer setMasksToBounds:YES];
    [nextButton.layer setCornerRadius:5.0];
    [nextButton addTarget:self action:@selector(ModifyCameraName) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextButton];
    [nextButton release];
}

-(void)ShowMainList:(id *)sender{
    _cameraTextField.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ModifyCameraName{
    
    if ([[_cameraTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self makeAlert:@"看护器名称不可为空。"];
        return;
    }
    
    //修改看护器名称，发送服务器
    BOOL result = [appDelegate.webInfoManger UserRenameDeviceUsingToken:[appDelegate.appDefault objectForKey:@"Token"] DeviceId:[[appDelegate.appDefault objectForKey:@"Device_selected"] objectForKey:@"device_id"] DeviceName:[_cameraTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if (result) {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"看护器名称修改成功。";
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            [indicator release];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDeviceName" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
//        [self makeAlert:[appDelegate.appDefault objectForKey:@"Error_message"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
   // float sysVer =[[[UIDevice currentDevice] systemVersion] floatValue];
    
   
}

-(void)viewDidUnload{
    
    [_cameraTextField release];
    _cameraTextField = nil;
}


-(void)dealloc{
    [_cameraTextField release];
    [super dealloc];
}
@end
