//
//  SettingCell.m
//  AiJiaJia
//
//  Created by wangminhong on 13-5-25.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "SettingCell.h"
#import "Configuration.h"

@implementation SettingCell
@synthesize sureType = _sureType;
@synthesize cellType = _cellType;
@synthesize passwordString = _passwordString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.textLabel.textColor = babywith_text_color;
        self.cellType = 0; //默认为0， 1-button。
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews

{
    [super layoutSubviews];
    
    if (self.cellType == 1) {
//        self.textLabel.frame = self.frame;
        self.backgroundColor = babywith_green_color;
        NSLog(@"self.frame = [%f][%f][%f][%f]",self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.textLabel.frame.size.width,self.textLabel.frame.size.height);
        self.textLabel.font = [UIFont systemFontOfSize:20];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.frame = CGRectMake(10, 0, 300, self.frame.size.height);
        NSLog(@"text === [%@]",self.textLabel.text);
        
        return;
    }
    
    if (_headImageView != nil) {
        [self addSubview:self.headImageView];
        
        self.imageView.frame = CGRectMake(236, 14, 56, 26);
        self.textLabel.frame = CGRectMake(68, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
        
    }else{
        self.imageView.frame = CGRectMake(236, 10, 56, 26);
        self.textLabel.frame = CGRectMake(10, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    }
    self.textLabel.font = [UIFont systemFontOfSize:16];
    
    
}

@end
