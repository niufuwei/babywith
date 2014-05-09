//
//  MessagViewController.h
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-19.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "BaseViewController.h"

@interface MessagViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{


    UITableView *_messageTableView;
    NSMutableArray *_messageArray;
    NSConditionLock *_messageLock;


}
@end
