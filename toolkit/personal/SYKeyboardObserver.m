//
//  SYKeyBoardObserver.m
//  AnItemForACar
//
//  Created by Shing on 7/9/16.
//  Copyright © 2016 Shing. All rights reserved.
//

#import "SYKeyboardObserver.h"

static int extensionKeyboardNotificationTimes = 0;  //第三方键盘调用通知的次数

@implementation SYKeyboardObserver

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    return self;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];

    if( [self.delegate respondsToSelector:@selector(keyboardWillShowWithAnimationCurve:duration:keyboardFrame:)] ){
        [self.delegate keyboardWillShowWithAnimationCurve:animationCurve duration:animationDuration keyboardFrame:keyboardFrame];
    }
}
-(void)keyboardWillHide:(NSNotification *)notification{
    extensionKeyboardNotificationTimes = 0;
    
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];

    if( [self.delegate respondsToSelector:@selector(keyboardWillHideWithAnimationCurve:duration:keyboardFrame:)] ){
        [self.delegate keyboardWillHideWithAnimationCurve:animationCurve duration:animationDuration keyboardFrame:keyboardFrame];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    if( [self.delegate respondsToSelector:@selector(keyboardDidShowWithAnimationCurve:duration:keyboardFrame:)] ){
        [self.delegate keyboardDidShowWithAnimationCurve:animationCurve duration:animationDuration keyboardFrame:keyboardFrame];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    extensionKeyboardNotificationTimes = 0;
    
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    if( [self.delegate respondsToSelector:@selector(keyboardDidHideWithAnimationCurve:duration:keyboardFrame:)] ){
        [self.delegate keyboardDidHideWithAnimationCurve:animationCurve duration:animationDuration keyboardFrame:keyboardFrame];
    }
}


- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    
    if( ++extensionKeyboardNotificationTimes < 3 ) return;

    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    if( [self.delegate respondsToSelector:@selector(keyboardDidChangeFrameWithAnimationCurve:duration:keyboardFrame:)] ){
        [self.delegate keyboardDidChangeFrameWithAnimationCurve:animationCurve duration:animationDuration keyboardFrame:keyboardFrame];
    }

}
@end
