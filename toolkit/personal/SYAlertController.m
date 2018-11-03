//
//  SYAlertController.m
//  AnItemForACar
//
//  Created by Shing on 7/9/16.
//  Copyright © 2016 Shing. All rights reserved.
//

#import "SYAlertController.h"
#import "SYKeyboardObserver.h"
#import "Masonry.h"
#import "UIViewController+SYViewController.h"
#import "SYBaseView.h"

#define MJ_AppMainColor [UIColor colorWithRed:158 green:158 blue:158 alpha:0]

@interface SYAlertController ()<UITextFieldDelegate,SYKeyboardObserverDelegate>{
    UIViewController *_containerController;
    BOOL keyboardWillShow;
    BOOL keyboardWillHide;
    CGFloat containerViewOffsetWhenKeyboardShow;
}

@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel *msgLabel;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,copy) ActionHandler leftHandler;
@property (nonatomic,copy) ActionHandler rightHandler;

@property (nonatomic,strong) SYKeyboardObserver *keyboardObserver;

@end

@implementation SYAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.8f];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.keyboardObserver.delegate = self;
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.keyboardObserver.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    if( keyboardWillHide ){
        
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(@300);
            make.height.equalTo(@130);
        }];
        
    }else if (keyboardWillShow ){
        
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(-1*self->containerViewOffsetWhenKeyboardShow);
            make.width.equalTo(@300);
            make.height.equalTo(@130);
        }];
        
    }else{
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(@300);
            make.height.equalTo(@130);
        }];
        
        if( _titleLabel ) {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_greaterThanOrEqualTo(@50).priority(MASLayoutPriorityDefaultHigh);
                make.height.mas_greaterThanOrEqualTo(@20).priority(MASLayoutPriorityDefaultHigh);
                make.top.mas_equalTo(self.containerView).offset(10);
                make.centerX.mas_equalTo(self.containerView);
            }];
        }
        
        if( _textField ){
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.containerView).offset(10);
                make.leading.equalTo(self.containerView).offset(10);
                make.trailing.equalTo(self.containerView).offset(-10);
                make.height.equalTo(@40);
            }];
        }
        
        if( _msgLabel ){
            [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.containerView).offset(-10);
                make.centerX.mas_equalTo(self.containerView);
                make.width.mas_greaterThanOrEqualTo(@50).priority(MASLayoutPriorityDefaultHigh);
                make.height.mas_greaterThanOrEqualTo(@20).priority(MASLayoutPriorityDefaultHigh);
            }];
        }
        
        if( _leftBtn ){
            [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.containerView.mas_centerX).offset(-20);
                make.width.equalTo(@60);
                make.height.equalTo(@35);
                make.bottom.equalTo(self.containerView).offset(-5);
            }];
        }
        
        if( _rightBtn ){
            [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.containerView.mas_centerX).offset(20);
                make.width.equalTo(@60);
                make.height.equalTo(@35);
                make.bottom.equalTo(self.containerView).offset(-5);
            }];
        }
    }
    
    [super updateViewConstraints];
}

-(BOOL)showAlertInContainerController:(UIViewController *)containerController
                                title:(NSString *)title
                      textPlaceHolder:(NSString *)placeHolder
                              message:(NSString *)msg
                      leftActionTitle:(NSString *)leftActionTitle
                     rightActionTitle:(NSString *)rightActionTitle
                  leftActionHandler:(ActionHandler)leftHandler
                 rightActionHandler:(ActionHandler)rightHandler
{
    if( !containerController ){
        NSLog(@"containerController为空");
        return NO;
    }
        
    _containerController = containerController;
    
    if( title && title.length ) {
        self.titleLabel.text = title;
        self.titleLabel.hidden = NO;
    }else{
        self.titleLabel.hidden = YES;
    }
    
    if( placeHolder && placeHolder.length ){
        self.textField.placeholder = placeHolder;
        self.textField.hidden = NO;
    }else{
        self.textField.hidden = YES;
    }
    
    if( msg && msg.length ){
        self.msgLabel.text = msg;
        self.msgLabel.hidden = NO;
    }else{
        self.msgLabel.hidden = YES;
    }
    if( leftActionTitle && leftActionTitle.length ){
        self.leftBtn.hidden = NO;
        [self.leftBtn setTitle:leftActionTitle forState:UIControlStateNormal];
    }else{
        self.leftBtn.hidden = YES;
    }
    
    if( rightActionTitle && rightActionTitle.length ){
        self.rightBtn.hidden = NO;
        [self.rightBtn setTitle:rightActionTitle forState:UIControlStateNormal];
    }else{
        self.rightBtn.hidden = YES;
    }
    
    if( leftHandler ){
        self.leftHandler = leftHandler;
    }
    if( rightHandler ){
        self.rightHandler = rightHandler;
    }
    
    [containerController addChildController:self];
    
    return YES;
}

