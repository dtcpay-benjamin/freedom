//
//  SHTCollectionViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/22.
//

#import "SHTCollectionViewCell.h"

@implementation SHTCollectionViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self  addSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayoutSubviews];
}

- (void)addSubviews {
    
}

- (void)addLayoutSubviews {
    
}

@end
