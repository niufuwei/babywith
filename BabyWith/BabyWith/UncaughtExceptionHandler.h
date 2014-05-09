//
//  UncaughtExceptionHandler.h
//  BabyWith
//
//  Created by wangminhong on 13-9-3.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject{
    
    BOOL dismissed;
}
@end

void HandleException(NSException *exception);
void SignalHandler(int signal);
    
void InstallUncaughtExceptionHandler(void);


