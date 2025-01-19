//
//  LCSChannelViewController.h
//  DJXSamples
//
//  Created by iCuiCui on 2020/5/27.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LCS_CHANNEL_PAGE_HEIGHT 38

NS_ASSUME_NONNULL_BEGIN
@interface LCSChannelPage : UIView

@end

@interface LCSChannelViewController : UIViewController
@property (nonatomic, assign) NSString *categoryName;
@property (nonatomic, strong) UIViewController *categoryController;
@property (nonatomic, copy) dispatch_block_t categoryWillAppear;
@property (nonatomic, copy) dispatch_block_t categoryWillDisAppear;

- (instancetype)initWithCategoryTop:(CGFloat)categoryTop;

@end

NS_ASSUME_NONNULL_END
