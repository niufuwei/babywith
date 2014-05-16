//
//  ImagePickerController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-27.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "ImagePickerController.h"
#import "UIViewController+Alert.h"
#import "Configuration.h"
#import "MainAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "AppGlobal.h"
@interface ImagePickerController ()

@end

@implementation ImagePickerController


#pragma mark get/show the UIView we want
- (UIView *)findView:(UIView *)aView withName:(NSString *)name {
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([name isEqualToString:desc])
		return aView;
	
	for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;
}
#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        UIImage *deviceImage = [UIImage imageNamed:@"切换视角.png"];
        UIButton *deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deviceBtn setBackgroundImage:deviceImage forState:UIControlStateNormal];
        [deviceBtn addTarget:self action:@selector(swapFrontAndBackCameras:)
            forControlEvents:UIControlEventTouchUpInside];
        [deviceBtn setFrame:CGRectMake(250, 20, 60, 30)];
        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        
        //        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        UIImage *backImage = [UIImage imageNamed:@"camera_cancel.png"];
        //        [backBtn setImage: backImage forState:UIControlStateNormal];
        //        [backBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        //        [backBtn setFrame:CGRectMake(10, 21, 28, 28)];
        
        UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
        [PLCameraView addSubview:deviceBtn];
        //        [PLCameraView addSubview:backBtn];
        
