//
//  UIView+Draw.m
//  BUAdSDKDemo
//
//  Created by bytedance on 2020/3/10.
//  Copyright © 2020年 bytedance. All rights reserved.
//
#import "UIView+SHT.h"

@implementation UIView (SHT)

- (CGFloat)left { return self.frame.origin.x; }
- (CGFloat)right { return CGRectGetMaxX(self.frame); }
- (CGFloat)top { return self.frame.origin.y; }
- (CGFloat)bottom { return CGRectGetMaxY(self.frame); }
- (CGFloat)width { return self.frame.size.width; }
- (CGFloat)height { return self.frame.size.height; }
- (CGPoint)origin { return self.frame.origin; }
- (CGSize)size { return self.frame.size; }

@end
