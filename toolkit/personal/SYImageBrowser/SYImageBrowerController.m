//
//  SYImageBrowerController.m
//  YTImageBrowser
//
//  Created by Shing on 15/8/24.
//  Copyright (c) 2015年 Shing. All rights reserved.
//

#import "SYImageBrowerController.h"
#import "SYImageScroll.h"

#define Page_Lab_H  14.0f
#define Page_Scale  (4.9f/5.0f)

@interface SYImageBrowerController ()<UIScrollViewDelegate>{
    NSInteger currentPageNumber,currentIndex;
    CGFloat priopPointX; // scrollView 划过的前一个点x坐标
    SYImageScroll * currentScroll;
}

@property (nonatomic, assign) id<SYImageBrowerControllerDelegate> delegate;
@property (nonatomic, strong) NSArray * imgModels;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * pageLabel;
@property (nonatomic, strong) NSMutableArray * imgScrolls;

@end

@implementation SYImageBrowerController

#pragma mark - INIT (一切都是为了初始化)
- (NSMutableArray *)imgScrolls{
    if (!_imgScrolls) {
        _imgScrolls = [NSMutableArray arrayWithCapacity:2];
    }
    return _imgScrolls;
}

- (void)didReceiveMemoryWarning {
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithDelegate:(id<SYImageBrowerControllerDelegate>)delegate Imgs:(NSArray *)imgs Urls:(NSArray *)urls PageIndex:(NSInteger)index{
    
    NSArray * imgMsgs = [SYImageModel IMGMessagesWithImgs:imgs Urls:urls];
    return [self initWithDelegate:delegate ImgModels:imgMsgs PageIndex:index];
}

- (instancetype)initWithDelegate:(id<SYImageBrowerControllerDelegate>)delegate ImgModels:(NSArray *)imgModels PageIndex:(NSInteger)index{
    if (self = [super init]) {
        self.delegate = delegate;
        self.imgModels = [imgModels copy];
        currentPageNumber = index;
        currentIndex = -1;
        [self initEnd];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)initUI{
    self.view.backgroundColor = [UIColor blackColor];
    [self updateViewTransformByOrientation];
    
    [self addScrollView];
    [self addPageLabel];
    [self addGesture];
}

- (void)addScrollView{//添加scrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;

    [self scrollViewAddSubView];
    [self.view addSubview:self.scrollView];
}

- (void)addPageLabel{//添加 显示当前页码和总的页码UI
    UILabel* tempLabel = [[UILabel alloc]init];
    self.pageLabel = tempLabel;
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.font = [UIFont systemFontOfSize:12.0f];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.text = [self pageText];

    [self.view addSubview:self.pageLabel];
}

- (void)addGesture{//添加单击返回,双击缩放手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];//单击优先级滞后于双击
}

- (void)scrollViewAddSubView{//scrollView添加内置IMGSeeScroll视图
    
    /* 提示：当图片数大于等于2张时，目前设计为2个IMGSeeScroll进行重用，修改需谨慎 */
    for (int i = 0; i < MIN(2, self.imgModels.count); i++) {
        SYImageScroll * imageScroll = [[SYImageScroll alloc]initWithFrame:self.scrollView.bounds];
        imageScroll.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:imageScroll];
        [self.imgScrolls addObject:imageScroll];
    }
    
    [self scrollviewIndex:currentPageNumber];
}

#pragma mark - layout Sub Views (横竖屏切换重新布局)
//根据设备方向，适配view的方向
-(void)updateViewTransformByOrientation{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];

    //转屏幕之前，先把图片的缩放大小调整为最小值
    currentScroll.zoomScale = currentScroll.minimumZoomScale;
    
    self.view.transform = CGAffineTransformIdentity;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationLandscapeLeft:
            
            self.view.transform =  CGAffineTransformMakeRotation(M_PI*0.5f);
            break;
            
        case UIDeviceOrientationLandscapeRight:
            
            self.view.transform = CGAffineTransformMakeRotation(M_PI*1.5f);
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            
            self.view.transform = CGAffineTransformMakeRotation(-M_PI);
            break;
            
        case UIDeviceOrientationPortrait:
            
            self.view.transform = CGAffineTransformIdentity;
            break;
            
        default:
            break;
    }
    
    [UIView commitAnimations];
}
-(void)orientationDidChange{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if( UIDeviceOrientationIsPortrait(orientation) ){
        self.view.bounds = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    }else if( UIDeviceOrientationIsLandscape(orientation) ){
        self.view.bounds = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds));
    }
    
    [self updateViewTransformByOrientation];

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}


