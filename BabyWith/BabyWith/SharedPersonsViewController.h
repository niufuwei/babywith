//
//  SharedPersonsViewController.h
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-23.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "BaseViewController.h"

@interface SharedPersonsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{

    NSString *_decideID;
    UILabel *_label;

}
@property (nonatomic, retain) NSString *deviceID;
@property (nonatomic, retain) UITableView *sharedPersonTableView;

- (id)initWithDeviceID:(NSString *)deviceID;
@end
