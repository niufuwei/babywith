//
//  SQLiteManager.m
//  AiJiaJia
//
//  Created by wangminhong on 13-4-12.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "SQLiteManager.h"

#define kDatabaseQueue @"databaseQueue"
#define kDatabaseName @"babywith.db"
#define kRecordTableName @"TB_Info_Record"
#define kImageTableName @"TB_Info_Record_Image"
#define kMessageTableName @"TB_Info_Message"

@implementation SQLiteManager

-(id)init{
    self = [super init];
    if (self) {
        databaseQueue = dispatch_queue_create([kDatabaseQueue UTF8String], NULL);
        [self createDatabaseIfNeeded:kDatabaseName];
        [self createTableIfNeeded:kRecordTableName];
        [self createTableIfNeeded:kImageTableName];
        [self createTableIfNeeded:kMessageTableName];
        
        //多线程串行设置
        sqlite3_config(SQLITE_CONFIG_SERIALIZED);
    }
    
    return self;
}

-(void)createDatabaseIfNeeded:(NSString *)databaseName{
    //获取数据库路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL searchSuccess = [fileManager fileExistsAtPath:[babywith_sandbox_address stringByAppendingPathComponent:databaseName]];
    
    if (searchSuccess) {
        NSLog(@"Database %@ already exists", databaseName);
    }else{
        
        BOOL pathExist = [fileManager fileExistsAtPath:babywith_sandbox_address];
        if (pathExist) {
            if (![fileManager createFileAtPath:[babywith_sandbox_address stringByAppendingPathComponent:databaseName] contents:nil attributes:nil]) {
                NSLog(@"Create database error");
                return;
            }
        }else{
            NSError *error = nil;
            [fileManager createDirectoryAtPath:babywith_sandbox_address withIntermediateDirectories:YES attributes:nil error:&error];
            if (!error) {
                if (![self addSkipBackupAttributeToFileAtPath:babywith_sandbox_address]) {
                    NSLog(@"Create database error");
                    return;
                }
                if (![fileManager createFileAtPath:[babywith_sandbox_address stringByAppendingPathComponent:databaseName] contents:nil attributes:nil]) {
                    NSLog(@"Create database error");
                    return;
                }
            }else{
                NSLog(@"Create database error");
                return;
            }
        }
        
//        [self createTableIfNeeded:kRecordTableName];
//        [self createTableIfNeeded:kImageTableName];
//        [self createTableIfNeeded:kMessageTableName];
        NSLog(@"createDatabaseIfNeeded successful");
    }
}

- (BOOL)addSkipBackupAttributeToFileAtPath:(NSString *)aFilePath
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:aFilePath]);
    
    NSError *error = nil;
    BOOL success = [[NSURL fileURLWithPath:aFilePath] setResourceValue:[NSNumber numberWithBool:YES]
                                                                forKey:NSURLIsExcludedFromBackupKey
                                                                 error:&error];
    if(!success)
    {
        NSLog(@"Error excluding %@ from backup %@", [aFilePath lastPathComponent], error);
    }
    
    return success;
}

