//
//  SHTStringFormatter.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, StringCaseOption) {
    StringCaseOptionOriginal,
    StringCaseOptionUppercase,
    StringCaseOptionLowercase
};

@interface SHTStringFormatter : NSObject

/// 提取字符串前/后若干位并转为指定大小写
/// @param input 原始字符串
/// @param fromStart 是否从开头截取（YES）或从结尾截取（NO）
/// @param length 要提取的长度
/// @param caseOption 大小写设置：原样、全大写、全小写
+ (NSString *)formatString:(NSString *)input
                 fromStart:(BOOL)fromStart
                    length:(NSUInteger)length
                caseOption:(StringCaseOption)caseOption;

@end

NS_ASSUME_NONNULL_END
