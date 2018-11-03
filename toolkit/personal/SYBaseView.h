//
//  YSYBaseView
//  WeChatLoginWithUMengDemo
//
//  Created by Shing on 11/6/14.
//  Copyright (c) 2014 Shing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYAnimationButton : UIButton

//设置显示动画
@property (nonatomic,assign) BOOL showAnimation;

@end

@interface SYBaseView : NSObject

@end

@interface UILabel (SYLabel)

+(UILabel * _Nullable)labelWithFrame:(CGRect)frame text:(NSString * _Nullable)text font:(CGFloat)font tag:(NSInteger)tag;

@end

@interface  UIButton (SYButton)

+(instancetype _Nullable)buttonWithFrame:(CGRect)frame title:(NSString * _Nullable)title titleNormalColor:(UIColor * _Nullable)color titleSelectedColor:(UIColor * _Nullable)color target:(id _Nullable)target action:(SEL _Nullable)action;
+(UIButton * _Nullable)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *_Nullable)normalImage backSelectedImage:(UIImage *_Nullable)selectedImage contentImage:(UIImage *_Nullable)contentImage;
+(UIButton *_Nullable)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *_Nullable)normalImage disabledImage:(UIImage *_Nullable)disabledImage;
+(UIButton *_Nullable)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *_Nullable)normalImage backSelectedImage:(UIImage *_Nullable)selectedImage;
+(UIButton *_Nullable)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *_Nullable)normalImage disabledImage:(UIImage *_Nullable)disabledImage target:(id _Nullable)target action:(SEL _Nullable)action;
+(UIButton *_Nullable)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *_Nullable)normalImage backSelectedImage:(UIImage *_Nullable)selectedImage target:(id _Nullable)target action:(SEL _Nullable)action;
+(UIButton *_Nullable)buttonWithFrame:(CGRect)frame backNormalImage:(UIImage *_Nullable)normalImage backSelectedImage:(UIImage *_Nullable)selectedImage contentImage:(UIImage *_Nullable)contentImage target:(id _Nullable)target action:(SEL _Nullable)action;
+(UIButton *_Nullable)buttonWithFrame:(CGRect)frame BackImage:(UIImage *_Nullable)image upText:(NSString *_Nullable)upText downText:(NSString *_Nullable)downText target:(id _Nullable)target action:(SEL _Nullable)action;
+ (UIButton *_Nullable)buttonWithFrame:(CGRect)frame
                          contentImage:(UIImage *_Nullable)image
                  selectedContentImage:(UIImage *_Nullable)selectedImage
                                target:(id _Nullable)target
                                action:(SEL _Nullable)action;
@end

@interface UIImage (SYImage)

//裁剪图片
- (UIImage*_Nullable)imageByCropping:(CGRect)rect;

@end

@interface UIImageView (SYImageView)

-(instancetype _Nullable)initWithFrame:(CGRect)frame image:(UIImage *_Nullable)image contentMode:(UIViewContentMode)mode;

@end

@interface UITextField (SYTextField)

+(UITextField *_Nullable)textFieldWithFrame:(CGRect)frame leftImage:(UIImage *_Nullable)image placeHolder:(NSString *_Nullable)holder security:(BOOL)isSecurity delegate:(id _Nullable)target;

@end

@interface UITextView (SYTextView)

+(UITextView *_Nullable)textViewWithFrame:(CGRect)frame delegate:(id<UITextViewDelegate>_Nullable)target text:(NSString *_Nullable)text textColor:(UIColor *_Nullable)color fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment editable:(BOOL)editable;

@end

@interface UIAlertController (SYAlertController)

+(UIAlertController *_Nullable)showAlertWithStyle:(UIAlertControllerStyle)style
                                            title:(NSString *_Nullable)title
                                          message:(NSString *_Nullable)msg
                                 firstActionTitle:(NSString *_Nullable)leftActionTitle
                                secondActionTitle:(NSString *_Nullable)rightActionTitle
                                     firstHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))leftHandler
                                    secondHandler:(void (^ __nullable)(UIAlertAction *_Nullable action))rightHandler;

@end
