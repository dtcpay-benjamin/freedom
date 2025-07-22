//
//  SHTTableViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/22.
//

#import "SHTTableViewCell.h"

@implementation SHTTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
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
