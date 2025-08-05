//
//  SHTKeychainHelper.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 8/5/25.
//

#import "SHTKeychainHelper.h"
#import <Security/Security.h>

@implementation SHTKeychainHelper

+ (NSMutableDictionary *)keychainQueryForKey:(NSString *)key {
    return [@{
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService : key,
        (__bridge id)kSecAttrAccount : key,
        (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock
    } mutableCopy];
}

+ (void)saveBool:(BOOL)value forKey:(NSString *)key {
    NSMutableDictionary *query = [self keychainQueryForKey:key];
    SecItemDelete((__bridge CFDictionaryRef)query);

    NSData *data = [NSData dataWithBytes:&value length:sizeof(BOOL)];
    [query setObject:data forKey:(__bridge id)kSecValueData];

    SecItemAdd((__bridge CFDictionaryRef)query, NULL);
}

+ (BOOL)getBoolForKey:(NSString *)key {
    NSMutableDictionary *query = [self keychainQueryForKey:key];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];

    CFDataRef result = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result) == noErr) {
        NSData *data = (__bridge_transfer NSData *)result;
        if (data.length == sizeof(BOOL)) {
            BOOL value;
            [data getBytes:&value length:sizeof(BOOL)];
            return value;
        }
    }
    return NO;
}

+ (void)deleteValueForKey:(NSString *)key {
    NSMutableDictionary *query = [self keychainQueryForKey:key];
    SecItemDelete((__bridge CFDictionaryRef)query);
}

+ (BOOL)hasKey:(NSString *)key {
    NSMutableDictionary *query = [self keychainQueryForKey:key];
    query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanFalse;
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    return (status == errSecSuccess);
}

@end
