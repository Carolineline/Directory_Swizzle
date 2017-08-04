//
//  UIViewController+Directory_Swizzled.m
//  Directory_Swizzle
//
//  Created by 晓琳 on 17/8/4.
//  Copyright © 2017年 xiaolin.han. All rights reserved.
//

#import "UIViewController+Directory_Swizzled.h"
#import <objc/runtime.h>
@implementation UIViewController (Directory_Swizzled)

static BOOL isSwizzed;

+ (void)load {
    
    isSwizzed = NO;
}

static void swizzledDirectoryInstance(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

+ (void)swizzledDirectory {
    
    if (isSwizzed) {
        return;
    }
    
    swizzledDirectoryInstance([self class], @selector(viewDidAppear:), @selector(swizzledviewDidAppear:));
    isSwizzed = YES;
    
}

+ (void)undoSwizzledDirectory {
    
    if (!isSwizzed) {
        return;
    }
    isSwizzed = NO;
    swizzledDirectoryInstance([self class], @selector(swizzledviewDidAppear:), @selector(viewDidAppear:));
    
}

#pragma mark -- private 

- (void)swizzledviewDidAppear:(BOOL)animated {
    
    //do something
    [self printDirectoryPath];
    
    //Call the original method (viewWillAppear)
    [self swizzledviewDidAppear:animated];
}

- (void)printDirectoryPath {
    
    if ([self parentViewController]) {
        
        [self viewControllerWithLevel:0];
        
    } else if ([[self parentViewController] isMemberOfClass:[UINavigationController class]]) {
        
        UINavigationController *naVC = (UINavigationController *)[self presentationController];
        NSInteger level = [[naVC viewControllers] indexOfObject:self];
        [self viewControllerWithLevel:level];
    
    } else if ([[self presentationController] isMemberOfClass:[UITabBarController class]]) {
        
        [self viewControllerWithLevel:1];
        
    }
}

- (void)viewControllerWithLevel:(NSInteger)level {
    
    NSString *str = [NSString stringWithFormat:@"----%ld----%@",level,[self.class description]];
    NSLog(@"%@",str);
}


@end