#pragma mark
-(void)btnClick:(UIButton *)sender{
    [_containerController removeChildController:self];
    if( sender == self.leftBtn ){
        if( self.leftHandler ){
            self.leftHandler(self.textField,sender);
        }
    }else if (sender == self.rightBtn ){
        if( self.rightHandler ){
            self.rightHandler(self.textField,sender);
        }
    }
}

#pragma mark

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark
-(UIView *)containerView{
    if( !_containerView ){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.borderWidth = 0.05f;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        [self.view addSubview:view];
        _containerView = view;
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if( !_titleLabel ) {
        _titleLabel = [UILabel labelWithFrame:CGRectZero text:@"温馨提示" font:15.0f tag:0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.containerView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UITextField *)textField{
    if( !_textField ){
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.font = [UIFont systemFontOfSize:12.0f];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.tintColor = MJ_AppMainColor ;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.delegate = self;
        _textField.layer.cornerRadius = 5;
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderColor = MJ_AppMainColor.CGColor;
        _textField.layer.borderWidth = 0.8f;
        [self.containerView addSubview:_textField];
    }
    return _textField;
}
-(UILabel *)msgLabel{
    if( !_msgLabel ){
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = [UIFont systemFontOfSize:12.0f];
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.numberOfLines = 0;
        [self.containerView addSubview:_msgLabel];
    }
    return _msgLabel;
}

-(UIButton *)leftBtn{
    if( !_leftBtn ){
        _leftBtn = [self buttonWithTitle:@"跳过"];
        _leftBtn.titleLabel.textColor = [UIColor lightGrayColor];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.containerView addSubview:_leftBtn];
    }
    return _leftBtn;
}
-(UIButton *)rightBtn{
    if( !_rightBtn ){
        _rightBtn = [self buttonWithTitle:@"确定"];
        _rightBtn.titleLabel.textColor = [UIColor whiteColor];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.containerView addSubview:_rightBtn];
    }
    return _rightBtn;
}
-(UIButton *)buttonWithTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = MJ_AppMainColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    return button;
}

-(void)keyboardWillShowWithAnimationCurve:(UIViewAnimationCurve)curve duration:(NSTimeInterval)duration keyboardFrame:(CGRect)keyboardFrame{
    keyboardWillShow = YES;
    keyboardWillHide = NO;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    UIView *inputView = self.containerView;
    CGFloat space = 64;
    if ( CGRectGetMaxY(inputView.frame)+space > CGRectGetMinY(keyboardFrame)) {
        CGFloat delta = CGRectGetMaxY(inputView.frame)+space - CGRectGetMinY(keyboardFrame);
        containerViewOffsetWhenKeyboardShow = delta;
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];

}
-(void)keyboardWillHideWithAnimationCurve:(UIViewAnimationCurve)curve duration:(NSTimeInterval)duration keyboardFrame:(CGRect)keyboardFrame{
    keyboardWillShow = NO;
    keyboardWillHide = YES;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

#pragma mark
-(SYKeyboardObserver *)keyboardObserver{
    if( !_keyboardObserver ){
        _keyboardObserver = [[SYKeyboardObserver alloc] init];
    }
    return _keyboardObserver;
}

#pragma mark 
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

-(BOOL)shouldAutorotate{
    return NO;
}

@end