-(void)createTableIfNeeded:(NSString *)tableName{
    
    if([tableName caseInsensitiveCompare:kRecordTableName] == NSOrderedSame){
        dispatch_sync(databaseQueue, ^(void){
            char *errorMsg;
            //打开数据库
            if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
                NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
                return;
            }
            NSString *createSql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(id_record char(30) not null primary key,id_member INTEGER, time_record varchar(13), type_record char(10), year_record char(4), month_record char(2), day_record char(2),is_delete char(1),remark char(20), remark2 varchar(255))", tableName];
            if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!= SQLITE_OK) {
                NSLog(@"Create %@ fail [%s]", tableName, sqlite3_errmsg(database));
            }
            
        });
    }else if([tableName caseInsensitiveCompare:kImageTableName] == NSOrderedSame){
        dispatch_sync(databaseQueue, ^(void){
            char *errorMsg;
            //打开数据库
            if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
                NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
                return;
            }
            NSString *createSql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(id_image char(36), id_record char(30), width_image INTEGER, height_image INTEGER, path varchar(255),is_vedio char(1),record_data_path varchar(255), remark char(20), remark2 varchar(255))", tableName];
            if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!= SQLITE_OK) {
                NSLog(@"Create %@ fail [%s]", tableName, sqlite3_errmsg(database));
            }
            
        });
    }else if([tableName caseInsensitiveCompare:kMessageTableName] == NSOrderedSame){
        dispatch_sync(databaseQueue, ^(void){
            char *errorMsg;
            //打开数据库
            if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
                NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
                return;
            }
            NSString *createSql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(id_message INTEGER PRIMARY KEY AUTOINCREMENT, id_member INTEGER, create_time varchar(25), type INTEGER, field_name1 varchar(100), param_1 varchar(100), field_name2 varchar(100), param_2 varchar(100), field_name3 varchar(100), param_3 varchar(100), field_name4 varchar(100), param_4 varchar(100), field_string varchar(255))", tableName];
            if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!= SQLITE_OK) {
                NSLog(@"Create %@ fail [%s]", tableName, sqlite3_errmsg(database));
            }
            
        });
    }
    
}

-(void)insertMessageInfo:(NSDictionary *)info{
    dispatch_sync(databaseQueue, ^(void){
        char *errorMsg;
        //打开数据库
        if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
            NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
            return ;
        }
        @try {
            NSString *insertMessageSql = [NSString stringWithFormat:@"insert into %@(id_member, create_time, type, field_name1, param_1, field_name2, param_2, field_name3, param_3, field_name4, param_4, field_string) values(%d, '%@', %d, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", kMessageTableName, [[info objectForKey:@"id_member"] intValue], [info objectForKey:@"create_time"], [[info objectForKey:@"type"] intValue], [info objectForKey:@"field_name1"], [info objectForKey:@"param_1"], [info objectForKey:@"field_name2"], [info objectForKey:@"param_2"], [info objectForKey:@"field_name3"], [info objectForKey:@"param_3"], [info objectForKey:@"field_name4"], [info objectForKey:@"param_4"], [info objectForKey:@"field_string"]];
            NSLog(@"insertMessageSql =[%@]", insertMessageSql);
                
                
            if (sqlite3_exec(database, [insertMessageSql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
                NSLog(@"insertMessage error============[%s]", errorMsg);
            }
            
        }@catch (NSException *exception) {
            NSLog(@"failed to sqlite%@",[exception description]);
            sqlite3_free(errorMsg);
        }@finally {
            NSLog(@"try 处理结束 ");
        }
        
        sqlite3_close(database);
    });
}

-(NSArray *)getMessageListInfo:(int)id_member{
    
    __block NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:1];
    dispatch_sync(databaseQueue, ^(void){
        //打开数据库
        if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
            NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
            return;
        }
        
        sqlite3_stmt *statement;
        NSString *searchSql = [NSString stringWithFormat:@"select create_time, type, field_name1, param_1, field_name2, param_2, field_name3, param_3, field_name4, param_4, field_string from %@ where id_member = %d and type in (3,4) order by create_time desc ",kMessageTableName, id_member];
        
        NSLog(@"getMessageListInfo sql = [%@]", searchSql);
        
        if (sqlite3_prepare_v2(database, [searchSql UTF8String], -1, &statement, nil) != SQLITE_OK){
            NSLog(@"Select record info list info fail! info=[%s]", sqlite3_errmsg(database));
            sqlite3_close(database);
            return;
        }
        
//        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:1];
        NSArray *nameArray = [NSArray arrayWithObjects:@"create_time",@"type", @"field_name1", @"param_1", @"field_name2", @"param_2", @"field_name3", @"param_3", @"field_name4", @"param_4", @"field_string",nil];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            @try {
                char *create_time = (char *)sqlite3_column_text(statement, 0);
                int type = sqlite3_column_int(statement, 1);
                char *field_name1 = (char *)sqlite3_column_text(statement, 2);
                char *param_1 = (char *)sqlite3_column_text(statement, 3);
                char *field_name2 = (char *)sqlite3_column_text(statement, 4);
                char *param_2 = (char *)sqlite3_column_text(statement, 5);
                char *field_name3 = (char *)sqlite3_column_text(statement, 6);
                char *param_3 = (char *)sqlite3_column_text(statement, 7);
                char *field_name4 = (char *)sqlite3_column_text(statement, 8);
                char *param_4 = (char *)sqlite3_column_text(statement, 9);
                char *field_string = (char *)sqlite3_column_text(statement, 10);
                
                NSArray *contentArray = [NSArray arrayWithObjects:[NSString stringWithUTF8String:create_time], [NSString stringWithFormat:@"%d",type],[NSString stringWithUTF8String:field_name1],[NSString stringWithUTF8String:param_1],[NSString stringWithUTF8String:field_name2],[NSString stringWithUTF8String:param_2],[NSString stringWithUTF8String:field_name3],[NSString stringWithUTF8String:param_3],[NSString stringWithUTF8String:field_name4],[NSString stringWithUTF8String:param_4],[NSString stringWithUTF8String:field_string],nil];
                
                NSDictionary *temp = [NSDictionary dictionaryWithObjects:contentArray forKeys:nameArray];
                [mutableArray addObject:temp];
            }
            @catch (NSException *exception) {
                NSLog(@"Database error=[%@]", exception);
                [mutableArray release];
                mutableArray = nil;
                break;
            }
            @finally {
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
        NSLog(@"getMessageListInfo success");
    });
    
    if (mutableArray == nil) {
        return nil;
    }else{
        NSArray *resultArray = [NSArray arrayWithArray:mutableArray];
        [mutableArray release];
        NSLog(@"get message info list = [%@]", resultArray);
        return resultArray;
    }
}


