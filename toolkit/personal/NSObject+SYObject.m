//
//  NSObject+SYObject.m
//  AnItemForACar
//
//  Created by Shing on 6/30/16.
//  Copyright © 2016 Shing. All rights reserved.
//

#import "NSObject+SYObject.h"
#import <objc/runtime.h>

@implementation NSObject (SYObject)

-(NSString *)syDescription{
    NSString *description = @"";
    for (NSString *str in [self allProperties]) {
        SEL selector = NSSelectorFromString(str);
        
        if( [self respondsToSelector:selector] ){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            description = [description stringByAppendingFormat:@"%@=%@\n",str,[self performSelector:selector withObject:nil]];
#pragma clang diagnostic pop
        }
        
    }
    return description;
}


-(NSArray *)allProperties{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertyArr = nil;
    if( count ){
        propertyArr = [NSMutableArray array];
        
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            const char *cName = property_getName(property);
            NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            [propertyArr addObject:name];
        }
        
        free(properties);
        
        return propertyArr.copy;
    }
    return nil;
}


-(void)setAttributes:(NSDictionary *)dic{
    for (NSString *key in dic) {
        if( [dic[key] isKindOfClass:[NSNull class]] ) {
            [self setValue:@"" forKey:key];
        }else{
            [self setValue:dic[key] forKey:key];
        }
    }
}

@end
