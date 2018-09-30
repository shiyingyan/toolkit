//
//  SYImageScroll.m
//  YTImageBrowser
//
//  Created by Shing on 15/8/8.
//  Copyright (c) 2015年 Shing. All rights reserved.
//

//#import "UIImageView+AFNetworking.h"
#import "SYImageScroll.h"
#import "MBProgressHUD.h"
#import "SYDeviceTest.h"
#import "SDImageCache.h"
#import "MJHeader.h"

#define MaxZoomScale  2.5f
#define MinZoomScale  1.0f

@interface SYImageScroll()<UIScrollViewDelegate,UIActionSheetDelegate,MBProgressHUDDelegate>{
    MBProgressHUD * HUD;
    BOOL needAnimal;
}

@property (nonatomic,strong,readwrite) UITapGestureRecognizer *doubleTapGesture;

@end

@implementation SYImageScroll

#pragma mark - INIT (初始化)
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initialization];
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.userInteractionEnabled = YES;
        [_imgView setContentMode:UIViewContentModeScaleAspectFit];
        _imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_imgView setClipsToBounds:YES];
        
        [self addSubview:_imgView];
        [self addGestureRecognizers];
        [self addHUD];
    }
    return _imgView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

-(void)initialization{
    self.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.alwaysBounceVertical = NO;
    self.maximumZoomScale = MaxZoomScale;
    self.minimumZoomScale = MinZoomScale;
    self.tag = -1; /* 注明：后面以tag来判断当前页以免造成混乱 */
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.contentSize = self.bounds.size;
}

- (void)addGestureRecognizers{
    //长按手势 保存图片
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    
    _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
    _doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleTapGesture];
    
}

- (void)addHUD{
    HUD = [[MBProgressHUD alloc]initWithView:self];
    HUD.mode = MBProgressHUDModeIndeterminate;
  //  HUD.bezelView.color = [UIColor clearColor];
    HUD.delegate = self;
    [self addSubview:HUD];
}

#pragma mark - Public Action
#pragma mark 恢复图片原始状态
- (void)replyStatuseAnimated:(BOOL)animated{
    [self setZoomScale:1.0f animated:animated];
}

#pragma mark 双击事件
- (void)doubleTapAction{//图片变大或变小
    if (self.minimumZoomScale <= self.zoomScale && self.maximumZoomScale > self.zoomScale) {
        [self setZoomScale:self.maximumZoomScale animated:YES];
    }else {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
}

#pragma mark 横竖屏切换布局

- (void)setImgM:(SYImageModel *)imgM{
    if (!imgM) return;
    
    BOOL BUG = (_imgM.index == imgM.index);
    _imgM = imgM;
    self.imgView.image = imgM.image;
        CGRect frame = self.bounds;
        frame.size = imgM.size;
    if ((needAnimal == YES) && (BUG == YES)) {
        needAnimal = NO;
                [UIView animateWithDuration:0.2 animations:^{
                    self.imgView.frame = frame;
                    [self scrollViewDidZoom:self];
                }];
    }else{
        needAnimal = NO;
                self.imgView.frame = frame;
                [self scrollViewDidZoom:self];
        [self loadHttpImg];
    }
    
}

#pragma mark - Network loag (图片网络请求)
- (void)loadHttpImg{
    
    if ((_imgM.url) && (!_imgM.ishttp)) {
        [HUD show:YES];
        [self.imgView sd_setImageWithURL:_imgM.url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if( error ){
                [self requestResult:nil];
            }else{
                [self requestResult:image];
            }
            
            [HUD hide:YES];
            
        }];
    }
}

- (void)requestResult:(UIImage*)image{
    if (HUD.isHidden) return;
    if (image) {
        needAnimal = YES;
        [_imgM setImage:image];
        _imgM.http = YES;
        [self setImgM:_imgM];
    }
    [HUD hide:YES];
}

#pragma mark - Scroll View Deledate (不断适配图片大小)
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if( [self.zoomDelegate respondsToSelector:@selector(scrollViewDidZoom:)] ){
        [self.zoomDelegate scrollViewDidZoom:self];
    }
}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    //放大或缩小时图片位置(frame)调整,保证居中
//    CGFloat Wo = self.frame.size.width - self.contentInset.left - self.contentInset.right;
//    CGFloat Ho = self.frame.size.height - self.contentInset.top - self.contentInset.bottom;
//    CGFloat W = _imgView.frame.size.width;
//    CGFloat H = _imgView.frame.size.height;
//    CGRect rct = _imgView.frame;
//    rct.origin.x = MAX((Wo-W)*0.5, 0);
//    rct.origin.y = MAX((Ho-H)*0.5, 0);
//    _imgView.frame = rct;
//}

#pragma mark - Image Save (图像保存)
#pragma mark 长按手势
-(void)longPressAction:(UILongPressGestureRecognizer*)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        //        if ([SYDeviceTest userAuthorizationStatus]) {
        //            UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
        //            [actionSheet showInView:self];
        //        }
    }
}

#pragma mark Action Sheet Delegate (actionSheet代理)
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (self.imgView.image) {//保存图片
            UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

#pragma mark 图片保存结果回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{//保存图片回调
    if (error != NULL){ //失败
        MJLog(@"图片保存失败->%@",error);
    }else{//成功
        MJLog(@"图片保存成功");
    }
}

#pragma mark - HUD delegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    HUD.progress = 0.0f;
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CGPoint location = [[touches anyObject] locationInView:self];
//    
//}

@end
