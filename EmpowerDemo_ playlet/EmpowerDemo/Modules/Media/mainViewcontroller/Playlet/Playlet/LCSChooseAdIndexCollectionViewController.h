//
//  LCSChooseAdIndexCollectionViewController.h
//  EmpowerDemo
//
//  Created by ByteDance on 2024/3/7.
//  Copyright © 2024 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSChooseAdIndexCollectionViewController : UICollectionViewController

@property (nonatomic, copy) void (^selectBlock)(NSArray<NSNumber *> *selectedIndex);

@end

NS_ASSUME_NONNULL_END
