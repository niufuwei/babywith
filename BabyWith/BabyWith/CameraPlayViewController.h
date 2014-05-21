//
//  CameraPlayViewController.h
//  AiJiaJia
//
//  Created by wangminhong on 13-6-17.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configuration.h"
#import "APICommon.h"
#import "PPPPDefine.h"
#import "PPPP_API.h"
#import "obj_common.h"
#import "PPPPChannelManagement.h"
#import "MyAudioSession.h"
#import "ImageNotifyProtocol.h"
#import "BaseViewController.h"
#import "CustomAVRecorder.h"
@class CameraMainViewController;
@class CameraPhotoRecordViewController;

@interface CameraPlayViewController : BaseViewController<ImageNotifyProtocol,UIGestureRecognizerDelegate ,UICollectionViewDataSource ,UICollectionViewDelegate,UIAlertViewDelegate>
{
    UIImageView *_playView;
    NSCondition *_m_PPPPChannelMgtCondition;
    NSString *_cameraID;
    //UIImageView *_snapImageView;
    NSMutableArray *_imageArray;
    int _photoCount;
    int _lockFlag;  //锁屏标志 竖屏时可用 0:不锁屏 1:锁屏
    int _rotateEnableFlag; //横竖屏转换可用标志 0：不可转换 1：可转换
    int _orientationFlag; //横竖屏标志 0：竖屏 1：横屏
    UIBarButtonItem *_rightItem;
    NSMutableDictionary *_currentDeviceDic;
    int _switchFlag;
    int _finishFlag;   //为0连接成功   1未成功
    int _stopConnectFlag;   //1是未停止连接  0是连接成功
    int _wifiFlag;
    int _talkFlag;
    int _listenFlag;
    int _passwordFlag;//是否使用初始密码连接过 0：没有  1：有
    NSString *_errorMsg;
    int _errorFlag;
    UIButton *_lockButton;
    CameraPhotoRecordViewController *_cameraPhotoRecordViewController;
    NSTimer *_hiddenTimer;
    int _toolBarHiddenFlag;  //工具栏显示隐藏标志 0：显示 1：隐藏
    int _touchFlag;   //横屏触摸工具栏边框时不定时隐藏工具栏 0：未触摸 1：触摸
    
    int _isRecord;//给三个值,1代表录制按钮按下正在录制，2代表录制按钮按下录制完成，3代表normal状态
    UIImage *_recordImage;//视频的第一张图片，作为显示的时候用
    int _vedioHasRecord;
    
    CCustomAVRecorder *_customAVRecorder;
    
    BOOL _isFirst;
    BOOL _isViode;
    
    
}

@property (nonatomic, retain) UIImageView *playView;
@property (nonatomic, retain) NSCondition *m_PPPPChannelMgtCondition;
@property (nonatomic, retain) NSString *cameraID;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSMutableArray *collectionImageArray;
@property (nonatomic, retain) UIView *pView;
@property (nonatomic, retain) UIView *lView;
@property (nonatomic, retain) UIView *lTalkView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property CCustomAVRecorder *customAVRecorder;
@property (nonatomic, assign) BOOL isStart ,isFullScreen;
@property (nonatomic, retain) NSMutableData *recordData;//取得的视频流数据
@property (nonatomic, assign) int isRecord;


-(void)CameraTargetPressed;
-(void)rotateToOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
-(NSInteger)EnableRotate;

@end
