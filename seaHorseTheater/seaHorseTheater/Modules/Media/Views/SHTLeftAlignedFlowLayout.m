//
//  SHTLeftAlignedFlowLayout.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/29.
//

#import "SHTLeftAlignedFlowLayout.h"

@implementation SHTLeftAlignedFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat leftMargin = self.sectionInset.left;
    CGFloat maxY = -1.0f;
    
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        if (attr.representedElementCategory == UICollectionElementCategoryCell) {
            if (attr.frame.origin.y >= maxY) {
                leftMargin = self.sectionInset.left; // 新行
            }
            CGRect frame = attr.frame;
            frame.origin.x = leftMargin;
            attr.frame = frame;
            leftMargin += frame.size.width + self.minimumInteritemSpacing;
            maxY = MAX(CGRectGetMaxY(attr.frame), maxY);
        }
    }
    return attributes;
}

@end
