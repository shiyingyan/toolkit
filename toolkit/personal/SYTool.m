//
//  SYTool.m
//  MJDamageAssessment
//
//  Created by Shing on 10/04/2017.
//  Copyright © 2017 Shing. All rights reserved.
//

#import "SYTool.h"
#import "SYToast.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation SYTool

+(BOOL)isValidateChinese:(NSString *)string {
    NSString *regex = @"[\u4e00-\u9fa5]";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [test evaluateWithObject:string];
}
+(BOOL)isValidateFamilyName:(NSString *)familyName{
    NSString *nameRegex = @"[\u4e00-\u9fa5]{1,2}";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [nameTest evaluateWithObject:familyName];
}

+(BOOL)isValidateName:(NSString *)name{
    NSString *nameRegex = @"[\u4e00-\u9fa5]{2,4}";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [nameTest evaluateWithObject:name];
}

+(BOOL)isValidateNickname:(NSString *)nickname{
    NSString *nameRegex = @"^[\u4e00-\u9fa5a-zA-Z0-9]+$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [nameTest evaluateWithObject:nickname];
}

+(BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)isValidatePhone:(NSString *)phone{
    NSString *phoneRegex = @"(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1})|(14[0-9]{1}))+\\d{8})";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
+(BOOL)isValidatePassword:(NSString *)pwd{
    NSString *pwdRegex = @"^[A-Z0-9a-z]{6,16}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwdTest evaluateWithObject:pwd];
}

+(BOOL)isValidateInteger:(NSString *)string{
    NSString *integerRegex = @"[1-9][0-9]{0,20}";
    NSPredicate *integerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",integerRegex];
    return [integerTest evaluateWithObject:string];
}

+(BOOL)isValidateVehicleNumber:(NSString *)vehicleNumber{
    NSString *vehicleNumRegex = @"[\u4eac|\u6caa|\u6d25|\u6e1d|\u6d59|\u7ca4|\u82cf|\u9c81|\u95fd|\u7696|\u8700|\u9102|\u5180|\u6ec7|\u9ed1|\u5409|\u8fbd|\u743c|\u6e58|\u8c6b|\u9ed4|\u8d63|\u6842|\u9655|\u664b|\u9752|\u5b81|\u9647|\u85cf|\u8499|\u65b0|\u53f0|\u6e2f|\u6fb3]{1}[A-Z]{1}[A-Z_0-9]{5,6}";
    NSPredicate *vehicleNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",vehicleNumRegex];
    return [vehicleNumTest evaluateWithObject:vehicleNumber];
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}

+(BOOL)isIphone4s{
    return [UIScreen mainScreen].bounds.size.height==480;
}
+ (BOOL)isIphone5
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [UIScreen mainScreen].currentMode.size) : NO);
}
+(BOOL)isIphone6{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(375*2, 667*2), [UIScreen mainScreen].currentMode.size) : NO);
}
+(BOOL)isIphone6p{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(414*3, 736*3), [UIScreen mainScreen].currentMode.size) : NO);
}
+(BOOL)isMoreThanIphone5s{
    return ![self isIphone4s] && ![self isIphone5];
}
+(BOOL)isMoreThanIphone6{
    return [UIScreen mainScreen].bounds.size.height > 667;
}

+(CGFloat)keyboardHeight {
    if( [self isMoreThanIphone6] ) { //plus手机的键盘高度为270;
        return 270.0f;
    }
    return 250.0f;
}
+ (NSString *)safeString:(NSString *)string
{
    if (!string || [string isKindOfClass:[NSNull class]] || ![string isKindOfClass:[NSString class]]){
        return @"";
    }
    return string;
}
+ (BOOL)isSafeString:(NSString *)string {
    if (string == nil || string == NULL) {
        
        return NO;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return NO;
        
    }
    
    return YES;
}


+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize = CGSizeZero;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
    
    textSize = [text sizeWithFont:font constrainedToSize:size];
    
#else
    
    NSDictionary * tdic = @{NSFontAttributeName: font};
    textSize = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:tdic
                                  context:nil].size;
#endif
    
    return textSize;
}

+(void)showFunctionInstruction{
//    [SYToast showMessage:in_develop];
}

+(NSArray *)allCharacters{
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}

