//
//  SHTSubscriptionManager.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/18.
//

#import "SHTSubscriptionManager.h"

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

- (void)fetchProducts {
    NSSet *productIDs = [NSSet setWithArray:@[@"com.app.weekly", @"com.app.monthly", @"com.app.yearly"]];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIDs];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.products = response.products;
    // 通知 UI 刷新显示价格
}

// 发起购买
- (void)purchaseProduct:(SKProduct *)product {
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKPaymentTransactionObserver

// 处理交易
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"购买成功: %@", transaction.payment.productIdentifier);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"购买失败: %@", transaction.error.localizedDescription);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

@end
