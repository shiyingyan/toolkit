//
//  NSString+SYString.h
//  AnItemForACar
//
//  Created by Shing on 9/8/16.
//  Copyright © 2016 Shing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SYString)

- (NSString *)pinyin;
//拼音首字母
- (NSString *)pinyinFirstCharacterString;

//在某位置添加子串
- (NSString *)addSubString:(NSString *)string atIndex:(NSUInteger)index;

//删除子串
- (NSString *)removeSubString:(NSString *)string;

//是否包含中文
- (BOOL)containChineseASCII;

//两个字符串的字符吻合程度

/**
 self和obj两个字符串的吻合程度

 @return 两个字符串的吻合字符个数和不吻合字符个数。 吻合字符个数在第0位，不吻合字符个数在第1位
 */
- (NSArray *)similar:(NSString *)obj;


/**
 根据拼音首字母获取对应的子串
 
 @param firstChStr 拼音首字母子串
 @return 拼音首字母对应的子串
 */
- (NSString *)substringWithFirstCharacterString:(NSString *)firstChStr;

@end
