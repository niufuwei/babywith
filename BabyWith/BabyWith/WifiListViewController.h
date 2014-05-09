//
//  WifiListViewController.h
//  AiJiaJia
//
//  Created by wangminhong on 13-6-20.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PPPP_API.h"
#include "PPPPChannel.h"
#include "PPPPDefine.h"

@interface WifiListViewController : UIViewController<WifiParamsProtocol, PPPPStatusProtocol, UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
    CPPPPChannel *pPPPPChannel;
    
    UITableView *_wifiListTableView;
    NSMutableArray *_wifiSearchList;
    
    NSString *_deviceID;
}

@property(nonatomic, copy) NSString *deviceID;

- (id)initWithDevice:(NSString *)deviceID;

@end
