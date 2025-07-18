//
//  SHTSubscriptionManager.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/18.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTSubscriptionManager : NSObject

+ (instancetype)sharedManager;
- (void)fetchProducts;
- (void)purchaseProduct:(SKProduct *)product;

@property (nonatomic, strong) NSArray<SKProduct *> *products;

@end

NS_ASSUME_NONNULL_END
