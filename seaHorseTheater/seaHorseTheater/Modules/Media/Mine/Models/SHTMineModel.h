//
//  SHTMineModel.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SHTMineType) {
    SHTMineTypeHeader,
    SHTMineTypeMemberGuidance,
    SHTMineTypeCommon
};

@interface SHTMineModel : NSObject

@property (nonatomic, assign) SHTMineType mineType;
@property (nonatomic, copy) NSString *uniqueIdentifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;


- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
