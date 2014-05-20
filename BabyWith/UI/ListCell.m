//
//  ListCell.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-18.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 18, 120, 24)];
        [self addSubview:_statusLabel];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
