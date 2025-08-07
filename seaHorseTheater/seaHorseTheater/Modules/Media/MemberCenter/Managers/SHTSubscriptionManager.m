//
//  SHTSubscriptionManager.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/18.
//

#import "SHTSubscriptionManager.h"
#import <StoreKit/StoreKit.h>
#import "SHTAppRateTool.h"
#import "SHTKeychainHelper.h"
#import <objc/runtime.h>

// sandbox地址
static NSString *const itunesUrlStr = @"https://sandbox.itunes.apple.com/verifyReceipt";

// 生产地址
//static NSString *const itunesUrlStr = @"https://buy.itunes.apple.com/verifyReceipt";

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

- (BOOL)isSubscribed {
    return [SHTKeychainHelper getBoolForKey:@"isSubscribed"];;
}

- (NSData *)fetchReceiptData {
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    return receipt;
}

- (void)refreshReceiptWithCompletion:(void (^)(BOOL success))completion {
    SKReceiptRefreshRequest *request = [[SKReceiptRefreshRequest alloc] init];
    request.delegate = self;
    objc_setAssociatedObject(request, @"receiptCompletion", completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [request start];
}

- (void)validateReceipt:(NSData *)receiptData completion:(void (^)(BOOL isSubscribed))completion {
    if (!receiptData) {
        completion(NO);
        return;
    }

    NSString *receiptString = [receiptData base64EncodedStringWithOptions:0];
    NSDictionary *requestContents = @{@"receipt-data": receiptString};

    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    if (error) {
        completion(NO);
        return;
    }

    // 注意sandbox和生产地址
    NSURL *storeURL = [NSURL URLWithString:itunesUrlStr];

    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    storeRequest.HTTPMethod = @"POST";
    storeRequest.HTTPBody = requestData;
    [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !data) {
            completion(NO);
            return;
        }

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *latestInfo = json[@"latest_receipt_info"];
        
        if (latestInfo.count == 0) {
            completion(NO);
            return;
        }
        
        for (NSDictionary *receipt in latestInfo) {
            NSString *productId = receipt[@"product_id"];
            NSString *expiresDateMs = receipt[@"expires_date_ms"];
            if (expiresDateMs) {
                NSDate *expiresDate = [NSDate dateWithTimeIntervalSince1970:expiresDateMs.doubleValue / 1000.0];
                if ([productId isEqualToString:@"com.seaHorseTheater.app.subscription.week"] || [productId isEqualToString:@"com.seaHorseTheater.app.subscription.month"] || [productId isEqualToString:@"com.seaHorseTheater.app.subscription.year"]) {
                    BOOL isSubscribed = [expiresDate compare:[NSDate date]] == NSOrderedDescending;
                    completion(isSubscribed);
                    return;
                }
            }
        }
        
        completion(NO);
    }];
    [task resume];
}

- (void)checkSubscriptionStatus {
    NSData *receipt = [self fetchReceiptData];
    if (!receipt) {
        [self refreshReceiptWithCompletion:^(BOOL success) {
            if (success) {
                NSData *newReceipt = [self fetchReceiptData];
                [self validateReceipt:newReceipt completion:^(BOOL isSubscribed) {
                    NSLog(@"是否订阅: %@", isSubscribed ? @"是" : @"否");
                    [SHTKeychainHelper saveBool:isSubscribed forKey:@"isSubscribed"];
                }];
            } else {
                NSLog(@"刷新收据失败");
                [SHTKeychainHelper saveBool:NO forKey:@"isSubscribed"];
            }
        }];
    } else {
        [self validateReceipt:receipt completion:^(BOOL isSubscribed) {
            NSLog(@"是否订阅: %@", isSubscribed ? @"是" : @"否");
            [SHTKeychainHelper saveBool:NO forKey:@"isSubscribed"];
        }];
    }
}

- (void)restorePurchases {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


#pragma mark - SKPaymentTransactionObserver

// 处理交易
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"购买成功: %@", transaction.payment.productIdentifier);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [SHTKeychainHelper saveBool:YES forKey:@"isSubscribed"];
                // 购买成功之后，App内评分
                [SHTAppRateTool requestSystemReview];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"恢复权益成功: %@", transaction.payment.productIdentifier);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self checkSubscriptionStatus]; // 本地验证
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"购买失败: %@", transaction.error.localizedDescription);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [SHTKeychainHelper saveBool:NO forKey:@"isSubscribed"];
                break;
            default:
                break;
        }
    }
}

#pragma mark - SKRequestDelegate
- (void)requestDidFinish:(SKRequest *)request {
    void (^completion)(BOOL) = objc_getAssociatedObject(request, @"receiptCompletion");
    if (completion) completion(YES);
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    void (^completion)(BOOL) = objc_getAssociatedObject(request, @"receiptCompletion");
    if (completion) completion(NO);
}

@end
