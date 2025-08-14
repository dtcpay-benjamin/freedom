//
//  DJXPlayletInfoModel+Favorite.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/8/14.
//

#import "DJXPlayletInfoModel+Favorite.h"
#import <objc/runtime.h>

@implementation DJXPlayletInfoModel (Favorite)

static char kCoverImageKey;

- (void)setCoverImage:(UIImage *)coverImage {
    objc_setAssociatedObject(self, &kCoverImageKey, coverImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)coverImage {
    return objc_getAssociatedObject(self, &kCoverImageKey);
}

@end