- (void)scrollViewLayoutSubViews{//重新布局scrollView内部的控件
    for (SYImageScroll * imageScroll in self.imgScrolls) {
        if (![imageScroll isKindOfClass:[SYImageScroll class]]) return;
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = (imageScroll.imgM.index) * (frame.size.width);
        imageScroll.frame = frame;
        imageScroll.imgView.frame = imageScroll.bounds;
    }
    
    [currentScroll replyStatuseAnimated:YES];
    [self.scrollView setContentOffset:currentScroll.frame.origin];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    CGSize size = self.scrollView.bounds.size;
    size.width *= self.imgModels.count;
    self.scrollView.contentSize = size;

    CGRect frame = self.view.bounds;
    frame.origin.y = (frame.size.height * Page_Scale) - Page_Lab_H;
    frame.size.height = Page_Lab_H;
    self.pageLabel.frame = frame;
    
    [self scrollViewLayoutSubViews];
}

#pragma mark - Tap Gesture Recognizer action (手势)
- (void)tapAction:(UITapGestureRecognizer*)tap{
    [self delegateWillDismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doubleTapAction:(UITapGestureRecognizer*)doubleTap{
    [currentScroll doubleTapAction];
}

#pragma mark - Scroll View Deledate (scroll 代理)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!scrollView.isDragging) return;
    [self scrollViewDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDragging:scrollView];
    
    for (SYImageScroll * sc in self.imgScrolls) {
        if (sc != currentScroll) {
            [sc replyStatuseAnimated:NO];
        }
    }
    [self pageHiden];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self pageShow];
}

#pragma mark - Image Scroll Reuse (imageScroll复用)
- (void)scrollViewDragging:(UIScrollView*)scrollView{
    CGFloat pointx = (scrollView.contentOffset.x)/(scrollView.bounds.size.width);
    
    if (scrollView.contentOffset.x > priopPointX) {
        [self scrollviewIndex:ceilf(pointx)];//取上整
    }else{
        [self scrollviewIndex:floorf(pointx)];//取下整
    }
    
    NSInteger integer = pointx+0.5;
    if (integer != currentPageNumber) {
        currentPageNumber = integer;
        self.pageLabel.text = [self pageText];
    }
    priopPointX = scrollView.contentOffset.x;
}

- (void)scrollviewIndex:(NSInteger)index{
    if ((currentIndex == index)||(index >= self.imgModels.count)){
        return;
    }
    currentIndex = index;
    SYImageScroll * imageScroll = [self dequeueReusableScrollView];
    currentScroll = imageScroll;
    if (imageScroll.tag == index) return;
    
    [currentScroll replyStatuseAnimated:NO];
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = index * (frame.size.width);
    imageScroll.frame = frame;
    imageScroll.tag = index;
    imageScroll.imgM = self.imgModels[index];
}

- (SYImageScroll*)dequeueReusableScrollView{
    SYImageScroll * imageScroll = self.imgScrolls.lastObject;
    [self.imgScrolls removeLastObject];
    [self.imgScrolls insertObject:imageScroll atIndex:0];
    return imageScroll;
}

#pragma mark - Page & Delegate Action (嗯哼...)
- (void)pageHiden{
    
}

- (void)pageShow{
    
}

- (NSString*)pageText{
    return [NSString stringWithFormat:@"%d/%d",(int)(currentPageNumber+1),(int)(self.imgModels.count)];
}

- (void)initEnd{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowerControllerInitEnd)]) {
        [self.delegate imageBrowerControllerInitEnd];
    }
}

- (void)delegateWillDismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowerControllerWillDismisswithImg:Index:)]) {
        [self.delegate imageBrowerControllerWillDismisswithImg:currentScroll.imgM.image Index:currentPageNumber];
    }
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end