//插入记录数据
-(BOOL)insertRecordInfo:(NSDictionary *)info{
    
    __block BOOL returnInt = FALSE;
    dispatch_sync(databaseQueue, ^(void){
        char *errorMsg;
        //打开数据库
        if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
            NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
            returnInt = FALSE;
            return ;
        }
        @try {
            if(sqlite3_exec(database, "BEGIN;", NULL, NULL, &errorMsg) == SQLITE_OK){
                NSLog(@"事务启动成功");
                sqlite3_free(errorMsg);
                NSLog(@"insertRecordDic=[%@]", info);
                
                NSString *insertRecordSql = [NSString stringWithFormat:@"insert into %@(id_record,id_member,time_record,type_record,year_record,month_record,day_record,is_delete) values('%@', %d, '%@', '2','%@','%@', '%@', 0)",kRecordTableName, [info objectForKey:@"id_record"],[[info objectForKey:@"id_member"] intValue],[info objectForKey:@"time_record"],[info objectForKey:@"year_record"],[info objectForKey:@"month_record"],[info objectForKey:@"day_record"]];
                NSLog(@"insertRecordSql =[%@]", insertRecordSql);
                
                
                if (sqlite3_exec(database, [insertRecordSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
                    NSString *insertImageSql=[NSString stringWithFormat:@"insert into %@(id_record,width_image,height_image,path,is_vedio,record_data_path) values('%@','%d','%d','%@','%d','%@')", kImageTableName, [info objectForKey:@"id_record"],[[info objectForKey:@"width_image"] intValue],[[info objectForKey:@"height_image"] intValue],[info objectForKey:@"path"],[[info objectForKey:@"is_vedio"] intValue],[info objectForKey:@"record_data_path"]];
                    
                    NSLog(@"insertImageSql =[%@]", insertImageSql);
                    
                    if(sqlite3_exec(database, [insertImageSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK)
                    {
                        NSLog(@"插入数据成功");
                        if(sqlite3_exec(database, "COMMIT", NULL, NULL, &errorMsg) == SQLITE_OK)
                        {
                            NSLog(@"事务提交成功");
                            returnInt = TRUE;
                        }else{
                            NSLog(@"error1========%s",errorMsg);
                            sqlite3_exec(database, "ROLLBACK", NULL, NULL, &errorMsg);
                            sqlite3_close(database);
                            returnInt = FALSE;
                            return;
                        }
                        
                    }else{
                        NSLog(@"error2========%s",errorMsg);
                        sqlite3_exec(database, "ROLLBACK", NULL, NULL, &errorMsg);
                        sqlite3_close(database);
                        returnInt = FALSE;
                        return;
                    }
                }else{
                    NSLog(@"error3========%s",errorMsg);
                    sqlite3_exec(database, "ROLLBACK", NULL, NULL, &errorMsg);
                    sqlite3_close(database);
                    returnInt = FALSE;
                    return;
                }
            }else{
                NSLog(@"error4========%s",errorMsg);
                sqlite3_exec(database, "ROLLBACK", NULL, NULL, &errorMsg);
                sqlite3_close(database);
                returnInt = FALSE;
                return;
            }
            
            sqlite3_free(errorMsg);

        }@catch (NSException *exception) {
            NSLog(@"事务抛出异常 回滚");
            if (sqlite3_exec(database, "ROLLBACK", NULL, NULL, &errorMsg)== SQLITE_OK) {
                NSLog(@"回滚事务成功");
            }
            sqlite3_free(errorMsg);
            sqlite3_close(database);
            NSLog(@"failed to sqlite%@",[exception description]);
            returnInt = FALSE;
        }@finally {
            NSLog(@"try 处理结束 ");
            sqlite3_close(database);
        }
    });
    return returnInt;
}

-(NSString *)dataFilePath:(NSString *)databaseName {
    
    NSString *databaseFilePath  = babywith_sandbox_address;
    return [databaseFilePath stringByAppendingPathComponent:databaseName];
}

-(void)getLocalRecordInfoListFromYear:(int)year
{
    dispatch_sync(databaseQueue, ^(void){
        //打开数据库
        if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
            NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
            return;
        }
        
        sqlite3_stmt *statement;
        NSString *searchSql = [NSString stringWithFormat:@"select a.id_record,a.time_record,a.year_record,a.month_record,a.day_record,b.width_image,b.height_image,b.path,a.id_member,b.is_vedio,b.record_data_path from %@ a, %@ b where a.id_record = b.id_record and a.is_delete ='0' ",kRecordTableName, kImageTableName];
        if (year != -1) {
            searchSql = [NSString stringWithFormat:@"%@ and a.year_record = '%@'", searchSql,[NSString stringWithFormat:@"%d",year]];
            
        }
        
        searchSql = [NSString stringWithFormat:@"%@ order by a.time_record desc", searchSql];
        
        NSLog(@"getLocalRecordInfoList sql = [%@]", searchSql);
        
        if (sqlite3_prepare_v2(database, [searchSql UTF8String], -1, &statement, nil) != SQLITE_OK)
        {
            NSLog(@"Select record info list info fail! info=[%s]", sqlite3_errmsg(database));
            sqlite3_close(database);
            return;
        }
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:1];
        NSArray *nameArray = [NSArray arrayWithObjects:@"id_record",@"time_record",@"year_record",@"month_record",@"day_record",@"width_image",@"height_image",@"path",@"id_member",@"is_vedio",@"record_data_path",nil];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            @try {
                char *id_record = (char *)sqlite3_column_text(statement, 0);
                char *time_record = (char *)sqlite3_column_text(statement, 1);
                char *year_record = (char *)sqlite3_column_text(statement, 2);
                char *month_record = (char *)sqlite3_column_text(statement, 3);
                char *day_record = (char *)sqlite3_column_text(statement, 4);
                int width_image = sqlite3_column_int(statement, 5);
                int height_image = sqlite3_column_int(statement, 6);
                char *path_image = (char *)sqlite3_column_text(statement, 7);
                int id_member = sqlite3_column_int(statement, 8);
                int is_vedio = sqlite3_column_int(statement, 9);
                char *path_vedio = (char *)sqlite3_column_text(statement, 10);



                NSArray *contentArray = [NSArray arrayWithObjects:[NSString stringWithUTF8String:id_record], [NSString stringWithUTF8String:time_record],[NSString stringWithUTF8String:year_record],[NSString stringWithUTF8String:month_record],[NSString stringWithUTF8String:day_record],[NSString stringWithFormat:@"%d",width_image],[NSString stringWithFormat:@"%d",height_image],[NSString stringWithUTF8String:path_image],[NSString stringWithFormat:@"%d", id_member],[NSString stringWithFormat:@"%d",is_vedio],[NSString stringWithUTF8String:path_vedio],nil];
                
                NSDictionary *temp = [NSDictionary dictionaryWithObjects:contentArray forKeys:nameArray];
                [mutableArray addObject:temp];
                

            }
            @catch (NSException *exception) {
                NSLog(@"Database error=[%@]", exception);
                [mutableArray release];
                mutableArray = nil;
                break;
            }
            @finally {
                //TODO:
//                [appDelegate.recordLocalYearMonthListDic setObject:mutableArray forKey:[NSString stringWithFormat:@"%d", year]];
//                NSLog(@"appDelegate.recordLocalYearMonthListDic= [%@]",appDelegate.recordLocalYearMonthListDic);
            }
        }
        if (mutableArray != nil)
        {
            //直接赋值给了appDelegate.recordLocalYearMonthListDic，所以在此处没有返回值
            [appDelegate.recordLocalYearMonthListDic setObject:mutableArray forKey:[NSString stringWithFormat:@"%d", year]];
            
            [mutableArray release];
            mutableArray = nil;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
        NSLog(@"getLocalRecordInfoListFromYear success");
    });
}




-(void)getLocalListOfYearCount{
    
    dispatch_sync(databaseQueue, ^(void){
        //打开数据库
        if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
            NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
            return;
        }
        
        
//        NSString *searchSql = [NSString stringWithFormat:@"select year_record, count from (select year_record, count(year_record) as count from %@ where ",kRecordTableName];
//        if ([[appDelegate.appDefault objectForKey:@"Family_id"] integerValue] == -1) {
//            searchSql = [NSString stringWithFormat:@"%@ id_member = %d and is_delete != '1' group by year_record) order by year_record asc",searchSql, [[appDelegate.appDefault objectForKey:@"Member_id_self"] integerValue]];
//        }else{
//            searchSql = [NSString stringWithFormat:@"%@ id_family = %d and is_delete != '1' group by year_record) order by year_record asc",searchSql, [[appDelegate.appDefault objectForKey:@"Family_id"] integerValue]];
//        }
        
        NSString *searchSql = [NSString stringWithFormat:@"select year_record, count from (select year_record, count(year_record) as count from %@ where id_member = %d group by year_record) order by year_record asc", kRecordTableName, [[appDelegate.appDefault objectForKey:@"Member_id_self"] integerValue]];
        NSLog(@"getLocalListOfYearCount = %@", searchSql);
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [searchSql UTF8String], -1, &statement, nil) != SQLITE_OK){
            NSLog(@"getLocalListOfYearCount info fail! info=[%s]", sqlite3_errmsg(database));
            sqlite3_close(database);
            return;
        }
        while (sqlite3_step(statement) == SQLITE_ROW) {
            @try {
                int year = sqlite3_column_int(statement, 0);
                int count = sqlite3_column_int(statement, 1);
                if (count != 0) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", year], @"Year",[NSString stringWithFormat:@"%d", count], @"Count",  nil];
                    [appDelegate.recordLocalYearCountArray addObject:dic];
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"Database error");
            }
        }
        
        NSLog(@"recordLocalYearCountArray = %@", appDelegate.recordLocalYearCountArray);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return;
    });
    
}

