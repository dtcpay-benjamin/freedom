//
//  SHTFavoritePlayletModel.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTFavoritePlayletModel : NSObject

@property (nonatomic, assign) bool isSelected;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
