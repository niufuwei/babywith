//
//  BaseTableViewCell.m
//  meiliyue
//
//  Created by Fly on 12-11-22.
//  Copyright (c) 2012年 Fly. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (id)init{
    
    return [self initWithIndex:0];
    
}

- (id)initWithXibName:(NSString*)strName{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:strName owner:self options:nil];
    self = [nibs objectAtIndex:0];
    if (self) {
        
    }
    return self;
}

- (id)initWithIndex:(NSInteger)index{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self = [nibs objectAtIndex:index];
    if (self) {
        
    }
    return self;
}

- (CGFloat)getCellHeight{
    return CGRectGetHeight(self.frame);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)dealloc{
//    NSLog(@"Cell__%@__dealloc",NSStringFromClass([self class]));
//}

@end
