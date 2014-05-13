//
//  MessageCell.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-5-13.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        _alertLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_alertLabel];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 320, 20)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_timeLabel];
        
        
        
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
