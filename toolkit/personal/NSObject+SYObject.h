//
//  NSObject+SYObject.h
//  AnItemForACar
//
//  Created by Shing on 6/30/16.
//  Copyright © 2016 Shing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYObjectProtocol.h"

/**
 *  @author Shing, 16-09-28 12:09:49
 *
 *  @note (注意使用此扩展时，属性变量类型必须是NSObject对象或其子对象)
 */


@interface NSObject (SYObject)<SYObjectProtocol>

/**
 *  @author Shing, 16-06-30 16:06:41
 *
 *  @brief 对象描述信息,程序调试使用.
 *
 */
-(NSString *)syDescription;

/**
 *  @author Shing, 16-06-30 15:06:55
 *
 *  @brief 获取当前类的所有属性
 */
-(NSArray *)allProperties;


/**
 *  @author Shingzcddff, 16-07-03 20:07:42
 *
 *  @brief 根据字典dic，设置对象相对应的属性值.
 *
 *  @param dic 给定的属性字典
 */
-(void)setAttributes:(NSDictionary *)dic;

@end
