//
//  DJXPlayletInfoModel+SHTFavorite.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/8/14.
//

#import "DJXPlayletInfoModel+SHTFavorite.h"
#import <objc/runtime.h>

@implementation DJXPlayletInfoModel (Favorite)

static char kCoverImageKey;
static char kIsSelectedKey;
static char kIsFromFavoriteKey;

- (void)setCoverImage:(UIImage *)coverImage {
    objc_setAssociatedObject(self, &kCoverImageKey, coverImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)coverImage {
    return objc_getAssociatedObject(self, &kCoverImageKey);
}

- (void)setIsSelected:(BOOL)isSelected {
    objc_setAssociatedObject(self,
                             &kIsSelectedKey,
                             @(isSelected),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSelected {
    return [objc_getAssociatedObject(self, &kIsSelectedKey) boolValue];
}

- (void)setIsFromFavorite:(BOOL)isFromFavorite {
    objc_setAssociatedObject(self,
                             &kIsFromFavoriteKey,
                             @(isFromFavorite),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isFromFavorite {
    return [objc_getAssociatedObject(self, &kIsFromFavoriteKey) boolValue];
}

@end
