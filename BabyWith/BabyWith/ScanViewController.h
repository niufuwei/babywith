//
//  ScanViewController.h
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-25.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>


@property(retain,nonatomic)AVCaptureSession *session;
@property(retain,nonatomic)  AVCaptureVideoPreviewLayer *previewLayer;
@end
