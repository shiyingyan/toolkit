//
//  UIViewController+SYViewController.h
//  DingDing
//
//  Created by Shing on 8/24/15.
//  Copyright (c) 2015 Cstorm. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 storyBoard相关
 */
@interface UIViewController (UIStoryboard)

+(UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
                                      fromStoryboardWithName:(NSString *)storyboardName;
@end



@interface UIViewController (ChildController)

/**
 *  当前controller上添加子控制器childCotnroller
 */
-(void)addChildController:(UIViewController *)childController;

- (void)addChildController:(UIViewController *)childController viewFrame:(CGRect)frame;

/**
 *  删除当前controller上的子控制器childController
 */
-(void)removeChildController:(UIViewController *)childController;

- (void)removeFromParentController;

#pragma mark

/**
 删除所有子控制器
 */
- (void)removeAllChildController;

@end

