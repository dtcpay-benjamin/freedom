//
//  LCSDrawSimulateShareViewController.h
//  EmpowerDemo
//
//  Created by 崔亚楠 on 2021/11/4.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSDrawSimulateShareViewController : UIViewController
@property (nonatomic, copy) dispatch_block_t tapBlock;
@property (nonatomic, copy) dispatch_block_t tapNewVideoBlock;
@property (nonatomic, assign) long long groupId;

@end

NS_ASSUME_NONNULL_END
