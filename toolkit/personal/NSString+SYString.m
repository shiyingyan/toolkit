//
//  NSString+SYString.m
//  AnItemForACar
//
//  Created by Shing on 9/8/16.
//  Copyright © 2016 Shing. All rights reserved.
//

#import "NSString+SYString.h"

@implementation NSString (SYString)

- (NSString *)pinyin {
    if( self.length == 0 ) return @"";
    NSString *tmp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    tmp = [tmp stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSMutableString *result = [tmp mutableCopy];
    // 转为带声调的拼音
    CFStringTransform((__bridge CFMutableStringRef)result, nil, kCFStringTransformToLatin, NO);
    // 再转换为不带声调的拼音
    CFStringTransform((__bridge CFMutableStringRef)result, nil, kCFStringTransformStripDiacritics, NO);

    return result;
}
- (NSString *)pinyinFirstCharacterString {
    NSMutableString *pinyinFirstCharacters = [NSMutableString string];
    
    NSMutableString *tmp = [[self pinyin] mutableCopy];
    NSArray *words = [tmp componentsSeparatedByString:@" "];
    for (NSString *word in words) {
        [pinyinFirstCharacters appendString:[word substringToIndex:1]];
    }
    return pinyinFirstCharacters.lowercaseString;
}

- (NSString *)addSubString:(NSString *)string atIndex:(NSUInteger)index
{
    if( index >= self.length ) return [self stringByAppendingString:string];
    
    //index前半部分
    NSString *foreStr = [self substringToIndex:index];
    //index后半部分
    NSString *backStr = [self substringFromIndex:index];
    
    return [[foreStr stringByAppendingString:string] stringByAppendingString:backStr];
}

- (NSString *)removeSubString:(NSString *)string {
    if( [self containsString:string] ){
        return [self stringByReplacingOccurrencesOfString:string withString:@""];
    }
    return self;
}

- (BOOL)containChineseASCII {
    for (int i=0; i<self.length; i++) {
        int a = [self characterAtIndex:i];
        if ( a < 0x9fff && a > 0x4e00 ) return YES;
    }
    return NO;
}

- (NSArray *)similar:(NSString *)obj {
    __block int sum_sim_ch = 0;     //吻合的字符个数
    __block int sum_notSim_ch = 0;  //不吻合的字符个数
    
    __weak typeof(obj)weakobj = obj;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                            options:NSStringEnumerationByComposedCharacterSequences
                         usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop)
     {
         if( [weakobj rangeOfString:substring].location == NSNotFound ) {
             sum_notSim_ch++;
         }else{
             sum_sim_ch++;
         }
     }];
    
    return @[[NSNumber numberWithInt:sum_sim_ch],[NSNumber numberWithInt:sum_notSim_ch]];
}

- (NSString *)substringWithFirstCharacterString:(NSString *)firstChStr {
    NSString *pinyinFirstChs = [self pinyinFirstCharacterString];
    NSRange range = [pinyinFirstChs rangeOfString:firstChStr];
    if( range.length == 0 ) return @"";
    return [self substringWithRange:range];
}

@end
