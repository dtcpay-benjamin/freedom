//
//  SHTBriefIntroductionModel.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTBriefIntroductionModel : NSObject

@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, assign) BOOL isActivateVip; // 是否开通vip
@property (nonatomic, copy) NSString *subtitle; // 副标题

+ (SHTBriefIntroductionModel *)modelWithTitle:(NSString *)title activateVip:(double)isActivateVip;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