-(void)getLocalListOfMonthCountFromYear:(int)year{
    
    dispatch_sync(databaseQueue, ^(void)
    {
        //打开数据库
        if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
            NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
            return;
        }
        
        NSString *searchSql = [NSString stringWithFormat:@"select month_record, count from (select month_record, count(month_record) as count from %@ where id_member = %d and year_record = %d and is_delete = '0' group by month_record) order by month_record desc", kRecordTableName, [[appDelegate.appDefault objectForKey:@"Member_id_self"] integerValue], year];
        
        NSLog(@"getLocalListOfMonthCountFromYear sql= %@", searchSql);
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [searchSql UTF8String], -1, &statement, nil) != SQLITE_OK)
        {
            NSLog(@"getLocalListOfYearCount info fail! info=[%s]", sqlite3_errmsg(database));
            sqlite3_close(database);
            return;
        }
        
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"12",@"0",@"11",@"0",@"10",@"0",@"9",@"0",@"8",@"0",@"7",@"0",@"6",@"0",@"5",@"0",@"4",@"0",@"3",@"0",@"2",@"0",@"1", nil];
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            @try {
                int month = sqlite3_column_int(statement, 0);
                int count = sqlite3_column_int(statement, 1);
                if (count != 0) {
                    [mutableDic setObject:[NSString stringWithFormat:@"%d", count] forKey:[NSString stringWithFormat:@"%d", month]];
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"Database error");
            }
        }
        [appDelegate.recordLocalMonthCountDic setObject:mutableDic forKey:[NSString stringWithFormat:@"%d", year]];
        NSLog(@"getLocalListOfMonthCountFromYear = %@", appDelegate.recordLocalMonthCountDic);
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return;
    });
    
}
//获取某年某月的天数
-(int)getDaysFromMonth:(int)month Year:(int)year
{
    int i = 0;
    switch (month) {
        case 12:
            i= 31;
            break;
        case 11:
            i= 30;
            break;
        case 10:
            i= 31;
            break;
        case 9:
            i= 30;
            break;
        case 8:
            i= 31;
            break;
        case 7:
            i= 31;
            break;
        case 6:
            i= 30;
            break;
        case 5:
            i= 31;
            break;
        case 4:
            i= 30;
            break;
        case 3:
            i= 31;
            break;
        case 2:
        {
            if ((year % 400 == 0)||((year % 4 == 0)&&(year % 100 !=0))) {
                i= 29;
            }
            else
            {
                
                i= 28;
                
            }
            
            
        }
            break;
        case 1:
            i= 31;
            break;
        default:
            break;
    }
    
    return i;
    
    
    
}
//根据年份和月份获取某一个月的每一天的记录数
-(void)getLocalListofDayCountFromMonth:(int)month Year:(int)year
{

   
    dispatch_sync(databaseQueue, ^(void){
        //打开数据库
        if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK)
        {
            NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
            return;
        }
        
        
        NSString *seach1= [NSString stringWithFormat:@"select day_record, c from (select day_record,count(day_record) as c from %@ where id_member = %d and is_delete = '0' and year_record = %d and month_record = %d group by day_record) order by day_record desc", kRecordTableName, [[appDelegate.appDefault objectForKey:@"Member_id_self"] integerValue], year,month];
        
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [seach1 UTF8String], -1, &statement, nil) != SQLITE_OK)
        {
            sqlite3_close(database);
            return;
        }
        
        
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
        for (int days = [self getDaysFromMonth:month Year:year]; days>0; days--)
        {
            [mutableDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",days]];
        }
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            @try
            {
                int day = sqlite3_column_int(statement, 0);
                int count = sqlite3_column_int(statement, 1);
                if (count != 0)
                {
                    [mutableDic setObject:[NSString stringWithFormat:@"%d", count] forKey:[NSString stringWithFormat:@"%d", day]];
                }

            }
            @catch (NSException *exception)
            {
                NSLog(@"Database error");
            }
        }
        [appDelegate.recordLocalDayCountDic setObject:mutableDic forKey:[NSString stringWithFormat:@"%d", month]];


        sqlite3_finalize(statement);
        sqlite3_close(database);
        return;
    });


}


