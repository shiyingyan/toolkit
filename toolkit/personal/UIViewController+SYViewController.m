//
//  UIViewController+SYViewController.m
//  DingDing
//
//  Created by Shing on 8/24/15.
//  Copyright (c) 2015 Cstorm. All rights reserved.
//

#import "UIViewController+SYViewController.h"
#import "SYTool.h"

/**
 storyboard相关
 */
@implementation UIViewController (UIStoryboard)

+(UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
                                      fromStoryboardWithName:(NSString *)storyboardName
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:[SYTool resourceBundle]];
    NSAssert(sb, @"没有相应的storyboard文件");
    return [sb instantiateViewControllerWithIdentifier:identifier];
}
@end


@implementation UIViewController (ChildController)

#if 0

static CGFloat animationDuration = 0.3f;

/**
 *  当前controller上添加子控制器childCotnroller
 */
-(void)addChildController:(UIViewController *)childController{
    DDLog(@"%s,%@",__FUNCTION__,childController);
    //弹出的页面，不能手动滑动返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
   
    //添加childController
    childController.view.alpha = 0.0;
    [UIView animateWithDuration:animationDuration animations:^{
        childController.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        UIViewController *controller = self.navigationController?self.navigationController:self;
        [controller addChildViewController:childController];
        childController.view.frame = controller.view.bounds;
        [controller.view addSubview:childController.view];
        [childController didMoveToParentViewController:controller];
    }];
}
/**
 *  删除当前controller上的子控制器childController
 */
-(void)removeChildController:(UIViewController *)childController{
    DDLog(@"%s,%@",__FUNCTION__,childController);
    //弹出的页面关闭时，恢复手动滑动返回功能
    UINavigationController *nav = (UINavigationController *)(self.navigationController?self.navigationController:self);
    nav.interactivePopGestureRecognizer.enabled = YES;
    
    //删除childController
    [UIView animateWithDuration:animationDuration animations:^{
        childController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [childController willMoveToParentViewController:nil];
        [childController.view removeFromSuperview];
        [childController removeFromParentViewController];
    }];
}

#else

/**
 *  当前controller上添加子控制器childCotnroller
 */
-(void)addChildController:(UIViewController *)childController{
    [self addChildController:childController viewFrame:self.view.bounds];
}

- (void)addChildController:(UIViewController *)childController viewFrame:(CGRect)frame {
    //弹出的页面，不能手动滑动返回
    UINavigationController *nav = (UINavigationController *)(self.navigationController?self.navigationController:self);
    if ([nav respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        nav.interactivePopGestureRecognizer.enabled = NO;
    }
    //添加childController
    [self addChildViewController:childController];
    childController.view.frame = frame;
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

/**
 *  删除当前controller上的子控制器childController
 */
-(void)removeChildController:(UIViewController *)childController{
    //弹出的页面关闭时，恢复手动滑动返回功能
    UINavigationController *nav = (UINavigationController *)(self.navigationController?self.navigationController:self);
    nav.interactivePopGestureRecognizer.enabled = YES;
    
    //删除childController
    [childController willMoveToParentViewController:nil];
    [childController.view removeFromSuperview];
    [childController removeFromParentViewController];
}

- (void)removeFromParentController{
    //弹出的页面关闭时，恢复手动滑动返回功能
    UIViewController *parentController = self.parentViewController;
    [parentController removeChildController:self];
}

#pragma mark
- (void)removeAllChildController {
    for (UIViewController *childController in self.childViewControllers) {
        [self removeChildController:childController];
    }
}

#endif



@end
