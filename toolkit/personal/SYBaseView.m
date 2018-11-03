//
//  YSYBaseView.m
//  WeChatLoginWithUMengDemo
//
//  Created by Shing on 11/6/14.
//  Copyright (c) 2014 Shing. All rights reserved.
//

#import "SYBaseView.h"

@interface SYAnimationButton ()

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation SYAnimationButton

-(void)setShowAnimation:(BOOL)showAnimation{
    if( showAnimation ){
        [self.activityIndicator startAnimating];
    }else{
        if( _activityIndicator.isAnimating ){
            [self.activityIndicator stopAnimating];
            [_activityIndicator removeFromSuperview];
            _activityIndicator = nil;
        }
    }
}
-(UIActivityIndicatorView *)activityIndicator{
    if( !_activityIndicator ){
        CGFloat width = 20;
        CGFloat height = width;
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicator.frame = CGRectMake(self.titleLabel.frame.origin.x-width-30,(self.frame.size.height-height)/2.0f, width, height);
        _activityIndicator.backgroundColor = [UIColor clearColor];
        [self addSubview:_activityIndicator];
    }
    return _activityIndicator;
}
@end

@implementation SYBaseView

@end

@implementation UILabel (SYLabel)

+(UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text font:(CGFloat)font tag:(NSInteger)tag
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.tag = tag;
    return label;
}

@end

@implementation UIButton (SYButton)

