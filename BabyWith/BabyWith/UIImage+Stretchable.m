//
//  UIImage+Stretchable.m
//  meiliyue
//
//  Created by Fly on 12-11-23.
//  Copyright (c) 2012年 Fly. All rights reserved.
//

#import "UIImage+Stretchable.h"

@implementation UIImage (Stretchable)

- (UIImage*) getStretchableImage{
    UIImage* pStretchableImage  = [self stretchableImageWithLeftCapWidth:floorf(self.size.width/2.0f) topCapHeight:floorf(self.size.height/2.0f)];
    return pStretchableImage;
}

- (UIImage*) getStretchableImage:(CGFloat)left withTop:(CGFloat)top{
    UIImage* pStretchableImage  = [self stretchableImageWithLeftCapWidth:left topCapHeight:top];
    return pStretchableImage;
}

+ (UIImage *) getImageFromBundle:(NSString *)strImgName{
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:strImgName ofType:@""];
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
    return img;
}

@end
