//
//  CustomSegmentView.m
//  meiliyue
//
//  Created by Fly on 12-12-10.
//  Copyright (c) 2012年 Fly. All rights reserved.
//

#import "CustomSegmentView.h"
#import "UIImage+Stretchable.h"


@implementation SegmentMember

-(void)awakeFromNib{
	[super awakeFromNib];
	self.backgroundColor = [UIColor clearColor];
    self.mNormal = [self.mImageView.image getStretchableImage];
    self.mHightlighted = [self.mImageView.highlightedImage getStretchableImage];
}
- (void)dealloc {
    
	self.mTitle = nil;
    self.mTitle1 = nil;
	self.mImageView = nil;
	self.mBtn = nil;
    [super dealloc];//my add
}
- (void) addBtnBackListener:(id)target action:(SEL)action{
	[_mBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end


@interface CustomSegmentView ()
- (void)btnClick:(id)sender;
@end


@implementation CustomSegmentView

-(void)awakeFromNib{
	[super awakeFromNib];
    _mbEnable = true;
	self.backgroundColor = [UIColor clearColor];
	
	//缺省值
	self.mNormalTextColor = [UIColor blackColor];
	self.mHightlightedTextColor = [UIColor blackColor];
	self.mNormalShadowColor = [UIColor whiteColor];
	self.mHightlightedShadowColor = [UIColor whiteColor];
	
	self.mList = [[NSMutableArray alloc] init];;
	
	if (_mMem0 != nil) {
		[_mList addObject:_mMem0];
	}
	if (_mMem1 != nil) {
		[_mList addObject:_mMem1];
	}
	if (_mMem2 != nil) {
		[_mList addObject:_mMem2];
	}
    if (_mMem3 != nil) {
        [_mList addObject:_mMem3];
    }
    if (_mMem4 != nil) {
        [_mList addObject:_mMem4];
    }
	long i = 0;
	for (SegmentMember* member in _mList) {
		[member.mBtn setTag:i++];
		[member addBtnBackListener:self action:@selector(btnClick:)];
	}
	_mSelectIndex = -1;
}

- (void)dealloc {
	self.mMem0 = nil;
	self.mMem1 = nil;
	self.mMem2 = nil;
    self.mMem3 = nil;
    self.mMem4 = nil;
    self.mImgViewAnimation = nil;
	self.mDelegate = nil;
    [super dealloc];
}

-(void)setTitle:(NSString*)title index:(NSInteger)index{
	if (index < 0 || index > [_mList count] - 1) {
		return ;
	}
	SegmentMember* member = [_mList objectAtIndex:index];
	[member.mTitle setText:title];
}

-(void)setMSelectIndex:(NSInteger)index{
	if (index < 0 || index > [_mList count] - 1) {
		return ;
	}
	long i = 0;
	for (SegmentMember* member in _mList) {
		if(index == i++){
			[member.mTitle setTextColor:_mHightlightedTextColor];
			[member.mTitle setShadowColor:_mHightlightedShadowColor];
            [member.mTitle setShadowOffset:_mHightlightedShadowOffset];
            
            [member.mTitle1 setTextColor:_mHightlightedTextColor];
			[member.mTitle1 setShadowColor:_mHightlightedShadowColor];
            [member.mTitle1 setShadowOffset:_mHightlightedShadowOffset];
            
			member.mImageView.image = [member.mHightlighted getStretchableImage];
		}else {
			[member.mTitle setTextColor:_mNormalTextColor];
			[member.mTitle setShadowColor:_mNormalShadowColor];
            [member.mTitle setShadowOffset:_mNormalShadowOffset];
            
            [member.mTitle1 setTextColor:_mNormalTextColor];
			[member.mTitle1 setShadowColor:_mNormalShadowColor];
            [member.mTitle1 setShadowOffset:_mNormalShadowOffset];
            
			member.mImageView.image = [member.mNormal getStretchableImage];
		}
	}
	_mSelectIndex = index;
}

-(void)btnClick:(id)sender{
	if (!_mbEnable) {
        return;
    }
	long index = ((UIView*)sender).tag;
    long nPreSelectIndex = _mSelectIndex;
	if (_mSelectIndex == index) {
		return ;
	}
	self.mSelectIndex = index;
    if (_mbSupportImageAnimation && nPreSelectIndex != -1) {
        if (_mImgViewAnimation) {
            SegmentMember* preMember = [_mList objectAtIndex:nPreSelectIndex];
            SegmentMember* nextMember = [_mList objectAtIndex:_mSelectIndex];
            CGRect preRect = preMember.frame;
            CGRect nextRect = nextMember.frame;
            CGRect animationRect = _mImgViewAnimation.frame;
            animationRect.origin.x += nextRect.origin.x - preRect.origin.x;

            [UIView animateWithDuration:0.2f animations:^{
                _mImgViewAnimation.frame = animationRect;
            } completion:^(BOOL finished){
            }];
        }else{
            SegmentMember* preMember = [_mList objectAtIndex:nPreSelectIndex];
            SegmentMember* nextMember = [_mList objectAtIndex:_mSelectIndex];
            nextMember.mImageView.hidden = YES;
            UIImageView* imageView = [[UIImageView alloc] initWithImage:[preMember.mImageView.image getStretchableImage]];
            imageView.image = [preMember.mHightlighted getStretchableImage];
            CGRect preRect = preMember.mImageView.frame;
            preRect.origin.x += preMember.frame.origin.x;
            CGRect nextRect = nextMember.mImageView.frame;
            nextRect.origin.x += nextMember.frame.origin.x;
            
            [self addSubview:imageView];
            imageView.frame = preRect;
            
            
            [UIView animateWithDuration:0.2f animations:^{
                imageView.frame = nextRect;
            } completion:^(BOOL finished){
                [imageView removeFromSuperview];
                nextMember.mImageView.hidden = NO;
            }];
        }

    }
	if (_mDelegate != nil && [_mDelegate respondsToSelector:@selector(segmentSelected:)]) {
		[_mDelegate segmentSelected:self];
	}
}

-(void)setMbEnable:(BOOL)enable
{
    _mbEnable = enable;
    for (SegmentMember *mem in _mList) {
        mem.mBtn.enabled = _mbEnable;
    }
}

@end
