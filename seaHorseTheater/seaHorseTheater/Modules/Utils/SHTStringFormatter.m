//
//  SHTStringFormatter.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import "SHTStringFormatter.h"

@implementation SHTStringFormatter

+ (NSString *)formatString:(NSString *)input
                 fromStart:(BOOL)fromStart
                    length:(NSUInteger)length
                caseOption:(StringCaseOption)caseOption
{
    if (input.length < length) {
        return nil;
    }

    NSString *subString;
    if (fromStart) {
        subString = [input substringToIndex:length];
    } else {
        subString = [input substringFromIndex:input.length - length];
    }

    switch (caseOption) {
        case StringCaseOptionUppercase:
            return [subString uppercaseString];
        case StringCaseOptionLowercase:
            return [subString lowercaseString];
        default:
            return subString;
    }
}

@end
