//
//  SHTWebViewController.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/29.
//

#import <UIKit/UIKit.h>
#import "SHTViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHTWebViewController : SHTViewController

// 加载网页
- (void)loadRequest:(NSString *)urlStr;

// 加载本地HTML
- (void)loadMainBundleHtml:(NSString *)resourceName;

@end

NS_ASSUME_NONNULL_END
