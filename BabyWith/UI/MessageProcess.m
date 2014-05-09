//
//  Test.m
//  BabyWith
//
//  Created by wangminhong on 13-6-30.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "MessageProcess.h"
#import "Configuration.h"
#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import "SQLiteManager.h"


@implementation MessageProcess


- (id)init
{
    self = [super init];
    if (self) {
        
        _messageLock = [[NSConditionLock alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)timerAction:(NSTimer*)timer
{
    
    //从服务端取得消息
    NSDictionary *dic = [appDelegate.webInfoManger UserGetMessageUsingToken:[appDelegate.appDefault objectForKey:@"Token"]];
    
    int count = [[dic objectForKey:@"count"] intValue];
    //消息数量
    if (count >0) {
        int newMessageCount = 0;
        
        [_messageLock lock];
        
        NSArray *array = [NSArray arrayWithArray:[dic objectForKey:@"info"]];
        
        for (int i= 0; i< [array count];  i++) {
            
            //消息都是一个一个的dictionary
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[array objectAtIndex:i]];
            NSLog(@"message = [%@]",dic);
            
//            NSDate *create_date = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"create_time"] doubleValue]/1000];
//            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//            [dic setObject:[dateFormatter stringFromDate:create_date] forKey:@"create_time"];
//            [dateFormatter release];
            
            int type = [[dic objectForKey:@"type"] intValue];
            switch (type)
            {
                case 3://添加宝宝信息
                {
                    int operator_type = [[[dic objectForKey:@"value"] objectForKey:@"operate_type"] intValue];
                    if (operator_type == 1)
                    {
                        [dic setObject:[NSString stringWithFormat:@"另一半添加宝宝“%@”。", [[dic objectForKey:@"value"] objectForKey:@"baby_name"]] forKey:@"field_string"];
                    }
                    else if(operator_type == 2)
                    {
                        [dic setObject:[NSString stringWithFormat:@"另一半删除了宝宝“%@”。", [[dic objectForKey:@"value"] objectForKey:@"baby_name"]] forKey:@"field_string"];
                    }
                    else
                    {
                        [dic setObject:[NSString stringWithFormat:@"另一半修改了宝宝“%@”信息。", [[dic objectForKey:@"value"] objectForKey:@"baby_name"]] forKey:@"field_string"];
                    }
                    [dic setObject:@"1" forKey:@"status"];
                    newMessageCount +=1;
                    NSDictionary *newDic = [NSDictionary dictionaryWithObjectsAndKeys:[appDelegate.appDefault objectForKey:@"Member_id_self"],@"id_member",[dic objectForKey:@"create_time"],@"create_time", @"3", @"type",@"baby_name", @"field_name1",[[dic objectForKey:@"value"] objectForKey:@"baby_name"], @"param_1", @"", @"field_name2", @"", @"param_2", @"", @"field_name3", @"", @"param_3", @"operate_type", @"field_name4", [[dic objectForKey:@"value"] objectForKey:@"operate_type"], @"param_4", [dic objectForKey:@"field_string"], @"field_string", nil];
                    //放入到数据库里面
                    [appDelegate.sqliteManager insertMessageInfo:newDic];
                    //永远添加到最前面
                    [appDelegate.messageArray insertObject:newDic atIndex:0];
                    break;
                }
                case 4:  //贵宾账号的信息
                {
                    [dic setObject:[NSString stringWithFormat:@"贵宾账号登录使用中。"] forKey:@"field_string"];
                    [dic setObject:@"1" forKey:@"status"];
                    newMessageCount +=1;
                    NSDictionary *newDic = [NSDictionary dictionaryWithObjectsAndKeys:[appDelegate.appDefault objectForKey:@"Member_id_self"],@"id_member",[dic objectForKey:@"create_time"],@"create_time", @"4", @"type",@"", @"field_name1",@"", @"param_1", @"", @"field_name2", @"", @"param_2", @"", @"field_name3", @"", @"param_3", @"", @"field_name4", @"", @"param_4", [dic objectForKey:@"field_string"], @"field_string", nil];
                    //添加到数据库
                    [appDelegate.sqliteManager insertMessageInfo:newDic];
                    //添加到数组的最前面
                    [appDelegate.messageArray insertObject:newDic atIndex:0];
                    break;
                }
                case 6://添加设备信息
                {
                    int operator_type = [[[dic objectForKey:@"value"] objectForKey:@"operate_type"] intValue];
                    if (operator_type == 1 || operator_type == 3)
                    {
                        [dic setObject:[NSString stringWithFormat:@"对方添加了看护器“%@”。", [[dic objectForKey:@"value"] objectForKey:@"device_id"]] forKey:@"field_string"];
                    }
                    else
                    {
                        [dic setObject:[NSString stringWithFormat:@"对方删除了看护器“%@”。", [[dic objectForKey:@"value"]objectForKey:@"device_id"]] forKey:@"field_string"];
                        
                        //删除看护器时， 正在看该看护器的处理
                        if ([[[appDelegate.appDefault objectForKey:@"Device_selected"] objectForKey:@"device_id"] caseInsensitiveCompare:[[dic objectForKey:@"value"]objectForKey:@"device_id"]] == NSOrderedSame)
                        {
                            [appDelegate.appDefault setObject:nil forKey:@"Device_selected"];
                        }
                    }
                    [dic setObject:@"1" forKey:@"status"];
                   
                    //取得设备信息
                    NSDictionary *newDic = [NSDictionary dictionaryWithObjectsAndKeys:[appDelegate.appDefault objectForKey:@"Member_id_self"],@"id_member",[dic objectForKey:@"create_time"],@"create_time", @"6", @"type",@"device_id", @"field_name1",[[dic objectForKey:@"value"] objectForKey:@"device_id"], @"param_1", @"", @"field_name2", @"", @"param_2", @"", @"field_name3", @"", @"param_3", @"operate_type", @"field_name4", [[dic objectForKey:@"value"] objectForKey:@"operate_type"], @"param_4", [dic objectForKey:@"field_string"], @"field_string", nil];
                    [appDelegate.sqliteManager insertMessageInfo:newDic];
                    
//                    newMessageCount +=1;
//                    [appDelegate.messageArray insertObject:newDic atIndex:0];
                    break;
                }
                case 7://另一方修改信息
                case 8: //别人加入家庭通知消息
                    break;
                default:
                    break;
            }
            [dic release];
        }
        
        [_messageLock unlock];
        
        if (newMessageCount >0)
        {
            //有新消息的时候刷新消息数量
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMessageCount" object:[NSString stringWithFormat:@"%d", newMessageCount]];
        }
        
    }
   
}

@end
