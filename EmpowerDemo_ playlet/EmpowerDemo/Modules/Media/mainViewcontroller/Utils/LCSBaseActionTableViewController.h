//
//  LCSBaseActionTableViewController.h
//  DJXSamples
//
//  Created by yuxr on 2020/9/6.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSActionCellView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCSBaseActionTableViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSMutableArray *> *items;

- (void)buildCells;
- (UIButton *)createCloseButtonWithRelatedVC:(UIViewController *)relatedVC;

@end

NS_ASSUME_NONNULL_END