-(BOOL)removeRecordInfo:(NSString *)id_record deleteType:(int)type
{
    __block BOOL result;
    dispatch_sync(databaseQueue, ^(void){
        char *errorMsg;
        //打开数据库
        if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
            NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
            result = NO;
            return;
        }
        //更新记录状态为删除
        if (type == 0)
        {
            @try {
                if(sqlite3_exec(database, "BEGIN;", NULL, NULL, &errorMsg) == SQLITE_OK)
                {
                    NSLog(@"事务启动成功");
                    sqlite3_free(errorMsg);
                    NSString *updateSql = [NSString stringWithFormat:@"update %@ set is_delete = '1' where id_record = '%@'", kRecordTableName, id_record];
                    
                    if (sqlite3_exec(database, [updateSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK)
                    {
                        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where id_record = '%@'", kImageTableName, id_record];
                        
                        if (sqlite3_exec(database, [deleteSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK)
                        {
                            if(sqlite3_exec(database, "COMMIT", NULL, NULL, &errorMsg) == SQLITE_OK)
                            {
                                NSLog(@"事务提交成功");
                            }
                            else
                            {
                                NSLog(@"error1========%s",errorMsg);
                                sqlite3_exec(database, "ROLLBACK", NULL, NULL, &errorMsg);
                                result = NO;
                                return;
                            }
                        }
                        else
                        {
                            NSLog(@"error2========%s",errorMsg);
                            sqlite3_exec(database, "ROLLBACK", NULL, NULL, &errorMsg);
                            result = NO;
                            return;
                        }
                    }
                    else
                    {
                        NSLog(@"error3========%s",errorMsg);
                        sqlite3_exec(database, "ROLLBACK", NULL, NULL, &errorMsg);
                        result = NO;
                        return;
                    }
                }
                else
                {
                    NSLog(@"error4========%s",errorMsg);
                    result = NO;
                    return;
                }
            }
            @catch (NSException *exception)
            {
                NSLog(@"事务抛出异常 回滚");
                if (sqlite3_exec(database, "ROLLBACK", NULL, NULL, &errorMsg)== SQLITE_OK)
                {
                    NSLog(@"回滚事务成功");
                }
                sqlite3_free(errorMsg);
                NSLog(@"failed to sqlite%@",[exception description]);
                result = NO;
            }
            @finally
            {
                NSLog(@"try 处理结束 ");
                result = YES;
            }
            
            
        }
        else
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where id_record = '%@'", kRecordTableName, id_record];
            if (sqlite3_exec(database, [deleteSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK)
            {
                NSLog(@"记录删除成功");
                result = YES;
                return;
            }
            else
            {
                result = NO;
                return;
            }
        }
    });
    
    return result;
}
-(void)removeAllForYear:(int)year
{
    __block BOOL result;
    dispatch_sync(databaseQueue, ^(void){
        char *errorMsg;
        //打开数据库
        if(sqlite3_open([[self dataFilePath:kDatabaseName] UTF8String], &database) != SQLITE_OK){
            NSLog(@"Open database fail[%s]", sqlite3_errmsg(database));
            result = NO;
            return;
        }

        NSString *seach1= [NSString stringWithFormat:@"delete from %@ where year_record =%d", kRecordTableName,year];
        
        
        
        if (sqlite3_exec(database, [seach1 UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK)
        {
            NSLog(@"记录删除成功");
            result = YES;
            return;
        }

    });
}

@end


