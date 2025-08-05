//
//  SHTKeychainHelper.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 8/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTKeychainHelper : NSObject

// 存bool数据到钥匙串
+ (void)saveBool:(BOOL)value forKey:(NSString *)key;

// 从钥匙串获取bool数据
+ (BOOL)getBoolForKey:(NSString *)key;

// 删除某数据
+ (void)deleteValueForKey:(NSString *)key;

// 判断某数据是否存过
+ (BOOL)hasKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
