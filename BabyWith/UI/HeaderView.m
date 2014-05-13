//
//  HeaderView.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-1.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 320, 20)];
        _headerLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_headerLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
