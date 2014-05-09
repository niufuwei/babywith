//
//  SQLiteManager.h
//  AiJiaJia
//
//  Created by wangminhong on 13-4-12.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Configuration.h"
#import "MainAppDelegate.h"
#import "sqlite3.h"

@interface SQLiteManager : NSObject{
    sqlite3 *database;
    dispatch_queue_t databaseQueue;
    
}

-(void)createDatabaseIfNeeded:(NSString *)databaseName;

/*插入记录信息*/
-(BOOL)insertRecordInfo:(NSDictionary *)info;



/*记录删除后更新状态，或者删除记录*/
-(BOOL)removeRecordInfo:(NSString *)id_record deleteType:(int)type;

/*获取本地记录中年份对应的记录总数 Year, Count*/
-(void)getLocalListOfYearCount;

/*根据年份获取本地记录中年份对应的记录总数*/
-(void)getLocalListOfMonthCountFromYear:(int)year;

/*根据年份获取本地库表中的记录*/
-(void)getLocalRecordInfoListFromYear:(int)year;


-(void)getLocalListofDayCountFromMonth:(int)month Year:(int)year;


//清除数据库
-(void)removeAllForYear:(int)year;






/*插入消息*/
-(void)insertMessageInfo:(NSDictionary *)info;

/*获取历史消息列表*/
-(NSArray *)getMessageListInfo:(int)id_member;

@end
