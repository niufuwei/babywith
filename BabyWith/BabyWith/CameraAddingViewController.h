//
//  CameraAddingViewController.h
//  AiJiaJia
//
//  Created by wangminhong on 13-5-16.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "SearchDVS.h"
#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraAddingViewController : BaseViewController<UITextFieldDelegate,ZBarReaderDelegate, SearchCameraResultProtocol, UITableViewDataSource, UITableViewDelegate,AVCaptureMetadataOutputObjectsDelegate>{
    
    CSearchDVS  *_pSearchDVS;
    NSMutableArray *_cameraSearchList;
    UITableView *_cameraListTableView;
    
    
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UILabel * _labIntroudction;
    UIImageView * _imageView;
    
}
@property(retain,nonatomic)AVCaptureSession *session;
@property(retain,nonatomic)  AVCaptureVideoPreviewLayer *previewLayer;
@property(retain,nonatomic)UIImageView *line;
@end
