//
//  CollectionCell.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-31.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75.5, 75.5)];
        [self addSubview:_image];
        
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
-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
