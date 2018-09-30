//
//  SYImageBrowerController.h
//  YTImageBrowser
//
//  Created by Shing on 15/8/24.
//  Copyright (c) 2015年 Shing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYImageBrowerControllerDelegate <NSObject>

@optional

/*
 ** img   图片
 ** index 第几张图片 为0时是第一张
 */

- (void)imageBrowerControllerInitEnd;

- (void)imageBrowerControllerWillDismisswithImg:(UIImage*)img Index:(NSInteger)index;

@end

@interface SYImageBrowerController : UIViewController

/*
 ** targart 代理,可为nil
 ** img_s 默认显示图片组,可为nil
 ** url_s 网络加载图片地址,可为nil
 ** index 开始图片位置 为0时是第一张
 */
- (instancetype)initWithDelegate:(id<SYImageBrowerControllerDelegate>)delegate Imgs:(NSArray*)imgs Urls:(NSArray*)urls PageIndex:(NSInteger)index;

/*
 ** targart 代理,可为nil
 ** imgModels 参考 "SYImageModel.h"
 ** index 开始图片位置 为0时是第一张
 */
- (instancetype)initWithDelegate:(id<SYImageBrowerControllerDelegate>)delegate ImgModels:(NSArray*)imgModels PageIndex:(NSInteger)index;

@end
