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
    
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    //20.79.104.30
    _agreeShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 79, 104, 30)];
    [_agreeShareBtn setTitle:@"同意" forState:UIControlStateNormal];
    [_agreeShareBtn setTintColor:[UIColor whiteColor]];
    [_agreeShareBtn setBackgroundColor:babywith_green_color];
    [self addSubview:_agreeShareBtn];
    
    
    self.backgroundColor = babywith_background_color;
    
    //196.79.104.30
    _refuseShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(196, 79, 104, 30)];
    [_refuseShareBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [_refuseShareBtn setTintColor:[UIColor whiteColor]];
    [_refuseShareBtn setBackgroundColor:babywith_green_color];
    [self addSubview:_refuseShareBtn];
    
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}


@end
