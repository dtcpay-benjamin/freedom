//
//  SHTSubscriptionManager.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/18.
//

#import "SHTSubscriptionManager.h"
#import <StoreKit/StoreKit.h>
#import "SHTAppRateTool.h"

@interface SHTSubscriptionManager()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation SHTSubscriptionManager

+ (instancetype)sharedManager {
    static SHTSubscriptionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:manager];
    });
    return manager;
}

- (void)loadProducts {
    NSSet *productIDs = [NSSet setWithArray:@[@"com.seaHorseTheater.app.subscription.week", @"com.seaHorseTheater.app.subscription.month", @"com.seaHorseTheater.app.subscription.year"]];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIDs];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"获取订阅商品信息请求:%@", request);
    NSLog(@"获取订阅商品信息响应:%@", response);
    NSLog(@"订阅商品信息:%@", response.products);
    self.products = response.products;
    if (self.productCallBack) {
        self.productCallBack(self.products);
    }
}

// 发起购买
- (void)purchaseProduct:(SKProduct *)product {
    if ([SKPaymentQueue canMakePayments]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

#pragma mark - SKPaymentTransactionObserver

// 处理交易
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"购买成功: %@", transaction.payment.productIdentifier);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                // 购买成功之后，App内评分
                [SHTAppRateTool requestSystemReview];
                break;
            case SKPaymentTransactionStateRestored:
                [self validateReceipt]; // 本地验证
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"购买失败: %@", transaction.error.localizedDescription);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)validateReceipt {
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    if (!receiptData) return;

    // 使用 Apple 提供的本地验证（可选）
    // 对于无服务端方案，可用解析 plist 的方式简单判断过期时间

    // 保存订阅状态
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSubscribed"];
}

- (BOOL)isSubscribed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isSubscribed"];
}

@end
