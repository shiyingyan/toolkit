//
//  SYAMapLocationManager.h
//  DingDing
//
//  Created by shiying on 11/18/15.
//  Copyright © 2015 Cstorm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>


/**
 定位结果回调

 @param location 位置
 @param reGeoCode 反编码信息
 @param error 错误信息
 */
typedef void(^LocationCompletionBlock)(CLLocation *location,AMapLocationReGeocode *reGeoCode,NSError *error);

@interface SYAMapLocationManager : NSObject


/**
 获取定位信息

 @param single YES为单次定位，否则是持续定位
 @param withReGeocode 是否需要反编码信息
 @param completionBlock 定位回调结果
 */
- (void)requestLocationWithSingle:(BOOL)single
                        ReGeocode:(BOOL)withReGeocode
                  completionBlock:(LocationCompletionBlock)completionBlock;


@end
