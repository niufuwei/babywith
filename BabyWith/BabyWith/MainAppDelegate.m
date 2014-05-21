//
//  ABCAppDelegate.m
//  BabyWith
//
//  Created by wangminhong on 13-6-25.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import "SQLiteManager.h"
#import "DeviceConnectManager.h"
#import "UIViewController+Alert.h"
#import <AdSupport/ASIdentifierManager.h>


#import "Reachability.h"
#import "UncaughtExceptionHandler.h"

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "ShareViewController.h"
#import "RecordsViewController.h"
#import "SettingsViewController.h"
#import "BaseNavigationController.h"
#import "BaseTabBarController.h"

#import "AppGlobal.h"
#import "Configuration.h"

@implementation MainAppDelegate

@synthesize window = _window;
@synthesize appDefault = _appDefault;
@synthesize webInfoManger = _webInfoManager;
@synthesize sqliteManager = _sqliteManager;
@synthesize deviceConnectManager = _deviceConnectManager;
@synthesize messageArray = _messageArray;
@synthesize m_PPPPChannelMgt = _m_PPPPChannelMgt;
@synthesize recordMutableDictionary = _recordMutableDictionary;
@synthesize recordLocalYearCountArray = _recordLocalYearCountArray;
@synthesize recordLocalMonthCountDic = _recordLocalMonthCountDic;
@synthesize recordLocalYearMonthListDic = _recordLocalYearMonthListDic;
@synthesize navFlag = _navFlag;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor  = babywith_background_color;
    
    NSLog(@"launchOptions   %@",launchOptions);
    

    
//    if (IOS7){
//        [application setStatusBarStyle:UIStatusBarStyleLightContent];
//        self.window.clipsToBounds =YES;
//        self.window.frame =  CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height-20);                //added on 19th Sep
//        self.window.bounds = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
//    }else{
//        //设置状态条风格为黑色
//        [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
//}
    

  
    
    
    //防锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES; 
    
    InstallUncaughtExceptionHandler();
    
    
    
    //全局变量初始化
    self.appDefault = [NSUserDefaults standardUserDefaults];
    [appDelegate.appDefault setObject:babywith_gate_address forKey:@"BabyWith_address_api"];

    //远程服务管理类
    _webInfoManager = [[WebInfoManager alloc] init];
    
    //数据库类初始化
    _sqliteManager = [[SQLiteManager alloc] init];
    
    [self Initialization];
    
    //app事件通知注册
    [self NotificationInitlize];
    
   
    self.window.rootViewController = [self getLoginNav];
    [self.window makeKeyAndVisible];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    //判断程序是不是由推送服务完成的
    
    NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

    if (pushNotificationKey)
    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送通知"
//                                                       message:@"这是通过推送窗口启动的程序，你可以在这里处理推送内容"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"知道了"
//                                             otherButtonTitles:nil, nil];
//        [alert show];
//        //[alert release];
        
        
        
        //消息的内容，所有的都一样
        NSString *alertStr  = [[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] ;
        
        [appDelegate.appDefault setObject:alertStr forKey:@"alert"];
        
        
        
        
        //接收消息的时间
        NSDate *date = [NSDate date];
        NSTimeInterval time = [date timeIntervalSince1970];
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *messageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        
        //接收到的消息id,以;隔开的
        NSLog(@"message id is %@",[pushNotificationKey objectForKey:@"msgid"]);
        NSArray *msgIdArray = [[pushNotificationKey objectForKey:@"msgid"] componentsSeparatedByString:@";"];
        NSLog(@"msgid array is %@",msgIdArray);
        
        //数组里面包括每一条推送消息的id号和对应的时间，因为一次可能发送过来好几条消息，这几条消息的时间是一样的
        NSMutableArray *messageArr = [[NSMutableArray alloc] initWithCapacity:1];
        for (id obj in msgIdArray)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"0",@"msgid",@"messageTime",nil];
            
            [dic setValue:obj forKey:@"msgid"];
            [dic setValue:messageTime forKey:@"messageTime"];
            [messageArr addObject:dic];
            
        }
        
        
        //主页的消息，只包括消息内容和消息id
        if ([self.appDefault integerForKey:@"firstUse"] == 0)
        {
            [self.appDefault setObject:msgIdArray forKey:@"messageArray"];
            [self.appDefault setObject:messageArr forKey:@"systemMessageArray"];
            [self.appDefault setInteger:1 forKey:@"firstUse"];
            
        }
        else
        {
            [self.messageArray removeAllObjects];

            [self.messageArray addObjectsFromArray:[self.appDefault objectForKey:@"messageArray"]];
            [self.messageArray addObjectsFromArray:msgIdArray];
            [self.appDefault setObject:self.messageArray forKey:@"messageArray"];
            [self.messageArray removeAllObjects];

            
            
            //更多里面的消息，包括消息内容、消息id、消息收到的时间
            [self.systemMessageArray removeAllObjects];

            [self.systemMessageArray addObjectsFromArray:[self.appDefault objectForKey:@"systemMessageArray"]];
            [self.systemMessageArray addObjectsFromArray:messageArr];
            [self.appDefault setObject:self.systemMessageArray forKey:@"systemMessageArray"];
            [self.systemMessageArray removeAllObjects];

            
        }
        
        
        
        //主页消息图标的改变
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCount" object:nil];
        //更多里面的图标的改变
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCount1" object:nil];
 
        
    }
 
   

    return YES;
}



