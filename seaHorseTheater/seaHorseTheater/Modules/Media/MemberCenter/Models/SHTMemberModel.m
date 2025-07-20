//
//  SHTMemberModel.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/6/16.
//

#import "SHTMemberModel.h"
#import <StoreKit/StoreKit.h>

@implementation SHTMemberModel

+ (SHTMemberModel *)modelWithId:(NSString *)id  amount:(double)amount originalAmount:(double)originalAmount currency:(NSString *)currency product:(SKProduct *)product {
    SHTMemberModel *model = [[SHTMemberModel alloc] init];
    if([id isEqualToString:@"com.seaHorseTheater.app.subscription.week"]) {
        model.memberType = SHTMemberTypeWeeklySubscription;
    } else if([id isEqualToString:@"com.seaHorseTheater.app.subscription.month"]) {
        model.memberType = SHTMemberTypeMonthlySubscription;
    } else if([id isEqualToString:@"com.seaHorseTheater.app.subscription.year"]) {
        model.memberType = SHTMemberTypeAnnualSubscription;
    }
    model.id = id;
    NSString *title = @"";
    double average = 0.0;
    switch (model.memberType) {
        case SHTMemberTypeWeeklySubscription:
            title = @"连续包周";
            average = amount / 7;
            break;
        case SHTMemberTypeMonthlySubscription:
            title = @"连续包月";
            average = amount / 30;
            break;
        case SHTMemberTypeAnnualSubscription:
            title = @"连续包年";
            average = amount / 365;
            break;
        default:
            break;
    }
    model.title = title;
    model.subtitle = [NSString stringWithFormat:@"低至%.2f%@/天", average, currency];
    model.amount = amount;
    model.originalAmount = originalAmount;
    model.currency = currency;
    model.showAmount = [NSString stringWithFormat:@"%@%ld", currency, (long)amount];
    
    NSString *fullText = [NSString stringWithFormat:@"%@%ld", currency, (long)originalAmount];
    NSDictionary *attributes = @{
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: [UIColor grayColor],
    };
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:fullText attributes:attributes];
    model.showOriginalAmount = attrStr;
    model.product = product;
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
