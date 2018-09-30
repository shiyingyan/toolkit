//
//  SYDeviceTest.h
//  YTImageBrowser
//
//  Created by Shing on 15/8/8.
//  Copyright (c) 2015年 Shing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYDeviceTest : NSObject

/**判断相册是否被允许访问 返回YES为允许访问*/
+ (BOOL)userAuthorizationStatus;

@end
