//
//  ShareViewController.h
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (retain, nonatomic) UITableView *shareListTable;
@property (retain,nonatomic) UILabel *label;
@property (retain,nonatomic) UIButton *nextStepBtn;
@property (nonatomic,assign) BOOL hasSelect;

@end
