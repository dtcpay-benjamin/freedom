//
//  SHTServiceAgreementViewController.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/11.
//

#import "SHTViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHTServiceAgreementViewController : UIViewController

// 加载网页
- (void)loadRequest:(NSString *)urlStr;

// 加载本地HTML
- (void)loadMainBundleHtml:(NSString *)resourceName;

@end

NS_ASSUME_NONNULL_END
