//
//  MessageCell.m
//  BabyWith
//
//  Created by wangminhong on 13-7-1.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 20, 40, 40)];
//        iconImageView.image = [UIImage imageNamed:@"messageIcon.png"];
//        
//        [self.imageView addSubview:iconImageView];
//        [iconImageView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    
    [super layoutSubviews];

    
    
    
    self.textLabel.frame = CGRectMake(16, 0, 300, 55);
    self.textLabel.numberOfLines = 2;
    [self.imageView addSubview:self.textLabel];
    
    self.detailTextLabel.frame = CGRectMake(16, 64, 200, 20);
    [self.imageView addSubview:self.detailTextLabel];

}

@end
