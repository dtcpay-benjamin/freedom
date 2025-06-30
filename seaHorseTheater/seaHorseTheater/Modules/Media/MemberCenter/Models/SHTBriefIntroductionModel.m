//
//  SHTBriefIntroductionModel.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/6/30.
//

#import "SHTBriefIntroductionModel.h"

@implementation SHTBriefIntroductionModel

+ (SHTBriefIntroductionModel *)modelWithTitle:(NSString *)title activateVip:(double)isActivateVip {
    SHTBriefIntroductionModel *model = [[SHTBriefIntroductionModel alloc] init];
    model.title = title;
    model.isActivateVip = isActivateVip;
    if (isActivateVip) {
        model.subtitle = @"已开通VIP";
    } else {
        model.subtitle = @"暂未开通VIP";
    }
    return model;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
