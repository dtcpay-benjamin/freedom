//
//  SHTLanguageUtil.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 8/17/25.
//

#import "SHTLanguageUtil.h"

@implementation SHTLanguageUtil

+ (LanguageType)fetchCurrentLanguageType {
    NSString *currentLanguageCode = [[NSLocale preferredLanguages] firstObject];
    LanguageType language;
    if ([currentLanguageCode hasPrefix:@"zh-Hans"]) {
        language = LanguageZH_CN; // 简体中文
    } else if ([currentLanguageCode hasPrefix:@"zh-Hant"]) {
        language = LanguageZH_TW; // 繁体中文
    } else if ([currentLanguageCode hasPrefix:@"en"]) {
        language = LanguageEN; // 英文
    } else if ([currentLanguageCode hasPrefix:@"ja"]) {
        language = LanguageJA; // 日文
    } else if ([currentLanguageCode hasPrefix:@"ko"]) {
        language = LanguageKO; // 韩文
    } else {
        language = LanguageEN; // 默认英文
    }
    return language;
}

+ (NSString *)fetchMembershipServiceAgreementUrl {
    LanguageType languageType = [SHTLanguageUtil fetchCurrentLanguageType];
    NSString *urlStr = @"membershipServiceAgreement_en";
    switch (languageType) {
        case LanguageZH_CN:
            urlStr = @"membershipServiceAgreement_zh";
            break;
        case LanguageZH_TW:
            urlStr = @"membershipServiceAgreement_zh-Hant";
            break;
        case LanguageJA:
            urlStr = @"membershipServiceAgreement_ja";
            break;
        case LanguageKO:
            urlStr = @"membershipServiceAgreement_ko";
            break;
        case LanguageEN:
        default:
            break;
    }
    return urlStr;
}

+ (NSString *)fetchPrivacyPolicyUrl {
    LanguageType languageType = [SHTLanguageUtil fetchCurrentLanguageType];
    NSString *urlStr = @"privacyPolicy_en";
    switch (languageType) {
        case LanguageZH_CN:
            urlStr = @"privacyPolicy_zh";
            break;
        case LanguageZH_TW:
            urlStr = @"privacyPolicy_zh-Hant";
            break;
        case LanguageJA:
            urlStr = @"privacyPolicy_ja";
            break;
        case LanguageKO:
            urlStr = @"privacyPolicy_ko";
            break;
        case LanguageEN:
        default:
            break;
    }
    return urlStr;
}

@end
