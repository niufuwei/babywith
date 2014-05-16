//
//  ImagePickerController.h
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-27.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ScreenHeight (IS_IPHONE5 ? 514.0-87.0 : 426.0)

@protocol ImagePickerControllerDelegate;





@interface ImagePickerController : UIImagePickerController<UINavigationControllerDelegate,
                                      UIImagePickerControllerDelegate>
{
    NSMutableArray *_imageArray;

    id<ImagePickerControllerDelegate>_imageDelegate;
}
@property(nonatomic)BOOL isSingle;
@property(nonatomic,assign)id<ImagePickerControllerDelegate> customDelegate;

@end


@protocol ImagePickerControllerDelegate <NSObject>

-(void)cameraPhoto:(NSArray*)imageArra;

@end