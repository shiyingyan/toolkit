//
//  SYWebViewManager.h
//
//  Created by Shing on 3/29/16.
//  Copyright © 2016 Cstorm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

/***
 *  iOS8发布时，封装的。  >iOS8系统，未测试过。
 *
 */

@class SYWebViewManager;

@protocol SYWebViewManagerDelegate <NSObject>

@optional
/*
 *  加载网页，网页标题改变时调用。
 */
-(void)webViewManager:(SYWebViewManager *)webViewManager webViewTitleDidChange:(NSString *)title;

/*
 *  网页加载进度。
 */
-(void)webViewManager:(SYWebViewManager *)webViewManager webViewLoadingWithProgress:(double)progress;

-(void)webViewManagerLoadingDidStart:(SYWebViewManager *)webViewManager;
-(void)webViewManagerLoadingDidFinished:(SYWebViewManager *)webViewManager;
-(void)webViewManagerLoadingDidFailed:(SYWebViewManager *)webViewManager;

@end

@interface SYWebViewManager : NSObject

@property (nonatomic,weak) id<SYWebViewManagerDelegate>delegate;

@property (nonatomic,strong,readonly) WKWebView *webView;

@property (nonatomic,assign) BOOL progressHidden;   //!< default is NO

/**
 *  设置父视图以及大小位置
 *
 *  @param superView 父视图
 *  @param frame     相对父视图的大小位置，可以缺省为CGRectZero
 */
-(void)sendWebViewToSuperView:(UIView *)superView withFrame:(CGRect)frame;

/**
 *  webView向原生通信。
 *  在通信不用的时候，一定要调用webViewRemoveScriptMessageHandlerForName:来删除通信。
 *  否则，会出现内存泄露问题
 *
 *  @param scriptMessageHandler webView通知的原生对象，在相应的代理方法中，执行接收到的消息
 *  @param name                 通知的名字，由名字识别是哪个通信
 */
-(void)webViewAddScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler
                                 name:(NSString *)name;

/**
 *  原生,修改web业务逻辑 
 *
 *  @param scriptSource  脚本代码字符串
 *  @param injectionTime 脚本代码执行时间
 */
-(void)webViewAddUserScriptSource:(NSString *)scriptSource
                  atInjectionTime:(WKUserScriptInjectionTime)injectionTime;

/**
 *  移除添加的脚本代码。
 */
-(void)webViewRemoveAllUserScript;

/**
 *  移除原生对webView的监听。
 *
 *  @param name 通知的名字
 */
-(void)webViewRemoveScriptMessageHandlerForName:(NSString *)name;

/**
 *  刷新webView
 */
-(void)reloadWebView;

/**
 *  webView从urlString加载数据
 */
-(void)webViewLoadUrl:(NSURL *)urlString;

@end
