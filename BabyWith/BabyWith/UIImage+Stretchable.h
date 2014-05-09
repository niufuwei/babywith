//
//  UIImage+Stretchable.h
//  meiliyue
//
//  Created by Fly on 12-11-23.
//  Copyright (c) 2012年 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Stretchable)

- (UIImage*) getStretchableImage;
- (UIImage*) getStretchableImage:(CGFloat)left withTop:(CGFloat)top;
+ (UIImage*) getImageFromBundle:(NSString *)strImgName;
@end
