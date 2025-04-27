//
//  SHTUserDefaults.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTUserDefaults : NSObject

+ (void)setObject:(id)value forKey:(NSString *)key;
+ (void)setInteger:(NSInteger)value forKey:(NSString *)key;
+ (void)setBool:(BOOL)value forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (NSInteger)integerForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
