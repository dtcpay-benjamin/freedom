//
//  SHTFavoritePlayletModel.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/1.
//

#import "SHTFavoritePlayletModel.h"

@implementation SHTFavoritePlayletModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
