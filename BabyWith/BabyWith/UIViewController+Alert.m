//
//  UIViewController+Alert.m
//  BabyWith
//
//  Created by wangminhong on 13-6-27.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "UIViewController+Alert.h"
#import "Configuration.h"
#import "MainAppDelegate.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation UIViewController (Alert)

-(void)ShowPrePage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeAlert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void)makeAlertForHandle:(NSArray *)array Tag:(int)tag Delegate:(NSString *)delegate{
    if ([array count] == 1) {
        
    }else if([array count] == 2){
        
    }else if([array count] == 3){
        
    }
}

-(void)makeAlertForServerUseTitle:(NSString *)title Code:(NSString *)code{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    NSLog(@"code = [%@]", code);
    
    if ([[code uppercaseString] isEqualToString:@"TOKEN_INVALID"]) {
        alert.message = @"您的账号在别处登录，请注销后重新登录";
    }else if ([[code uppercaseString] isEqualToString:@"OATHER_ERROR"]) {
        alert.message = @"服务器开小差了~~";
    }
    
    [alert show];
    [alert release];
}


- (BOOL)checkTel:(NSString *)tel Type:(int) type
{
    
    if ([tel length] == 0)
    {
        [self makeAlert:@"手机号不可为空"];
        return NO;
    }
    
    
    NSString *regex;
    
    if (type == 1)
    {
        regex = [NSString stringWithFormat:@"%@", @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,2,3,5-9]))\\d{8}[xX]{0,1}$"];
    }
    else
    {
        //亲友账号 手机号+X
        regex = [NSString stringWithFormat:@"%@", @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"];
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:tel];
    
    if (!isMatch)
    {
        [self makeAlert:@"请输入正确的手机号码"];
        return NO;
    }
    
    return YES;
}

-(int)judgeTelAndEmail:(NSString *)string Type:(int)type{
    if ([string length] == 0) {
        return -1;
    }
    
    if (type == 1) { //判断是否是贵宾账号
        if([string hasPrefix:@"vipp"]){
            return 3;
        }else if([string hasPrefix:@"vipe"]){
            return 4;
        }
    }
    
    NSString *regex = [NSString stringWithFormat:@"%@", @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:string];
    
    if (isMatch) {
        return 1;
    }
    else {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        BOOL isMatch = [emailPred evaluateWithObject:string];
        if (!isMatch) {
            return -1;
        }else{
            return 2;
        }
    }
}

-(int)checkTelAndEmail:(NSString *)string Type:(int)type{
    if ([string length] == 0) {
        [self makeAlert:@"账号不可为空"];
        return -1;
    }
    
    if (type == 1) { //判断是否是贵宾账号
        
        if([string hasPrefix:@"vip"]){
            return 3;
        }else{
            [self makeAlert:@"请输入正确的亲友账号"];
            return -1;
        }
    }
    
    NSString *regex = [NSString stringWithFormat:@"%@", @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:string];
    
    if (isMatch) {
        return 1;
    }
    else {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        BOOL isMatch = [emailPred evaluateWithObject:string];
        if (!isMatch) {
            [self makeAlert:@"请输入正确的手机号或邮箱"];
            return -1;
        }else{
            return 2;
        }
    }
}

-(BOOL)checkEmail:(NSString *)email{
    
    if ([email length] == 0) {
        [self makeAlert:@"邮箱号不可为空"];
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL isMatch = [emailTest evaluateWithObject:email];
    if (!isMatch) {
        [self makeAlert:@"请输入正确的邮箱号码"];
        return NO;
    }
    return YES;
}

-(NSString *)GetNowTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString*locationString=[formatter stringFromDate: [NSDate date]];
    [formatter release];
    return locationString;
}

-(NSString *)getLocalMacAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return NULL;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return NULL;
    }
    if ((buf = (char *)malloc(len)) == NULL) {
        return NULL;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return NULL;
    }
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

//获取随机数
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + arc4random() %(to - from + 1));
}

//获取星座
-(NSString *)getAstroWithMonth:(NSInteger)month day:(NSInteger)day{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    result=[NSString stringWithFormat:@"%@座",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue]-(-19))*2,2)]];
    return result;
}

@end
