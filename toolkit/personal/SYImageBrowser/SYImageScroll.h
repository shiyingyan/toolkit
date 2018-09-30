//
//  SYImageScroll.h
//  YTImageBrowser
//
//  Created by Shing on 15/8/8.
//  Copyright (c) 2015年 Shing. All rights reserved.

#import <UIKit/UIKit.h>
#import "SYImageModel.h"

@class SYImageScroll;

@protocol SYImageScrollProtocol <NSObject>

- (void)scrollViewDidZoom:(SYImageScroll * _Nullable)scrollView NS_AVAILABLE_IOS(3_2); // any zoom scale changes

@end

@interface SYImageScroll : UIScrollView

@property (nonatomic,weak) id<SYImageScrollProtocol> _Nullable zoomDelegate;
@property (nonatomic, strong) UIImageView * _Nullable imgView;
@property (nonatomic, strong) SYImageModel * _Nullable imgM;

@property (nonatomic,strong,readonly) UITapGestureRecognizer * _Nullable doubleTapGesture;

/**恢复图片原始状态 可选择是否包含动画*/
- (void)replyStatuseAnimated:(BOOL)animated;

/**双击事件(父视触发，选着性调用)*/
- (void)doubleTapAction;


@end
