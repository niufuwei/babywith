//
//  SettingCell.h
//  AiJiaJia
//
//  Created by wangminhong on 13-5-25.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell{
    NSString *_passwordString;
    UIImageView *_headImageView;
    int _sureType;
    int _cellType;
}

@property(nonatomic, assign) int sureType;
@property(nonatomic, assign) int cellType;
@property(nonatomic, retain) NSString *passwordString;
@property(nonatomic, retain) UIImageView *headImageView;

@end
