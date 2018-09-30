//
//  Toast.h
//  MJDamageAssessmentKit
//
//  Created by Shing on 02/06/2017.
//  Copyright © 2017 Data Enlighten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYToast : NSObject

+ (void)showMessage:(NSString *)message;

+ (void)showErrorMessage:(NSString *)message;

@end
