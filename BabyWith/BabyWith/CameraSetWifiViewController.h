//
//  CameraSetWifiViewController.h
//  BabyWith
//
//  Created by wangminhong on 13-9-1.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CameraSetWifiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_wifiListTableView;
    NSMutableArray *_wifiSearchList;
    
    NSObject *_delegate;
}

- (id)initWithDelegate:(NSObject *)delegate;

@end
