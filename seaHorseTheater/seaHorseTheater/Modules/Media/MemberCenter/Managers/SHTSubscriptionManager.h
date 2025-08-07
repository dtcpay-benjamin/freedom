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

@property (nonatomic, strong) void (^productCallBack)(NSArray<SKProduct *> *products); // 商品信息回调

+ (instancetype)sharedManager;

// 获取商品信息
- (void)loadProducts;

// 发起购买
- (void)purchaseProduct:(SKProduct *)product;

// 获取订阅状态
- (BOOL)isSubscribed;

// 检查当前用户订阅情况
- (void)checkSubscriptionStatus;

// 恢复权益(会员等)
- (void)restorePurchases;

@end

NS_ASSUME_NONNULL_END
