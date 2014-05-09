//
//  CameraParamSettingViewController.h
//  BabyWith
//
//  Created by wangminhong on 13-7-24.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraParamSettingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *_settingTableView;
    int _selectedRow;
    NSObject *_delegate;
}

- (id)initWithDelegate:(NSObject *)delegate;

@end
