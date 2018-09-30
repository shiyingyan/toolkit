//
//  SYTool.h
//  MJDamageAssessment
//
//  Created by Shing on 10/04/2017.
//  Copyright © 2017 Data Enlighten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYTool : NSObject

//正则表达式
+(BOOL)isValidateChinese:(NSString *)string;
+(BOOL)isValidateFamilyName:(NSString *)familyName;
+(BOOL)isValidateName:(NSString *)name;
+(BOOL)isValidateNickname:(NSString *)nickname;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)isValidatePhone:(NSString *)phone;
+(BOOL)isValidatePassword:(NSString *)pwd;  //验证密码是否是6至16为数组或字母大小写组合
+(BOOL)isValidateInteger:(NSString *)string;
+(BOOL)isValidateVehicleNumber:(NSString *)vehicleNumber;  //验证车牌号是否合法

//当字符串为NSNull或不是字符串时，返回“”，保证字符串操作安全
+ (NSString *)safeString:(NSString *)string;
+ (BOOL)isSafeString:(NSString *)string;

//根据设置文本标签的文本属性，返回文本标签的大小，返回类型为CGSize
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size;

+ (BOOL)isIphone4s;
+ (BOOL)isIphone5;
+ (BOOL)isIphone6;
+ (BOOL)isIphone6p;
+ (BOOL)isMoreThanIphone5s;
+ (BOOL)isMoreThanIphone6;

//获取当前识图控制器
+ (UIViewController *)getCurrentVC;

+ (CGFloat)keyboardHeight;

//预留功能说明
+(void)showFunctionInstruction;

//26个英文字母数组
+(NSArray *)allCharacters;

/**
 *  格式化数字，例如number=5,则返回“05”，number=37,则返回“37”
 *
 *  @param number 要格式化的数字
 *
 *  @return 格式化的结果
 */
+(NSString *)formatInterger:(NSInteger)number;
+(NSString *)jsonStringFromDictionary:(NSDictionary *)dic;

//获取手机设备的ip地址
+ (NSString *)getDeviceIPAddress:(BOOL)preferIPV4;

+ (NSDictionary *)indexMaping;

@end

@interface SYTool (ReadSDKResource)

/**
 加载本地的资源包
 */
+ (NSBundle *)resourceBundle;


/**
 从framework bundle中加载资源图片资源
 
 @param name 图片名称
 @return 获取到的图片资源
 */
+ (UIImage *)loadImageFromLocalWithName:(NSString *)name;

+ (UIImage*) createImageWithColor: (UIColor*) color;
+ (BOOL)hasVoiceAuth;
+ (BOOL)hasCameraAuth;
+ (BOOL)hasPhotoAuth;

@end

