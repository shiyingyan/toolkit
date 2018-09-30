//
//  DDRequestManager.h
//  DingDing
//
//  Created by Shing on 5/10/16.
//  Copyright © 2016 Cstorm. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"

/**
 *  @author Shing, 16-06-25 16:06:23
 *
 *  @brief 服务器响应回调
 *
 *  @param response 响应结果
 *  @param success  是否成功返回数据
 *  @param error    未成功返回时的出错信息
 */
typedef void(^ServiceResponseBlock)(id _Nullable response,BOOL success,NSError *_Nullable error);


/**
 对AFNetworking网络操作的封装
 
 说明：
 1、类文件中，urlString指的是URL的absoluteString
 */
@interface SYHttpRequest : NSObject

+ (SYHttpRequest *_Nonnull)sharedInstance;

@property (nonatomic,strong) AFHTTPSessionManager * _Nonnull httpSessionManager;


#pragma mark --- 发送POST数据请求
/**
 *  @author Shing, 16-06-22 18:06:09
 *
 *  @brief 向服务器发起HTTP连接
 *
 *  @param method     HTTP方法,GET、POST、PUT、DELETE等
 *  @param urlString  接口地址
 *  @param parameters 请求参数
 *  @param completion    成功回调
 */
-(NSURLSessionTask *_Nullable)sendRequestToServerWithMethod:(NSString * _Nullable)method
                                                        url:(NSString * _Nullable)urlString
                                              authorization:(NSString * _Nullable)authorization
                                                 parameters:(id _Nullable)parameters
                                                 completion:(_Nullable ServiceResponseBlock)completion;

/**
 *  @author Shing, 16-06-22 18:06:00
 *
 *  @brief 向服务器发起HTTP连接，注意这里的uploadProgress和downloadProgress指的是参数的进度，不是指文件的上传和下载进度
 *
 *  @param method                HTTP方法,GET、POST、PUT、DELETE等
 *  @param urlString             接口地址
 *  @param parameters            请求参数
 *  @param uploadProgressBlock   上传进度,not in main queue
 *  @param downloadProgressBlock 下载进度,not in main queue
 *  @param completion               成功回调
 */
-(NSURLSessionTask *_Nullable)sendRequestToServerWithMethod:(NSString * _Nullable)method
                                                        url:(NSString * _Nullable)urlString
                                              authorization:(NSString * _Nullable)authorization
                                                 parameters:(id _Nullable)parameters
                                             uploadProgress:(nullable void (^)(NSProgress * _Nullable uploadProgress)) uploadProgressBlock
                                           downloadProgress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgressBlock
                                                 completion:(_Nullable ServiceResponseBlock)completion;


#pragma mark - 管理对应controller的AF的网络任务tasks

/**
 注册网络操作任务。注册之后，一定要在controller的对应位置，调用函数cancelAFSesstionTasksForControllerHash:来取消
 
 @param task 网络操作任务
 @param hash controller对应的hash值
 */
- (void)registerAFSesstionTask:(NSURLSessionTask * _Nullable)task forControllerHash:(NSUInteger)hash;

/**
 注册网络操作任务。注册之后，一定要在controller的对应位置，调用函数cancelAFSesstionTasksForControllerHash:来取消

 @param task 网络操作任务
 @param hash controller对应的hash值
 @param concurrent 当前controller中，对应同一个URL接口的task是否需要并发
 */
- (void)registerAFSesstionTask:(NSURLSessionTask * _Nullable)task forControllerHash:(NSUInteger)hash sameURLConcurrentInCurrentController:(BOOL)concurrent;

/**
 取消controller中所有的网络操作
 
 @param hash controller对应的hash值
 */
- (void)cancelAFSesstionTasksForControllerHash:(NSUInteger)hash;

/**
 取消session中指定URL的网络操作

 @param urlString URL字符串
 */
- (void)cancelAFSesstionTaskWithURLString:(NSString * _Nullable)urlString;


/**
 取消controller中指定的URL的网络操作
 如果controller中有相同的url并发，请谨慎调用此方法
 
 @param urlString URL字符串
 @param hash controller的hash值
 */
- (void)cancelAFSesstionTaskWithURLString:(NSString * _Nullable)urlString
                        forControllerHash:(NSUInteger)hash;

#pragma mark - 自定义线程管理
-(void)addCustomOperation:(NSOperation * _Nullable)operation;
-(void)cancelCustomOperationWithNames:(NSArray * _Nullable)names;

@end

@interface SYHttpRequest (NetworkReachability)

/**
 *  网络是否可用
 */
+(BOOL)networkReachibility;

- (void)startMonitorReachability;
- (void)stopMonitorReachability;
- (void)monitorNetworkWithStatusChangeBlock:(void(^_Nullable)(AFNetworkReachabilityStatus status))statusChangeBlock;

@end
