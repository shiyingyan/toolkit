//
//  SYObject.h
//  AnItemForACar
//
//  Created by Shing Yan on 11/16/16.
//  Copyright © 2016 Shing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SYObjectProtocol <NSObject>

@optional

/**
 所有对象的初始化操作，需要自己手动调用此方法；
 可以不实现
 */
- (void)initialization;

@end
