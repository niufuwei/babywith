//
//  DeviceConnectManager.m
//  AiJiaJia
//
//  Created by wangminhong on 13-4-11.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "DeviceConnectManager.h"
#import "MainAppDelegate.h"

@implementation DeviceConnectManager

-(void)initlize{
    DeviceList = [[NSMutableArray alloc] init];
    DeviceCondition = [[NSCondition alloc] init];
}

-(void)connectUID {
    NSLog(@"开启设备管理");
    IsConnect = 1;
    [NSThread detachNewThreadSelector:@selector(connectUIDTask) toTarget:self withObject:nil];
}

-(void)connectUIDTask{
    
    [DeviceCondition lock];
    NSMutableArray *ReturnDeviceLIst = [[[NSMutableArray alloc] init] autorelease];
    for (NSMutableDictionary *copydict in DeviceList) {
        NSMutableDictionary *redict = [copydict mutableCopy];
        [ReturnDeviceLIst addObject:redict];
        [redict release];
    }
    [DeviceCondition unlock];
    
    [appDelegate.appDefault setValue:@"1" forKey:@"initFinish"];
}

-(void)putDeviceInfo:(NSArray *)DeviceInfoList
{
    [DeviceCondition lock];
    
    NSLog(@"DeviceInfo list is %@",DeviceInfoList);
    NSLog(@"deviceList id %@,,,,,,,",DeviceList);

    
    for (NSMutableDictionary *dict in DeviceInfoList)
    {
        
        
        NSLog(@"deviceList id %@,,,,,,,",DeviceList);
        
        NSLog(@"dict is %@",dict);

        
        //寻找相同的设备
        int same = 0;
        for (NSMutableDictionary *saveDict in DeviceList)
        {
            
            
            NSLog(@"dict is %@,saveDict is %@",dict,saveDict);
            
            
            
            if ([[dict objectForKey:@"device_id"] isEqualToString:[saveDict objectForKey:@"device_id"]])
            {
                same = 1;
                break;
            }
        }
        if (same == 0)
        {
            
            [DeviceList addObject:dict];
//            [appDelegate.appDefault setObject:DeviceList forKey:@"DeviceList_"];
//            [appDelegate.appDefault synchronize];
        }
    }
    
//    for (NSMutableDictionary *dict in DeviceInfoList)
//    {
//    
//        
//        int same = 0;
//        if ([DeviceList containsObject:dict])
//        {
//            same = 1;
//            break;
//        }
//    
//        if (same == 0)
//        {
//            [DeviceList addObject:dict];
//        }
//    
//    
//    
//    
//    }
    
    
    
    
    
    
    
    
    
    [DeviceCondition unlock];
}

-(NSMutableArray *)getDeviceInfoList
{
    [DeviceCondition lock];
    NSMutableArray *ReturnDeviceLIst = [[[NSMutableArray alloc] init] autorelease];
    for (NSMutableDictionary *copydict in DeviceList)
    {
        NSMutableDictionary *redict = [copydict mutableCopy];
        [ReturnDeviceLIst addObject:redict];
        [redict release];
    }
    [DeviceCondition unlock];
    return ReturnDeviceLIst;
}

-(NSDictionary *)getDeviceInfo:(NSString *)deviceUID{
    NSDictionary *device = nil;
    if (deviceUID == nil) {
        return nil;
    }
    
    [DeviceCondition lock];
    
    for (NSMutableDictionary *dict in DeviceList) {
        if ([deviceUID isEqualToString:[dict objectForKey:@"device_id"]]) {
            device = [[dict mutableCopy] autorelease];
            break;
        }
    }
    
    [DeviceCondition unlock];
    return device;
    
}

-(void)removeDeviceInfo:(NSString *)deviceUID{
    if (deviceUID == nil) {
        return;
    }
    
    [DeviceCondition lock];
    
    for (NSDictionary *dict in DeviceList) {
        if ([deviceUID isEqualToString:[dict objectForKey:@"device_id"]]) {
            [DeviceList removeObject:dict];
            break;
        }
    }
    
    [DeviceCondition unlock];
}

