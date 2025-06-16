//
//  SHTMemberModel.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/6/16.
//

#import "SHTMemberModel.h"

@implementation SHTMemberModel

+ (SHTMemberModel *)modelWithMemberType:(SHTMemberType)memberType amount:(double)amount originalAmount:(double)originalAmount currency:(NSString *)currency{
    SHTMemberModel *model = [[SHTMemberModel alloc] init];
    model.memberType = memberType;
    NSString *title = @"";
    double average = 0.0;
    switch (memberType) {
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
    model.showAmount = [NSString stringWithFormat:@"%@%f", currency, amount];
    
    NSString *fullText = [NSString stringWithFormat:@"%@%f", currency, originalAmount];
    NSDictionary *attributes = @{
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: [UIColor grayColor],
    };
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:fullText attributes:attributes];
    model.showOriginalAmount = attrStr;
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
