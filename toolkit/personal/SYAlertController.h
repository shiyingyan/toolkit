//
//  SYAlertController.h
//  AnItemForACar
//
//  Created by Shing on 7/9/16.
//  Copyright © 2016 Shing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionHandler)(UITextField *textField,UIButton *sender);

@interface SYAlertController : UIViewController

-(BOOL)showAlertInContainerController:(UIViewController *)containerController
                                title:(NSString *)title
                  textPlaceHolder:(NSString *)placeHolder
                            message:(NSString *)msg
                    leftActionTitle:(NSString *)leftActionTitle
                   rightActionTitle:(NSString *)rightActionTitle
                  leftActionHandler:(ActionHandler)leftHandler
                 rightActionHandler:(ActionHandler)rightHandler;

@end
