//
//  CustomSegmentView.h
//  meiliyue
//
//  Created by Fly on 12-12-10.
//  Copyright (c) 2012年 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface  SegmentMember: UIView

- (void) addBtnBackListener:(id)target action:(SEL)action;

@property(unsafe_unretained,  nonatomic) IBOutlet UILabel*			mTitle;
@property(unsafe_unretained,  nonatomic) IBOutlet UILabel*			mTitle1;

@property(unsafe_unretained,  nonatomic) IBOutlet UIImageView*		mImageView;
@property(unsafe_unretained,  nonatomic) IBOutlet UIButton*			mBtn;
@property(strong,  nonatomic)            UIImage*					mNormal;
@property(strong,  nonatomic)            UIImage*					mHightlighted;
@end



@protocol CustomSegmentViewDelegate <NSObject>
-(void)segmentSelected:(id)sender;
@end


@interface CustomSegmentView : UIView

-(void)setTitle:(NSString*)title index:(NSInteger)index;

//可以继续添加成员
@property (unsafe_unretained, nonatomic) IBOutlet SegmentMember* mMem0;
@property (unsafe_unretained, nonatomic) IBOutlet SegmentMember* mMem1;
@property (unsafe_unretained, nonatomic) IBOutlet SegmentMember* mMem2;
@property (unsafe_unretained, nonatomic) IBOutlet SegmentMember* mMem3;
@property (unsafe_unretained, nonatomic) IBOutlet SegmentMember* mMem4;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView*   mImgViewAnimation;
@property (strong, nonatomic) NSMutableArray*				mList;
@property (nonatomic, assign) NSInteger						mSelectIndex;
@property (unsafe_unretained, nonatomic) id<CustomSegmentViewDelegate> mDelegate;
@property (strong, nonatomic) UIColor*						mNormalTextColor;
@property (strong, nonatomic) UIColor*						mHightlightedTextColor;
@property (strong, nonatomic) UIColor*						mNormalShadowColor;
@property (strong, nonatomic) UIColor*						mHightlightedShadowColor;
@property (assign, nonatomic) CGSize                        mNormalShadowOffset;
@property (assign, nonatomic) CGSize                        mHightlightedShadowOffset;

@property (assign, nonatomic) BOOL                          mbSupportImageAnimation;
@property (assign, nonatomic) BOOL                          mbEnable;


@end
