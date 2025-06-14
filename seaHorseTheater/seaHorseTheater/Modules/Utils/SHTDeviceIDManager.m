//
//  SHTDeviceIDManager.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import "SHTDeviceIDManager.h"

@implementation SHTDeviceIDManager

+ (NSString *)getDeviceID {
    NSString *service = @"com.hujiaofen.seaHorseTheaterasa";
    NSString *account = @"unique_device_id";

    NSString *existingID = [self loadFromKeychainWithService:service account:account];
    if (existingID) {
        return existingID;
    } else {
        NSString *newID = [[NSUUID UUID] UUIDString];
        [self saveToKeychainWithService:service account:account value:newID];
        return newID;
    }
}

+ (void)saveToKeychainWithService:(NSString *)service account:(NSString *)account value:(NSString *)value {
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: service,
        (__bridge id)kSecAttrAccount: account
    };
    
    SecItemDelete((__bridge CFDictionaryRef)query); // 删除旧值
    
    NSDictionary *attributes = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: service,
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecValueData: data
    };
    
    SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
}

+ (NSString *)loadFromKeychainWithService:(NSString *)service account:(NSString *)account {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: service,
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecReturnData: @YES,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne
    };
    
    CFDataRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    
    if (status == errSecSuccess && result != NULL) {
        NSData *data = (__bridge_transfer NSData *)result;
        NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return value;
    }
    
    return nil;
}

@end
