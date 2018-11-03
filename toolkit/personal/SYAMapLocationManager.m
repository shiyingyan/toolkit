//
//  SYAMapLocationManager.m
//  DingDing
//
//  Created by shiying on 11/18/15.
//  Copyright © 2015 Cstorm. All rights reserved.
//

#import "SYAMapLocationManager.h"
#import "SYToast.h"
#import <UIKit/UIKit.h>
#import "SYBaseView.h"

@interface SYAMapLocationManager ()<AMapLocationManagerDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *systemLocationManager;//为了检测用户修改了应用的定位选项->打开定位后，重新开始定位
@property (nonatomic,strong) AMapLocationManager *locationManager;

@property (nonatomic,copy) LocationCompletionBlock locationCompletionBlock;

@end

@implementation SYAMapLocationManager

#pragma mark - location request
- (void)requestLocationWithSingle:(BOOL)single ReGeocode:(BOOL)withReGeocode completionBlock:(LocationCompletionBlock)completionBlock {
    
    if( single ) {
        
        [self.locationManager requestLocationWithReGeocode:withReGeocode completionBlock:completionBlock];
        
    }else{
        
        if( self.locationServiceEnable ){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [self.locationManager startUpdatingLocation];
        }

    }
}

#pragma mark - AMapLocationManager delegate
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if( self.locationCompletionBlock ){
        self.locationCompletionBlock(nil,nil,error);
    }
}

-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if( self.locationCompletionBlock && reGeocode){
        self.locationCompletionBlock(location,reGeocode,nil);
    }
}

#pragma mark - lazy loading

-(AMapLocationManager *)locationManager{
    if( !_locationManager ){
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.locationTimeout = 2;
        self.locationManager.reGeocodeTimeout = 2;
        if( [UIDevice currentDevice].systemVersion.floatValue >= 9.0 ) {
            _locationManager.allowsBackgroundLocationUpdates = NO;
        }
        _locationManager.delegate = self;
    }
    return  _locationManager;
}
-(CLLocationManager *)systemLocationManager{
    if( !_systemLocationManager ){
        _systemLocationManager = [[CLLocationManager alloc] init];
    }
    return _systemLocationManager;
}
#pragma mark - location service enable
-(BOOL)locationServiceEnable{
    if( [CLLocationManager locationServicesEnabled] ){
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if( status==kCLAuthorizationStatusDenied || status==kCLAuthorizationStatusRestricted ){
           
            UIAlertController *alertController = [UIAlertController showAlertWithStyle:UIAlertControllerStyleAlert title:@"温馨提醒" message:@"我们需要你的位置信息，才能为你提供更好的服务。是否去设置打开定位?" firstActionTitle:@"设置" secondActionTitle:@"拒绝" firstHandler:^(UIAlertAction * _Nullable action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } secondHandler:nil];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            
            self.systemLocationManager.delegate = self;
            return NO;
        }
    }else{
        [SYToast showMessage:@"当前设备不支持定位功能"];
        return NO;
    }
    return YES;
}


#pragma mark - CLLocationManager delegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if( status==kCLAuthorizationStatusAuthorizedWhenInUse||status==kCLAuthorizationStatusAuthorizedAlways ){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.locationManager startUpdatingLocation];
    }
}

@end
