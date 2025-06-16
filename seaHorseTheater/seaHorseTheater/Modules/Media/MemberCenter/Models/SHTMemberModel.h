//
//  SHTMemberModel.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SHTMemberType) {
    SHTMemberTypeWeeklySubscription,
    SHTMemberTypeMonthlySubscription,
    SHTMemberTypeAnnualSubscription
};

@interface SHTMemberModel : NSObject

@property (nonatomic, assign) SHTMemberType memberType;
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *subtitle; // 副标题
@property (nonatomic, assign) double amount; // 金额
@property (nonatomic, assign) double originalAmount; // 原金额
@property (nullable, copy) NSString *currency; // 货币类型
@property (nonatomic, copy) NSString *showAmount; // 展示额度
@property (nonatomic, copy) NSAttributedString *showOriginalAmount; // 展示原额度

+ (SHTMemberModel *)modelWithMemberType:(SHTMemberType)memberType amount:(double)amount originalAmount:(double)originalAmount currency:(NSString *)currency;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