+(instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title titleNormalColor:(UIColor *)color titleSelectedColor:(UIColor *)selectedColor target:(id)target action:(SEL)action
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton *)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *)normalImage disabledImage:(UIImage *)disabledImage
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:disabledImage forState:UIControlStateDisabled];
    return button;
}
+(UIButton *)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *)normalImage backSelectedImage:(UIImage *)selectedImage
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if( normalImage )
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    if (selectedImage )
        [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    return button;
}
+(UIButton *)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *)normalImage disabledImage:(UIImage *)disabledImage target:(id)target action:(SEL)action
{
    UIButton *button = [self buttonWithFrame:frame backNormalImage:normalImage disabledImage:disabledImage];
    if( target&&action ){
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}
+(UIButton *)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *)normalImage backSelectedImage:(UIImage *)selectedImage contentImage:(UIImage *)contentImage
{
    UIButton *button = [self buttonWithFrame:frame backNormalImage:normalImage backSelectedImage:selectedImage];
    if( contentImage ){
        [button setImage:contentImage forState:UIControlStateNormal];
    }
    return button;
}
+(UIButton *)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *)normalImage backSelectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action
{
    UIButton *button = [self buttonWithFrame:frame backNormalImage:normalImage backSelectedImage:selectedImage];
    if( target && action )
    {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}
+(UIButton *)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *)normalImage backSelectedImage:(UIImage *)selectedImage contentImage:(UIImage *)contentImage target:(id)target action:(SEL)action
{
    UIButton *button = [self buttonWithFrame:frame backNormalImage:normalImage backSelectedImage:selectedImage contentImage:contentImage];
    if( target && action )
    {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

+(UIButton *)buttonWithFrame:(CGRect)frame BackImage:(UIImage *)image upText:(NSString *)upText downText:(NSString *)downText target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithFrame:frame backNormalImage:image backSelectedImage:nil target:target action:action];
    
    NSInteger count = 2;
    if( (upText==nil && downText != nil) || (upText!=nil && downText==nil)){
        count = 1;
    }else if(upText==nil && downText==nil){
        count = 0;
    }
    
    if( count ){
        CGFloat height = 15.0f;
        CGFloat verticalSpace = (button.frame.size.height-count*height)/(count+1)-1;
        CGFloat width = button.frame.size.width-2*2.0f;
        for (NSInteger i=0; i<count; i++) {
            UILabel *label = [UILabel labelWithFrame:CGRectMake(0, verticalSpace+i*(height+verticalSpace), 0, height) text:i?downText:upText font:14.0f tag:i+1];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [label sizeToFit];
            CGRect frame = label.frame;
            if( frame.size.width>width ){
                frame.size.width = width;
            }
            frame.origin.x = (button.bounds.size.width-frame.size.width)/2.0f;
            label.frame = frame;
            [button addSubview:label];
        }
    }
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame contentImage:(UIImage *)image selectedContentImage:(UIImage *)selectedImage target:(id)target action:(SEL)action{
    UIButton *button = [self buttonWithFrame:frame backNormalImage:nil backSelectedImage:nil contentImage:image target:target action:action];
    if( selectedImage ){
        [button setImage:selectedImage forState:UIControlStateSelected];
    }
    return button;
}

@end

@implementation UIImage (SYImage)

- (UIImage*)imageByCropping:(CGRect)rect
{
    //create a context to do our clipping in
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //create a rect with the size we want to crop the image to
    //the X and Y here are zero so we start at the beginning of our
    //newly created context
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect( currentContext, clippedRect);
    
    //create a rect equivalent to the full size of the image
    //offset the rect by the X and Y we want to start the crop
    //from in order to cut off anything before them
    CGRect drawRect = CGRectMake(rect.origin.x * -1,
                                 rect.origin.y * -1,
                                 self.size.width,
                                 self.size.height);
    
    //draw the image to our clipped context using our offset rect
    CGContextDrawImage(currentContext, drawRect, self.CGImage);
    
    //pull the image from our cropped context
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    //Note: this is autoreleased
    return cropped;
}

@end

@implementation UIImageView (SYImageView)

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image contentMode:(UIViewContentMode)mode
{
    if( self = [super init] ){
        self.frame = frame;
        self.image = image;
        self.contentMode = mode;
        self.clipsToBounds = YES;
    }
    return self;
}

@end

@implementation UITextField (SYTextField)

+(UITextField *)textFieldWithFrame:(CGRect)frame leftImage:(UIImage *)image placeHolder:(NSString *)holder security:(BOOL)isSecurity delegate:(id)target
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.delegate = target;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if( isSecurity ){
        textField.secureTextEntry = YES;
    }
    textField.placeholder = holder;
    if( image ){
        textField.leftView = [[UIImageView alloc] initWithImage:image];
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return textField;
}

@end

@implementation UITextView (SYTextView)

+(UITextView *)textViewWithFrame:(CGRect)frame delegate:(id<UITextViewDelegate>)target text:(NSString *)text textColor:(UIColor *)color fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment editable:(BOOL)editable{
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.delegate = target;
    textView.text = text;
    textView.textColor = color;
    textView.font = [UIFont systemFontOfSize:fontSize];
    textView.textAlignment = textAlignment;
    textView.editable = NO;
    return textView;
}

@end

@implementation UIAlertController (SYAlertController)

+(UIAlertController *_Nullable)showAlertWithStyle:(UIAlertControllerStyle)style
                                            title:(NSString *_Nullable)title
                                          message:(NSString *_Nullable)msg
                                 firstActionTitle:(NSString *_Nullable)leftActionTitle
                                secondActionTitle:(NSString *_Nullable)rightActionTitle
                                     firstHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))leftHandler
                                    secondHandler:(void (^ __nullable)(UIAlertAction *_Nullable action))rightHandler;
{
    UIAlertAction *leftAction = nil;
    UIAlertAction *rightAction = nil;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    
    if( leftActionTitle ){
        leftAction = [UIAlertAction actionWithTitle:leftActionTitle style:UIAlertActionStyleDefault handler:leftHandler];
        [alert addAction:leftAction];
    }

    if( rightActionTitle ){
        rightAction = [UIAlertAction actionWithTitle:rightActionTitle style:UIAlertActionStyleDefault handler:rightHandler];
        [alert addAction:rightAction];
    }
    
    if( style == UIAlertControllerStyleAlert && leftActionTitle && rightActionTitle ){
    }else{
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }
    
    return alert;
}

//添加一下两个发放，是为了解决alertController在iOS9设备上弹出时，程序crash的bug
-(BOOL)shouldAutorotate{
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
@end



