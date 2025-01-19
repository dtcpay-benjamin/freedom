//
//  LCSDrawMoreAlertViewController.m
//  LCDSamples
//
//  Created by iCuiCui on 2020/6/7.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSDrawMoreAlertViewController.h"

@interface LCSDrawMoreAlertViewController ()

@end

@implementation LCSDrawMoreAlertViewController

- (instancetype)initWithDidClickReportBtn:(dispatch_block_t)didClickReportBtn {
    self = [super init];
    if (self) {
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        UIAlertAction *btn1 = [UIAlertAction actionWithTitle:@"自行添加其他功能" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        UIAlertAction *btn2 = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            !didClickReportBtn?:didClickReportBtn();
        }];
        [self addAction:cancelBtn];
        [self addAction:btn1];
        [self addAction:btn2];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
