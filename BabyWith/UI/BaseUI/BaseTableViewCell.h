//
//  BaseTableViewCell.h
//  meiliyue
//
//  Created by Fly on 12-11-22.
//  Copyright (c) 2012年 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

- (id)initWithXibName:(NSString*)strName;
- (id)initWithIndex:(NSInteger)index;

@property (assign,nonatomic) BOOL mbHasShadow;

- (CGFloat)getCellHeight;

@end
