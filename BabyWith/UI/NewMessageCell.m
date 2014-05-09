//
//  NewMessageCell.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "NewMessageCell.h"
#import "Configuration.h"
@implementation NewMessageCell

- (void)awakeFromNib
{
    // Initialization code
    _agreeShareBtn.backgroundColor = babywith_green_color;
    
    _refuseShareBtn.backgroundColor = babywith_green_color;
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)dealloc {
    [_messageLabel release];
    [_agreeShareBtn release];
    [_refuseShareBtn release];
    [super dealloc];
}

@end
