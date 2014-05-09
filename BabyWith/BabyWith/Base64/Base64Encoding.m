//
//  Base64Encoding.m
//  qukan
//
//  Created by lidong tan on 12-8-31.
//  Copyright (c) 2012年 ReNew. All rights reserved.
//

#import "Base64Encoding.h"
#import "GTMBase64.h"

@implementation Base64Encoding

+ (NSString*)encodeBase64:(NSString*)input 
{ 
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    //转换到base64 
    data = [GTMBase64 encodeData:data]; 
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String; 
}
@end
