//
//  SHTLanguageUtil.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 8/17/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LanguageType) {
    LanguageZH_CN,
    LanguageZH_TW,
    LanguageEN,
    LanguageJA,
    LanguageKO
};

@interface SHTLanguageUtil : NSObject

+ (LanguageType)fetchCurrentLanguageType;

+ (NSString *)fetchMembershipServiceAgreementUrl;

+ (NSString *)fetchPrivacyPolicyUrl;

@end

NS_ASSUME_NONNULL_END
