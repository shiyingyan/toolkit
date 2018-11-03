//
//  Toast.m
//  MJDamageAssessmentKit
//
//  Created by Shing on 02/06/2017.
//  Copyright © 2017 Shing. All rights reserved.
//

#import "SYToast.h"
#import "SYTool.h"

@implementation SYToast

+ (void)showMessage:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UILabel *alertLabel = (UILabel *)[window viewWithTag:5000000];
    CGFloat fontSize = 14.0f;
    if( alertLabel ){
        [alertLabel removeFromSuperview];
        alertLabel = nil;
    }
    
    alertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    alertLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    alertLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    alertLabel.layer.cornerRadius = 3;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.tag = 5000000;
    alertLabel.numberOfLines = 0;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = [UIFont systemFontOfSize:fontSize];
    [window addSubview:alertLabel];
    alertLabel.text = message;
    [alertLabel sizeToFit];
    
    if( message && message.length ){
        CGRect frame = alertLabel.frame;
        if( frame.size.width >  window.bounds.size.width-50 ){
            frame.size.width = window.bounds.size.width-50;
        }else{
            frame.size.width += 20;
        }
        frame.size.height = [message boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.height+15;
        frame.origin.x = (window.bounds.size.width-frame.size.width)/2.0f;
        frame.origin.y = window.bounds.size.height-frame.size.height-80;
        alertLabel.frame = frame;
    }
    
    [alertLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3.0f];
}

+ (void)showErrorMessage:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *errorContainerView = [window viewWithTag:5000000];
    if( errorContainerView ) {
        [errorContainerView removeFromSuperview];
        errorContainerView = nil;
    }
    
    CGFloat horizontal_offset = 10;
    CGFloat vehicle_offset = 10;
    
    CGFloat containerView_MaxWidth = window.bounds.size.width - 50;
    
    CGFloat msglabel_maxWidth = containerView_MaxWidth - horizontal_offset*2;
    
    errorContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    errorContainerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    errorContainerView.layer.cornerRadius = 3;
    errorContainerView.layer.masksToBounds = YES;
    errorContainerView.tag = 5000000;
    [window addSubview:errorContainerView];
    
    
    UIImage *image = [SYTool loadImageFromLocalWithName:@"error"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.backgroundColor = [UIColor clearColor];
    [errorContainerView addSubview:imageView];
    
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    alertLabel.numberOfLines = 0;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = font;
    alertLabel.text = message;
    [alertLabel sizeToFit];
    [errorContainerView addSubview:alertLabel];

    if( message && message.length ){
        CGRect frame = alertLabel.frame;
        if( frame.size.width >  msglabel_maxWidth ){
            frame.size.width = msglabel_maxWidth;
        }else{
            frame.size.width += horizontal_offset*2;
        }
        frame.size.height = [message boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height+15;
        
        CGRect errorContainerFrame = CGRectZero;
        errorContainerFrame.size.width = frame.size.width+horizontal_offset*2;
        errorContainerFrame.size.height = frame.size.height+vehicle_offset*2+image.size.height+5;
        errorContainerFrame.origin.x = (window.frame.size.width - errorContainerFrame.size.width)/2.0f;
        errorContainerFrame.origin.y = (window.frame.size.height - errorContainerFrame.size.height)/2.0f;
        errorContainerView.frame = errorContainerFrame;
        
        imageView.frame = CGRectMake((errorContainerFrame.size.width-image.size.width)/2.0f, vehicle_offset, image.size.width, image.size.height);
        
        frame.origin.x = (errorContainerFrame.size.width-frame.size.width)/2.0f;
        frame.origin.y = imageView.frame.size.height+imageView.frame.origin.y+5;
        
        alertLabel.frame = frame;
    }
    
    [errorContainerView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3.0f];
    
}
@end
