//
//  UIViewController+Directory_Swizzled.h
//  Directory_Swizzle
//
//  Created by 晓琳 on 17/8/4.
//  Copyright © 2017年 xiaolin.han. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SWIZZLEDDIRECTORY [UIViewController swizzledDirectory];

#define UN_SWIZZLEDDIRECTORY [UIViewController undoSwizzledDirectory];


@interface UIViewController (Directory_Swizzled)

+ (void)swizzledDirectory;

+ (void)undoSwizzledDirectory;

@end
