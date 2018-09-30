//
//  NSObject+MJDescription.m
//  MJDamageAssessmentKit
//
//  Created by ShawLin on 14/12/2017.
//  Copyright © 2017 Data Enlighten. All rights reserved.
//

#import "NSObject+MJDescription.h"
#import <objc/runtime.h>

static inline void zxp_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



@implementation NSObject (MJDescription)


- (NSString *)mydescription{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //得到当前class的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    //循环并用KVC得到每个属性的值
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil";//默认值为nil字符串
        [dictionary setObject:value forKey:name];//装载到字典里
    }
    
    //释放
    free(properties);
    
    //return
    return [NSString stringWithFormat:@"<%@: %p> -- %@/n",[self class],self,dictionary];
}
@end

@implementation NSString (MJDescription)

- (NSString *)stringByReplaceUnicode {
    NSMutableString *convertedString = [self mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U"
                                     withString:@"\\u"
                                        options:0
                                          range:NSMakeRange(0, convertedString.length)];
    
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    return convertedString;
}

@end

@implementation NSArray (MJDescription)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        zxp_swizzleSelector(class, @selector(description), @selector(zxp_description));
        zxp_swizzleSelector(class, @selector(descriptionWithLocale:), @selector(zxp_descriptionWithLocale:));
        zxp_swizzleSelector(class, @selector(descriptionWithLocale:indent:), @selector(zxp_descriptionWithLocale:indent:));
    });
}

/**
 *  我觉得
 *  可以把以下的方法放到一个NSObject的category中
 *  然后在需要的类中进行swizzle
 *  但是又觉得这样太粗暴了。。。。
 */

- (NSString *)zxp_description {
    return [[self zxp_description] stringByReplaceUnicode];
}

- (NSString *)zxp_descriptionWithLocale:(nullable id)locale {
    return [[self zxp_descriptionWithLocale:locale] stringByReplaceUnicode];
}

- (NSString *)zxp_descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [[self zxp_descriptionWithLocale:locale indent:level] stringByReplaceUnicode];
}

@end

@implementation NSDictionary (MJDescription)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        zxp_swizzleSelector(class, @selector(description), @selector(zxp_description));
        zxp_swizzleSelector(class, @selector(descriptionWithLocale:), @selector(zxp_descriptionWithLocale:));
        zxp_swizzleSelector(class, @selector(descriptionWithLocale:indent:), @selector(zxp_descriptionWithLocale:indent:));
    });
}

- (NSString *)zxp_description {
    return [[self zxp_description] stringByReplaceUnicode];
}

- (NSString *)zxp_descriptionWithLocale:(nullable id)locale {
    return [[self zxp_descriptionWithLocale:locale] stringByReplaceUnicode];
}

- (NSString *)zxp_descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [[self zxp_descriptionWithLocale:locale indent:level] stringByReplaceUnicode];
}

@end

@implementation NSSet (MJDescription)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        zxp_swizzleSelector(class, @selector(description), @selector(zxp_description));
        zxp_swizzleSelector(class, @selector(descriptionWithLocale:), @selector(zxp_descriptionWithLocale:));
        zxp_swizzleSelector(class, @selector(descriptionWithLocale:indent:), @selector(zxp_descriptionWithLocale:indent:));
    });
}

- (NSString *)zxp_description {
    return [[self zxp_description] stringByReplaceUnicode];
}

- (NSString *)zxp_descriptionWithLocale:(nullable id)locale {
    return [[self zxp_descriptionWithLocale:locale] stringByReplaceUnicode];
}

- (NSString *)zxp_descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [[self zxp_descriptionWithLocale:locale indent:level] stringByReplaceUnicode];
}


@end