-(void)Initialization{
    //设备管理类初始化
    _deviceConnectManager = [[DeviceConnectManager alloc] init];
    [_deviceConnectManager initlize];
    
    //通知消息队列
    _messageArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    //本地记录
    _recordMutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    //本地记录年份对应的记录数
    _recordLocalYearCountArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    //本地记录年份对应的各个月份记录数
    _recordLocalMonthCountDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    //本地记录年份对应的各个月份记录列表
    _recordLocalYearMonthListDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    //
    _recordLocalDayCountDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    _recordLocalDayListDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    
    
    
    
    _selectDeviceArr = [[NSMutableArray alloc] init];
    _systemMessageArray = [[NSMutableArray alloc] init];
    
}



//进入登陆页面
-(void)MoveToLogin{
    
    if (_m_PPPPChannelMgt != NULL) {
        _m_PPPPChannelMgt->StopAll();
    }
    [self Initialization];
    self.window.rootViewController = [self getLoginNav];
  
}


-(void)MoveToMain{
    
    _navFlag = 1;
    
    //获取本地年份对应的数量
    [self.sqliteManager getLocalListOfYearCount];
   // NSLog(@"年份%d",[_recordLocalYearCountArray count]);
    
    
    
    

    
 PPPP_Initialize((char*)"EFGBFFBJKDJBGNJBEBGMFOEIHPNFHGNOGHFBBOCPAJJOLDLNDBAHCOOPGJLMJGLKAOMPLMDIOLMFAFCJJPNEIGAM");
    appDelegate.m_PPPPChannelMgt = new BabyWithCameraManagement();
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    Reachability *_hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	[_hostReach startNotifier];
    [_hostReach release];
    self.window.rootViewController = [self getRootTabbar];
}



-(void)NotificationInitlize {
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(MoveToLogin)
                                                 name: @"MoveToLogin"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(MoveToMain)
                                                 name: @"MoveToMain"
                                               object: nil];
}

-(void)NotificationUnInitlize {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"MoveToLogin"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"MoveToMain"
                                                  object:nil];
}



//风火轮
int HudIsBecome = 0;
- (void)myTask {
    while (HudIsBecome == 1) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)showWithLabel:(NSString *)title {
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (HudIsBecome == 1) {
            return ;
        }
        HudIsBecome = 1;
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        
        MBProgressHUD *hud = [[[MBProgressHUD alloc] initWithView:window] autorelease];
        [window addSubview:hud];
        
        hud.delegate = self;
        hud.labelText = title;
        
        [hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    });
    
}


- (void)endHud {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        HudIsBecome = 0;
    });
}
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    self.networkStatus = [curReach currentReachabilityStatus];
    
    if ([_appDefault integerForKey:@"Mac_valid_flag"] != 1) {
        NSLog(@"mac valid flag net status changed========");
        return;
    }
    
    
}





- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
}

- (void)AlarmProtocolResult:(NSString *)szDID motion_armed:(int)motion_armed motion_sensitivity:(int)motion_sensitivity input_armed:(int)input_armed ioin_level:(int)ioin_level alarmpresetsit:(int)alarmpresetsit iolinkage:(int)iolinkage ioout_level:(int)ioout_level mail:(int)mail snapshot:(int)snapshot upload_interval:(int)upload_interval record:(int)record
{
    
    NSLog(@"=========================================================");
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[_deviceConnectManager getDeviceInfo:szDID]];
//    [dic setObject:[NSString stringWithFormat:@"看护器“%@”发生移动侦测", [dic objectForKey:@"name"]] forKey:@"text"];
//    [dic setObject:@"1" forKey:@"status"];
//    [appDelegate.messageArray insertObject:dic atIndex:0];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMessageCount" object:@"1"];
    
    NSLog(@"移动侦测的返回参数是%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",motion_armed,motion_sensitivity,input_armed,ioin_level,alarmpresetsit,iolinkage,ioout_level,mail,snapshot,upload_interval,record);
    
    
    
    
    
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{

   return UIInterfaceOrientationMaskPortrait;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive =============");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground==============");
    if (_m_PPPPChannelMgt != NULL)
    {
        _m_PPPPChannelMgt->StopAll();
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoBackground" object:nil];
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground=================");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive====================");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //如果是在开启视频的情况下进入后台，重新回到前台的时候应该让视频开启
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"becameActive" object:nil];
    
    
    for (id obj in [[[UIApplication sharedApplication] keyWindow] subviews])
    {
        NSLog(@"class name is %s",object_getClassName(obj));
    }
    
    
    //进入程序的时候图标的信息数量设置为0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate=====================");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}



