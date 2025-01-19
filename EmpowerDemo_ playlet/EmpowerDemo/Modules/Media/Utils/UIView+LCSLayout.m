//
//  UIView+layout.m
//  DeliverManager
//
//  Created by wangqiwei on 2018/10/23.
//  Copyright © 2018 com.bytedance. All rights reserved.
//

#import "UIView+LCSLayout.h"

@implementation UIView (DJXLayout)

- (CGFloat)lcs_left {
    return self.frame.origin.x;
}

- (void)setLcs_left:(CGFloat)lcs_left {
    CGRect frame = self.frame;
    frame.origin.x = lcs_left;
    self.frame = frame;
}

- (CGFloat)lcs_top {
    return self.frame.origin.y;
}

- (void)setLcs_top:(CGFloat)lcs_top {
    CGRect frame = self.frame;
    frame.origin.y = lcs_top;
    self.frame = frame;
}

- (CGFloat)lcs_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setLcs_right:(CGFloat)lcs_right {
    CGRect frame = self.frame;
    frame.origin.x = lcs_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)lcs_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLcs_bottom:(CGFloat)lcs_bottom {
    CGRect frame = self.frame;
    frame.origin.y = lcs_bottom - frame.size.height;
    self.frame = frame;
}

- (CGPoint)lcs_origin {
    return self.frame.origin;
}

- (void)setLcs_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setLcs_originX:(CGFloat)originX {
    [self setLcs_origin:CGPointMake(originX, self.lcs_originY)];
}

- (CGFloat)lcs_originX {
    return self.lcs_origin.x;
}

- (void)setLcs_originY:(CGFloat)originY {
    [self setLcs_origin:CGPointMake(self.lcs_originX, originY)];
}

- (CGFloat)lcs_originY {
    return self.lcs_origin.y;
}

- (CGSize)lcs_size {
    return self.frame.size;
}

- (void)setLcs_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)lcs_width {
    return self.frame.size.width;
}

- (void)setLcs_width:(CGFloat)lcs_width {
    CGRect frame = self.frame;
    frame.size.width = lcs_width;
    self.frame = frame;
}

- (CGFloat)lcs_height {
    return self.frame.size.height;
}

- (void)setLcs_height:(CGFloat)lcs_height {
    CGRect frame = self.frame;
    frame.size.height = lcs_height;
    self.frame = frame;
}

- (CGPoint)lcs_center {
    return CGPointMake(self.lcs_centerX, self.lcs_centerY);
}

- (void)setLcs_center:(CGPoint)lcs_center {
    self.center = lcs_center;
}

- (CGFloat)lcs_centerX {
    return self.center.x;
}

- (void)setLcs_centerX:(CGFloat)lcs_centerX {
    self.center = CGPointMake(lcs_centerX, self.center.y);
}

- (CGFloat)lcs_centerY {
    return self.center.y;
}

- (void)setLcs_centerY:(CGFloat)lcs_centerY {
    self.center = CGPointMake(self.center.x, lcs_centerY);
}

- (CGFloat)lcs_screenX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.lcs_left;
    }
    return x;
}

- (CGFloat)lcs_screenY {
    CGFloat y = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        y += view.lcs_top;
    }
    return y;
}


@end