-(void)updateDeviceAuthorityInfo:(NSString *)deviceUID Authority:(NSString *)authority{
    if (deviceUID == nil) {
        return;
    }
    int i = 0;
    for (NSDictionary *dict in DeviceList) {
        if ([deviceUID isEqualToString:[dict objectForKey:@"device_id"]]) {
            NSMutableDictionary *updateDevice = [NSMutableDictionary dictionaryWithDictionary:dict];
            [updateDevice setObject:authority forKey:@"authority"];
            [DeviceList replaceObjectAtIndex:i withObject:updateDevice];
            break;
        }
        i++;
    }
    
    [DeviceCondition unlock];
}

-(void)renameDevice:(NSString *)deviceUID Name:(NSString *)name{
    if (deviceUID == nil) {
        return;
    }
    
    [DeviceCondition lock];
    
    int i = 0;
    for (NSDictionary *dict in DeviceList) {
        if ([deviceUID isEqualToString:[dict objectForKey:@"device_id"]]) {
            NSMutableDictionary *updateDevice = [NSMutableDictionary dictionaryWithDictionary:dict];
            [updateDevice setObject:name forKey:@"name"];
            [DeviceList replaceObjectAtIndex:i withObject:updateDevice];
            break;
        }
        i++;
    }

    [DeviceCondition unlock];
}

-(void)modifyDeviceAuthSwitch:(NSString *)deviceUID AuthSwitch:(NSString *)authSwitch{
    if (deviceUID == nil) {
        return;
    }
    
    [DeviceCondition lock];
    
    int i = 0;
    for (NSDictionary *dict in DeviceList) {
        if ([deviceUID isEqualToString:[dict objectForKey:@"device_id"]]) {
            NSMutableDictionary *updateDevice = [NSMutableDictionary dictionaryWithDictionary:dict];
            [updateDevice setObject:authSwitch forKey:@"is_open"];
            [DeviceList replaceObjectAtIndex:i withObject:updateDevice];
            break;
        }
        i++;
    }
    
    [DeviceCondition unlock];
}

-(void)modifyDevicePassword:(NSString *)deviceUID Password:(NSString *)password{
    if (deviceUID == nil) {
        return;
    }
    
    [DeviceCondition lock];
    
    int i = 0;
    for (NSDictionary *dict in DeviceList) {
        if ([deviceUID isEqualToString:[dict objectForKey:@"device_id"]]) {
            NSMutableDictionary *updateDevice = [NSMutableDictionary dictionaryWithDictionary:dict];
            [updateDevice setObject:password forKey:@"pass"];
            [DeviceList replaceObjectAtIndex:i withObject:updateDevice];
            break;
        }
        i++;
    }
    
    [DeviceCondition unlock];
}

-(NSMutableDictionary *)getDeviceInfoAtRow:(NSInteger)row{
    NSMutableDictionary *device = nil;
    if (row <0 || row >[DeviceList count] -1) {
        return device;
    }else{
        device = [[[DeviceList objectAtIndex:row] mutableCopy] autorelease];
        return device;
    }
}

-(NSInteger )getDeviceCount{
    return [DeviceList count];
}

-(NSDictionary *)getFirstDeviceInfo{
    
    if ([DeviceList count] == 0) {
        return nil;
    }
    
    NSDictionary *device = nil;
    
    [DeviceCondition lock];
    
    
    device = [[[DeviceList objectAtIndex:0] mutableCopy] autorelease];
    
    [DeviceCondition unlock];
    return device;
}

-(void)removeDeviceList{
    if ([DeviceList count] == 0) {
        return ;
    }
    
    [DeviceCondition lock];
    
    
    [DeviceList removeAllObjects];
    
    [DeviceCondition unlock];
}

@end
