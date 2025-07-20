//
//  SHTSubscriptionManager.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SKProduct;

@interface SHTSubscriptionManager : NSObject

@property (nonatomic, strong) NSArray<SKProduct *> *products;
+ (instancetype)sharedManager;
- (void)loadProducts;
- (void)purchaseProduct:(SKProduct *)product;
- (BOOL)isSubscribed;

@property (nonatomic, strong) void (^productCallBack)(NSArray<SKProduct *> *products); // 商品信息回调


@end

NS_ASSUME_NONNULL_END
