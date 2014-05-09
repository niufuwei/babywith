//
//  Test.h
//  BabyWith
//
//  Created by wangminhong on 13-6-30.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageProcess : NSObject{
    
    NSConditionLock *_messageLock;
}

- (void)timerAction:(NSTimer*)timer;

@end