+(NSString *)formatInterger:(NSInteger)number{
    if( number>=10 ){
        return [NSString stringWithFormat:@"%ld",(long)number];
    }else if(number>=0){
        return [NSString stringWithFormat:@"0%ld",(long)number];
    }
    return @"00";
}

+(NSString *)jsonStringFromDictionary:(NSDictionary *)dic{
    NSArray *keys = dic.allKeys;
    NSArray *values = dic.allValues;
    
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i=0; i<keys.count; i++) {
        if( i==keys.count-1 ){
            if( [values[i] hasPrefix:@"{"] && [values[i] hasSuffix:@"}"] ){
                [result appendFormat:@"\"%@\":%@",keys[i],values[i]];
            }else{
                [result appendFormat:@"\"%@\":\"%@\"",keys[i],values[i]];
            }
        }else{
            if( [values[i] hasPrefix:@"{"] && [values[i] hasSuffix:@"}"] ){
                [result appendFormat:@"\"%@\":%@,",keys[i],values[i]];
            }else{
                [result appendFormat:@"\"%@\":\"%@\",",keys[i],values[i]];
            }
        }
    }
    result = [[[@"{" stringByAppendingString:result] stringByAppendingString:@"}"] copy];
    return result;
}


//获取手机设备的ip地址
+ (NSString *)getDeviceIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (NSDictionary *)indexMaping {
    return @{@"1":@"one",
             @"2":@"two",
             @"3":@"three",
             @"4":@"four",
             @"5":@"five",
             @"6":@"six",
             @"7":@"seven",
             @"8":@"eight",
             @"9":@"nine",
             @"10":@"ten",
             @"11":@"eleven",
             @"12":@"twelve",
             @"13":@"thirteen",
             @"14":@"fourteen",
             @"15":@"fifteen",
             @"16":@"sixteen",
             @"17":@"seventeen",
             @"18":@"eithteen",
             @"19":@"nineteen",
             @"20":@"twenty"};
}

@end

@implementation SYTool (ReadSDKResource)


+ (NSBundle *)resourceBundle {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
//    
//    return [NSBundle bundleWithPath:path];
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MJResources" ofType:@"bundle"]];
}

+ (UIImage *)loadImageFromLocalWithName:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[self resourceBundle] compatibleWithTraitCollection:nil];
}

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (BOOL)hasVoiceAuth
{
    AVAuthorizationStatus voicestatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//麦克风权限
    if (voicestatus == AVAuthorizationStatusRestricted || voicestatus == AVAuthorizationStatusDenied) {
        UIAlertController* alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您屏蔽了选择麦克风的权限，开启请去系统设置->隐私->麦克风来打开权限" preferredStyle:UIAlertControllerStyleAlert];
        
        
        //添加确定和取消按钮
        UIAlertAction *cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }];
        [alertVc addAction:cacleAction];
        [alertVc addAction:sureAction];
        
        [[self getCurrentVC] presentViewController:alertVc animated:YES completion:nil];
        return NO;
    }
    return YES;
}

+ (BOOL)hasCameraAuth
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController* alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您屏蔽了选择相机的权限，开启请去系统设置->隐私->相机来打开权限" preferredStyle:UIAlertControllerStyleAlert];
        
        
        //添加确定和取消按钮
        UIAlertAction *cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }];
        [alertVc addAction:cacleAction];
        [alertVc addAction:sureAction];
        
        [[self getCurrentVC] presentViewController:alertVc animated:YES completion:nil];
        return NO;
    }
    else
        return YES;
    
}

+ (BOOL)hasPhotoAuth
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        //        MJSysAuthWarnViewController* warn = [[MJSysAuthWarnViewController alloc]init];
        //        warn.warnString = @"您屏蔽了选择相册的权限，开启请去系统设置->隐私->我的App来打开权限";
        //        [[self getCurrentVC] presentViewController:nav(warn) animated:YES completion:nil];
        UIAlertController* alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您屏蔽了选择相册的权限，开启请去系统设置->隐私->照片来打开权限" preferredStyle:UIAlertControllerStyleAlert];
        
        
        //添加确定和取消按钮
        UIAlertAction *cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }];
        [alertVc addAction:cacleAction];
        [alertVc addAction:sureAction];
        
        [[self getCurrentVC] presentViewController:alertVc animated:YES completion:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
