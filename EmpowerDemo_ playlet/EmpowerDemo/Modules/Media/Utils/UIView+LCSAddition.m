//
//  UIView+util.m
//  DJXSamples
//
//  Created by iCuiCui on 2020/7/29.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "UIView+LCSAddition.h"
#import <objc/runtime.h>

void lcs_objc_setWeakAssociatedObject(id _Nonnull object, const void * _Nonnull key, id _Nullable value) {
    id __weak weakValue = value;
    id (^block)(void) = ^{ return weakValue; };
    objc_setAssociatedObject(object, key,
                             block, OBJC_ASSOCIATION_COPY);
}

id _Nullable lcs_objc_getWeakAssociatedObject(id _Nonnull object, const void * _Nonnull key) {
    id (^block)(void) = objc_getAssociatedObject(object, key);
    return (block ? block() : nil);
}

@implementation UIView (LCSAddition)

- (UIViewController *)relatedViewController {
    return lcs_objc_getWeakAssociatedObject(self, @selector(relatedViewController));
}

- (void)setRelatedViewController:(UIViewController *)relatedViewController {
    lcs_objc_setWeakAssociatedObject(self, @selector(relatedViewController), relatedViewController);
}

@end