- (UIViewController*)getLoginNav
{
    
    UIViewController *vc = nil;
    if ([USRDEFAULT integerForKey:@"First_use_flag"] == 0)
    {
        vc = [[RegisterViewController alloc]init];
        
    }
    else
    {
        vc = [[LoginViewController alloc] init];
        
    }
    UINavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [vc release];
    
    return [nav autorelease];;
}

- (UIViewController*)getRootTabbar
{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.hidesBottomBarWhenPushed = YES;
    homeVC.title = @"babywith";
    BaseNavigationController *homeNav = [[[BaseNavigationController alloc] initWithRootViewController:homeVC] autorelease] ;
    
    
    ShareViewController *shareVC = [[ShareViewController alloc] init];
    shareVC.hidesBottomBarWhenPushed = YES;
    shareVC.title = @"分享";
    BaseNavigationController *shareNav = [[[BaseNavigationController alloc] initWithRootViewController:shareVC] autorelease];
    
    RecordsViewController *recordVC = [[RecordsViewController alloc] init];
    recordVC.hidesBottomBarWhenPushed = YES;
    recordVC.title = @"记录";
    BaseNavigationController *recordNav = [[[BaseNavigationController alloc] initWithRootViewController:recordVC] autorelease];
    
    SettingsViewController *settingVC = [[SettingsViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    settingVC.title = @"更多";
    BaseNavigationController *settingNav = [[[BaseNavigationController alloc] initWithRootViewController:settingVC] autorelease];
    
    
    BaseTabBarController *tabbar = [[BaseTabBarController alloc] init];
    tabbar.viewControllers = @[homeNav,shareNav,recordNav,settingNav];
    
    
    [homeVC release];
    [shareVC release];
    [recordVC release];
    [settingVC release];
    

    return [tabbar autorelease];;
}
#pragma mark -
#pragma mark ios push
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.deviceToken =  [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceToken: %@", deviceToken);
}
//对应的，失败就是：
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册推送服务时，发生以下错误： %@",error);
}

//然后，如果接收到推送信息，就是这个了，因为测试有限，我们就在应用程序的图标上面显示一个红色背景的消息数量吧：
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
    if (application.applicationState == UIApplicationStateActive) {
        
        
        AudioServicesPlaySystemSound(1007);
    }
    
    NSLog(@"jieshoudaodexinxi shi  %@",userInfo);
    
    //消息的内容，所有的都一样
    NSString *alert  = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"] ;
    
    [appDelegate.appDefault setObject:alert forKey:@"alert"];
    
    
    
    
    //接收消息的时间
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *messageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    //接收到的消息id,以;隔开的
    NSLog(@"message id is %@",[userInfo objectForKey:@"msgid"]);
    NSArray *msgIdArray = [[userInfo objectForKey:@"msgid"] componentsSeparatedByString:@";"];
    NSLog(@"msgid array is %@",msgIdArray);
    
    //数组里面包括每一条推送消息的id号和对应的时间，因为一次可能发送过来好几条消息，这几条消息的时间是一样的
    NSMutableArray *messageArr = [[NSMutableArray alloc] initWithCapacity:1];
    for (id obj in msgIdArray)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"msgid",@"0",@"messageTime",nil];
    
        [dic setValue:obj forKey:@"msgid"];
        [dic setValue:messageTime forKey:@"messageTime"];
        [messageArr addObject:dic];
        
    }
    
    
    
    NSLog(@"jjjjjjjjjj%d",[self.appDefault integerForKey:@"firstUse"]);
    //主页的消息，只包括消息内容和消息id
    if ([self.appDefault integerForKey:@"firstUse"] == 0)
    {
        [self.appDefault setObject:msgIdArray forKey:@"messageArray"];
        NSLog(@"first messageArray is %@",[self.appDefault objectForKey:@"messageArray"]);
        [self.appDefault setObject:messageArr forKey:@"systemMessageArray"];
        NSLog(@"first systemMessageArray is %@",[self.appDefault objectForKey:@"systemMessageArray"]);
        [self.appDefault setInteger:1 forKey:@"firstUse"];

    }
    else
    {
       
    //更多里面的消息，包括消息内容、消息id、消息收到的时间
    [self.systemMessageArray removeAllObjects];
    [self.systemMessageArray addObjectsFromArray:[self.appDefault objectForKey:@"systemMessageArray"]];
    NSLog(@"self.systemMessageArray is %@,messageArr %@",self.systemMessageArray,messageArr);
    [self.systemMessageArray addObjectsFromArray:messageArr];
    [self.appDefault setObject:self.systemMessageArray forKey:@"systemMessageArray"];
        [self.systemMessageArray removeAllObjects];

        
    
    [self.messageArray removeAllObjects];
    [self.messageArray addObjectsFromArray:[self.appDefault objectForKey:@"messageArray"]];
    NSLog(@"self.messageArray is %@,msgIdArray %@",self.messageArray,msgIdArray);
    [self.messageArray addObjectsFromArray:msgIdArray];
    [self.appDefault setObject:self.messageArray forKey:@"messageArray"];
        [self.messageArray removeAllObjects];

    
    }
    //主页消息图标的改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCount" object:nil];
    //更多里面的图标的改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCount1" object:nil];
    
}
@end
