//
//  NSLog.h
//  frame
//
//  Created by Fly on 12-12-25.
//  Copyright (c) 2012年 Fly. All rights reserved.
//

#ifndef frame_ULog_h
#define frame_ULog_h



#ifdef DEBUG
//#define NSLog(format, ...)  NSLog(format, ## __VA_ARGS__)
#define ULog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ... )
#endif



#endif
