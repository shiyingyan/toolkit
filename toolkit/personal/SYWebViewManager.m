//
//  SYWebViewManager.m
//  DingDing
//
//  Created by Shing on 3/29/16.
//  Copyright © 2016 Cstorm. All rights reserved.
//

#import "SYWebViewManager.h"

@interface SYWebViewManager ()<WKNavigationDelegate>

@property (nonatomic,strong,readwrite) WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation SYWebViewManager

-(void)sendWebViewToSuperView:(UIView *)superView withFrame:(CGRect)frame{
    [superView addSubview:self.webView];
    if( CGRectEqualToRect(frame, CGRectZero) ){
        frame = superView.bounds;
    }
    self.webView.frame = frame;
    [self registerKVO];
}
-(void)webViewAddScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name{
    if( self.webView.configuration.userContentController == nil ){
        self.webView.configuration.userContentController = [[WKUserContentController alloc] init];
    }
    [self.webView.configuration.userContentController addScriptMessageHandler:scriptMessageHandler name:name];
}

-(void)webViewAddUserScriptSource:(NSString *)scriptSource atInjectionTime:(WKUserScriptInjectionTime)injectionTime{
    if( self.webView.configuration.userContentController == nil ){
        self.webView.configuration.userContentController = [[WKUserContentController alloc] init];
    }
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:scriptSource injectionTime:injectionTime forMainFrameOnly:YES];
    [self.webView.configuration.userContentController addUserScript:userScript];
}

-(void)webViewRemoveAllUserScript{
    [self.webView.configuration.userContentController removeAllUserScripts];
}

-(void)webViewRemoveScriptMessageHandlerForName:(NSString *)name{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
}

-(void)reloadWebView{
    [self.webView reload];
}

-(void)webViewLoadUrl:(NSURL *)urlString{
    [self.webView loadRequest:[NSURLRequest requestWithURL:urlString]];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if( [object isEqual:self.webView] ){
        if( [keyPath isEqualToString:@"title"] ){
            if( [self.delegate respondsToSelector:@selector(webViewManager:webViewTitleDidChange:)] ){
                [self.delegate webViewManager:self webViewTitleDidChange:self.webView.title];
            }
        }
        if( [keyPath isEqualToString:@"estimatedProgress"] ){
            if( !_progressHidden ){
                self.progressView.progress = self.webView.estimatedProgress;
                if( self.progressView.progress==1 ){
                    [self removeProgressView];
                }
            }
            if( [self.delegate respondsToSelector:@selector(webViewManager:webViewLoadingWithProgress:)] ){
                [self.delegate webViewManager:self webViewLoadingWithProgress:self.webView.estimatedProgress];
            }
        }
    }
}
#pragma mark - webView navigation delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if( [self.delegate respondsToSelector:@selector(webViewManagerLoadingDidStart:)] ){
        [self.delegate webViewManagerLoadingDidStart:self];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if( [self.delegate respondsToSelector:@selector(webViewManagerLoadingDidFinished:)] ){
        [self.delegate webViewManagerLoadingDidFinished:self];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
//    DDLog(@"%s,error = %@",__FUNCTION__,error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self removeWebView];
    if( [self.delegate respondsToSelector:@selector(webViewManagerLoadingDidFailed:)] ){
        [self.delegate webViewManagerLoadingDidFailed:self];
    }
    if( !_progressHidden ){
        [self removeProgressView];
    }
}

-(void)removeProgressView{
    if( _progressView ){
        [_progressView removeFromSuperview];
        _progressView = nil;
    }
}
-(void)removeWebView{
    if( _webView){
        [self unRegisterKVO];
        [_webView removeFromSuperview];
        _webView = nil;
    }
}

-(void)setProgressHidden:(BOOL)progressHidden{
    _progressHidden = progressHidden;
    if( _progressHidden ){
        [self removeProgressView];
    }
}

#pragma mark 
-(void)registerKVO{
    if( _webView ){
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
}
-(void)unRegisterKVO{
    if( _webView ){
        [self.webView removeObserver:self forKeyPath:@"title"];
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}
#pragma mark
-(WKWebView *)webView{
    if( !_webView ){
        _progressHidden = NO;
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.allowsBackForwardNavigationGestures = YES;
        
    }
    return _webView;
}

-(UIProgressView *)progressView{
    if( !_progressView ){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, self.webView.frame.size.width, 1.0f)];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor colorWithRed:100 green:10 blue:100 alpha:0];
        [_webView addSubview:_progressView];
        [_webView bringSubviewToFront:_progressView];
    }
    return _progressView;
}
-(void)dealloc{
    [self unRegisterKVO];
}
@end