//        if (kIsIphone5) {
//            self.cameraOverlayView.frame = CGRectMake(0, 0, 320, 514);
//        }
        

        [self setShowsCameraControls:NO];
        
        UIView *overlyView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, 320, self.view.frame.size.height - ScreenHeight)];
        [overlyView setBackgroundColor:babywith_green_color];
        
        UIButton *cameraBtn;
        UIButton *imageButton;
        UIButton *photoBtn;
        
        if (kIsIphone5) {
            cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cameraBtn.frame=CGRectMake(160-45, overlyView.frame.size.height-115, 90, 90);
            
            imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame=CGRectMake(25, (overlyView.frame.size.height - 25)/2, 40, 30);
            
            photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            photoBtn.frame=CGRectMake(260, (overlyView.frame.size.height - 25)/2, 40, 30);
        }
        
        else
        {
            cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cameraBtn.frame=CGRectMake(125, overlyView.frame.size.height-70, 70, 70);
            
            imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame=CGRectMake(25, (overlyView.frame.size.height - 25)/2, 30, 20);
            
            photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            photoBtn.frame=CGRectMake(260, (overlyView.frame.size.height - 25)/2, 30, 20);

        }

        
    
        [imageButton setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
        [imageButton setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateHighlighted];
        [imageButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        imageButton.tag = 10;
        [overlyView addSubview:imageButton];
        
        
        
        
        [cameraBtn setImage:[UIImage imageNamed:@"拍照1.png"] forState:UIControlStateNormal];
        [cameraBtn setImage:[UIImage imageNamed:@"拍照1.png"] forState:UIControlStateHighlighted];
        [cameraBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        cameraBtn.tag = 20;
        [overlyView addSubview:cameraBtn];
//        [cameraBtn release];
        
     
        [photoBtn setBackgroundImage:[UIImage imageNamed:@"保存.png"] forState:UIControlStateNormal];
        [photoBtn setBackgroundImage:[UIImage imageNamed:@"保存.png"] forState:UIControlStateHighlighted];
        photoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        photoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        photoBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        photoBtn.tag = 30;
        [photoBtn addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
        [overlyView addSubview:photoBtn];
//        [photoBtn release];
        
        self.cameraOverlayView = overlyView;
//        [overlyView release];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    
    _imageArray = [[NSMutableArray alloc] initWithCapacity:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}
#pragma mark - ButtonAction Methods

//调转摄像头，前后摄像头，主副摄像头
- (void)swapFrontAndBackCameras:(id)sender {
    if (self.cameraDevice ==UIImagePickerControllerCameraDeviceRear ) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

//返回
- (void)closeView
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//拍照
- (void)takePicture
{
    //    [self performSelector:@selector(AnimationCameraClose) withObject:nil afterDelay:0.1];
    UIButton *button = (UIButton*)[self.cameraOverlayView viewWithTag:20];
    button.enabled = NO;
    [button setImage:[UIImage imageNamed:@"拍照1.png"] forState:UIControlStateNormal];
    
    [super takePicture];
}

//完成按钮
- (void)showPhoto
{
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //    [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([_imageArray count] == 0) {
        [self makeAlert:@"还没拍照哦"];
        return;
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
        [_customDelegate cameraPhoto:_imageArray];
    }];
    
    [[NSNotificationCenter defaultCenter ]postNotificationName:@"imageCollectionReload" object:self userInfo:nil];
    
}



//拍完之后
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image != nil) {
        
        
        //保存到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        
        //拍照片的时间信息
        NSDate *date = [NSDate date];
        NSTimeInterval time = [date timeIntervalSince1970];
        
        
        //取得拍出来的原照片
        CGImageRef imageRef;
        imageRef = [image CGImage];
        NSInteger widthRealRef = CGImageGetHeight(imageRef);
        NSInteger heightRealRef = CGImageGetWidth(imageRef);
        
        NSInteger widthFirst=heightRealRef;
        NSInteger heightFirst=widthRealRef;
        NSInteger width;
        NSInteger height;
        
        //根据方向信息取得宽度和高度的数据
        int orientation = [[[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"Orientation"] integerValue];
        if (orientation == 1) {
            widthFirst = heightRealRef;
            heightFirst = widthRealRef;
        }else if(orientation == 6) {
            widthFirst = widthRealRef;
            heightFirst = heightRealRef;
        }else if(orientation == 3) {
            widthFirst = heightRealRef;
            heightFirst = widthRealRef;
        }else if(orientation == 8) {
            widthFirst = widthRealRef;
            heightFirst = heightRealRef;
        }
        
        orientation = 8;
        
//        //根据高度和宽度设定宽度和高度
//        if (800*widthRealRef > 600* heightRealRef) {
//            height = (heightFirst*600)/widthFirst;
//            width = 300;
//        }else{
//            width = (widthFirst*800)/heightFirst;
//            height = 400;
//        }
        
        width = 320;
        height = self.view.frame.size.height - 64;
        
        //画出来一个缩小的图片
        CGSize navSize = CGSizeMake(width, height);
        UIGraphicsBeginImageContext(navSize);
        [image drawInRect:CGRectMake(0, 0, navSize.width, navSize.height)];
        UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSLog(@"scaleImage = [%f] [%f]", scaleImage.size.width, scaleImage.size.height);
       
        
        UIImage *imageForUse = [UIImage imageWithCGImage:scaleImage.CGImage scale:1 orientation:orientation];//缩图
        UIButton *showButton = (UIButton *)[self.view viewWithTag:10];
        [showButton setBackgroundImage:imageForUse forState:UIControlStateNormal];//左下角的方形的按钮显示拍下来的图片
        showButton.enabled = NO;
        
        //转换成数据信息存储
        NSData *imageData = UIImageJPEGRepresentation(imageForUse,0.5);
        NSLog(@"data length =[%lu]", (unsigned long)[imageData length]);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *tmpDir =  NSTemporaryDirectory();
        //根据时间所做的路径信息
        NSString *filePath = [tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%.0f", time*1000]];
        if (![fileManager createFileAtPath:filePath contents:imageData attributes:nil]) {
            [self makeAlert:@"保存图片出错。"];
        }
        
        //获取快照
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:filePath,@"image",[NSString stringWithFormat:@"%.0f", time*1000], @"time", date, @"date",  [NSString stringWithFormat:@"%d", width], @"width", [NSString stringWithFormat:@"%d", height], @"height",nil];
        [_imageArray addObject:dic];//添加到数组
        
        //牌拍照之后图片显示也不一样
        UIButton *button = (UIButton*)[self.cameraOverlayView viewWithTag:20];
        button.enabled = YES;
        [button setImage:[UIImage imageNamed:@"拍照1.png"] forState:UIControlStateNormal];
        
        //最多拍五张
        if ([_imageArray count] == 5) {
            
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
            MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
            indicator.labelText = @"已拍了5张照片，去处理咯";
            indicator.mode = MBProgressHUDModeText;
            [window addSubview:indicator];
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [indicator removeFromSuperview];
//                [indicator release];
                
                [self showPhoto];
            }];
        }
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    if(_isSingle){
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            [picker dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}
//代理方法，这里面不需要写什么
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    
    
    
}
@end
