#### 项目中抽象出的小工具。

#### 几个重要的工具类的使用参考

### 网络操作：SYHttpRequest
- 请参考hq项目

### 定位：SYAMapLocationManager 
```
self.locationDic = [[NSMutableDictionary alloc]init];
//获取用户位置
[self.locationManager requestLocationWithSingle:YES ReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *reGeoCode, NSError *error) {
if (error == nil && reGeoCode.province != nil) {
[self.locationDic  setObject:reGeoCode.province forKey:@"province"];
[self.locationDic  setObject:[reGeoCode.city substringToIndex:reGeoCode.city.length - 1]forKey:@"city"];
if (reGeoCode.district != nil) {
[self.locationDic  setObject:[reGeoCode.district substringToIndex:reGeoCode.district.length - 1] forKey:@"district"];
}
if (reGeoCode.street ) {
[self.locationDic  setObject:reGeoCode.street forKey:@"address"];
}
if (reGeoCode.number ) {
[self.locationDic  setObject:reGeoCode.number forKey:@"house_number"];
}
[self.locationDic  setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"longitude"];
[self.locationDic  setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];
[self requestLoactionToRay];//提交位置数据
}
}];
```

### 网页浏览  SYWebviewManager
- 网页和原生的交互
- 带有网页加载进度条

```

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "SYWebViewManager.h"

@interface WebViewController:UIViewController <SYWebViewManagerDelegate>

@property (nonatomic,copy)  NSString *webViewType;
@property (nonatomic,strong) SYWebViewManager *textWebViewManager;

@end
@implementation WebViewController
- (void)viewDidLoad {
[super viewDidLoad];
self.title = @"加载中...";
[self.textWebViewManager sendWebViewToSuperView:self.view withFrame:CGRectZero];
[self.textWebViewManager webViewLoadUrl:Web_Connect_Url(@"rule", _webViewType)];
}
#pragma mark
-(void)navLeftBtnClick{
if( _textWebViewManager&&self.textWebViewManager.webView.canGoBack ){
[self.textWebViewManager.webView goBack];
}else{
[super navLeftBtnClick];
}
}

#pragma mark - webViewManager delegate
-(void)webViewManager:(SYWebViewManager *)webViewManager webViewTitleDidChange:(NSString *)title{
self.title = title;
}
-(void)webViewManagerLoadingDidFailed:(SYWebViewManager *)webViewManager{
self.title = @"加载失败";
[self removeWebView];
}

#pragma mark
-(void)removeWebView{
if( _textWebViewManager ){
_textWebViewManager.delegate = nil;
_textWebViewManager = nil;
}
}

#pragma mark
-(SYWebViewManager *)textWebViewManager{
if( !_textWebViewManager ){
_textWebViewManager = [[SYWebViewManager alloc] init];
_textWebViewManager.webView.scrollView.showsVerticalScrollIndicator = YES;
_textWebViewManager.delegate = self;
}
return _textWebViewManager;
}

- (void)didReceiveMemoryWarning {
[super didReceiveMemoryWarning];
_textWebViewManager.delegate = nil;
_textWebViewManager = nil;
if( self.view.window==nil ){
self.view = nil;
}
}
@end

```


