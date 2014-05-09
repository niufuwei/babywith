//
//  AppGlobal.h
//  meiliyue
//
//  Created by Fly on 12-11-27.
//  Copyright (c) 2012年 Fly. All rights reserved.
//

#ifndef meiliyue_AppGlobal_h
#define meiliyue_AppGlobal_h

//#import "TableData.h"
//#import "CellData.h"
//#import "AppNotice.h"

//category
//#import "UIViewController+Customize.h"
//#import "NSString+Unit.h"
//#import "UIView+Frame.h"
//#import "WCAlertView.h"
//
//#import "libFrame.h"
#import "ULog.h"

#define APP                 ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define USRDEFAULT          [NSUserDefaults standardUserDefaults]
#define LOCSTR(s)           NSLocalizedString(s, nil) 
#define NOTICECENTER        [NSNotificationCenter defaultCenter]

#define kAllRemoteNotificationType     (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)

#define kAppStoreURL            @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=661970205"

#define kAppStoreReviewsURL     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=661970205"


#define kIsIphone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kUncompletedIAPOrder    @"uncompletedIAPOrder"

#define kValidTimeinterval      30 * 60
#define kMaxMessageCount        99

#define COLOR(R,G,B)        [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]
#define COLORA(R,G,B,A)     [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#define ccp(__X__,__Y__) CGPointMake(__X__,__Y__)
static inline CGPoint
ccpSubY(const CGPoint v1, const CGFloat y)
{
	return ccp(v1.x, v1.y - y);
}

#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0) 


#define kStatueBarHeight    ([[UIApplication sharedApplication] isStatusBarHidden] ? 0 : 20)
#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight       [[UIScreen mainScreen] bounds].size.height

#define kViewHeight         kScreenHeight

#define kScreenScale        [[UIScreen mainScreen] scale]
#define KNavigationHeight   44
#define KTabBarHeight       44
#define KSearBarHeight      44
#define kDefaultShowHobbyLine    3

#define kAnimateDuration3   0.3f
#define kAnimateDuration6   0.6f
#define kRoundedCorner9     9
#define kRoundedCorner12    12
#define kRoundedCorner14    14
#define kRoundedCorner18    18
#define kBorderSize         0
#define kLabNoticeWidth     140.0f



#define VALIDDAINTCOUNT     3
#define PAGESIZEDEFAULT     20
#define PAGEStartIndex      1
#define PAGESTARTTIME       0
#define PAGESIZEONE         1
#define PAGESIZECHATRECORD  10

#define PROGRESSSHOWTIME2   1
//#define SHOULD

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)





#define RELEASE

#ifdef  RELEASE
#define BASEURL                 @"http://192.168.1.96:8091/"
#else
#define BASEURL                 @"http://192.168.18.105:8081/aiJIaJIaWebservice" //开发用的IP
#endif

#define MY_INTERSTITIAL_UNIT_ID     @"a1523e5df55385d"

#define kCellShadowOffset       4

#define kAngleToRadian(angle)   ((M_PI / 180.0) * angle) 
#define kRadianToAngle(radian)  (radian * M_PI) / 180.0

#define kPlaceHolderImage   kIsMaleUser ? kPlaceHolderGirl : kPlaceHolderBoy

#define kPlaceHolderGirl    [UIImage imageNamed:@"place_holder_girl.png"]
#define kPlaceHolderBoy     [UIImage imageNamed:@"place_holder_boy.png"]

#define kPlaceHolderPlace   [UIImage imageNamed:@"place_holder_Place.png"]


#define kMinRequestDuration         60
#define kValidGetCheckCodeNum       3
#define kShowDatingAlertViewCount   5

#define kHobbiesShowViewY           38
#define kHobbiesShowViewWidth       296



#endif





