//
//  HomeViewController.h
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController<UITabBarDelegate ,UITableViewDataSource,UITableViewDelegate>

{

    UITableView *_homeTableView1;

}


@end
