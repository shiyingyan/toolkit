//
//  SYKeyBoardObserver.h
//  AnItemForACar
//
//  Created by Shing on 7/9/16.
//  Copyright © 2016 Shing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYKeyboardObserverDelegate <NSObject>

@optional
-(void)keyboardWillShowWithAnimationCurve:(UIViewAnimationCurve)curve
                                duration:(NSTimeInterval)duration
                           keyboardFrame:(CGRect)keyboardFrame;

-(void)keyboardWillHideWithAnimationCurve:(UIViewAnimationCurve)curve
                                duration:(NSTimeInterval)duration
                           keyboardFrame:(CGRect)keyboardFrame;

-(void)keyboardDidShowWithAnimationCurve:(UIViewAnimationCurve)curve
                                 duration:(NSTimeInterval)duration
                            keyboardFrame:(CGRect)keyboardFrame;

-(void)keyboardDidHideWithAnimationCurve:(UIViewAnimationCurve)curve
                                 duration:(NSTimeInterval)duration
                            keyboardFrame:(CGRect)keyboardFrame;

//使用第三方输入法时，可以考虑调用此方法
-(void)keyboardDidChangeFrameWithAnimationCurve:(UIViewAnimationCurve)curve
                                       duration:(NSTimeInterval)duration
                                  keyboardFrame:(CGRect)keyboardFrame;

@end

@interface SYKeyboardObserver : NSObject

/**
 *  @author Shing, 16-08-24 11:08:55
 *
 *  @brief 设置delegate在viewWillAppear中设置，在viewWillDisappear中设置为nil
 */
@property (nonatomic,weak) id<SYKeyboardObserverDelegate> delegate;

@end
