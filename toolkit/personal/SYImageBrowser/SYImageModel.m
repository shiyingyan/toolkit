//
//  SYImageModel.m
//  YTImageBrowser
//
//  Created by Shing on 15/8/8.
//  Copyright (c) 2015年 Shing. All rights reserved.
//

#import "SYImageModel.h"

#define Max_Count_Obj 5000
//#define Device_Size ([UIScreen mainScreen].bounds.size)

@implementation SYImageModel

+(NSArray *)IMGMessagesWithImgs:(NSArray *)imgs Urls:(NSArray *)urls{
    //根据图片及图片网址来创建一组该对象 最多为(Max_Count_Obj)个
    NSInteger max =  MAX(imgs.count, urls.count);
    NSInteger maxInt = MIN(Max_Count_Obj, max);
    NSMutableArray * imgModels = [NSMutableArray arrayWithCapacity:maxInt];
    for (int i = 0; i < maxInt; i++) {
        SYImageModel * img = [SYImageModel new];
        
        img.image = i < imgs.count?imgs[i]:nil;
        id objUrl = i < urls.count?urls[i]:nil;
        if (objUrl) {
            if ([objUrl isMemberOfClass:[NSURL class]]) {
                img.url = objUrl;
            }else{
                img.url = [NSURL URLWithString:objUrl];
            }
            if (!img.image || (img.image.size.width < 1.0f)) {
                img.image = [UIImage imageNamed:@"default_img"];
            }
        }
        img.index = i;
        img.http = NO;
        
        [imgModels addObject:img];
    }
    return imgModels;
}

//-(void)setImage:(UIImage *)image{
//    if (image) {
//        _image = image;
//        self.size = [self imageSize];
//    }
//}
//
//-(CGSize)imageSize{//图片根据屏幕大小来调整size,保证与屏幕比例适配
//   //获取设备屏幕的大小
//    CGSize deviceSize = CGSizeZero;
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    if( UIDeviceOrientationIsPortrait(orientation) ){
//        
//        deviceSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
//        
//    }else if (UIDeviceOrientationIsLandscape(orientation) ){
//        
//        deviceSize = CGSizeMake(CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds));
//
//    }
//    
//    //根据设备屏幕的大小，来适配图片的大小
//    CGFloat wid = _image.size.width;
//    CGFloat heig = _image.size.height;
//    if ((wid <= deviceSize.width) && (heig <= deviceSize.height)) {
//        return _image.size;
//    }
//    
//    CGFloat scale_poor = (wid/deviceSize.width)-( heig/deviceSize.height);
//    CGSize endSize = CGSizeZero;
//    
//    if (scale_poor > 0) {
//        CGFloat height_now = heig*(deviceSize.width/wid);
//        endSize = CGSizeMake(deviceSize.width, height_now);
//    }else{
//        CGFloat width_now = wid*(deviceSize.height/heig);
//        endSize = CGSizeMake(width_now, deviceSize.height);
//    }
//    
//    return endSize;
//}

@end
