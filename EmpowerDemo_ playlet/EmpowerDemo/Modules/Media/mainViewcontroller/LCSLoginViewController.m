//
//  LCSLoginViewController.m
//  EmpowerDemo
//
//  Created by ByteDance on 2023/11/2.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import "LCSLoginViewController.h"
#import "MBProgressHUD+Toast.h"
#if __has_include (<PangrowthDJX/DJXSDK.h>)
#import <PangrowthDJX/DJXSDK.h>
#endif

@interface LCSLoginViewController ()

@end

@implementation LCSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildCells {
    lcs_weakify(self)

    NSMutableArray *items = [NSMutableArray array];

    LCSActionModel *loginModel = [LCSActionModel plainTitleActionModel:@"登录" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入ouid" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *titleTextField = alert.textFields.firstObject;
#if __has_include (<PangrowthDJX/DJXSDK.h>)
            NSString *abc = [DJXManager getSignWithPaySecretKey:@"461f38754970076acae618ebd1193a52" nonce:@"1234567890123456" timeStamp:[[NSDate date] timeIntervalSince1970] params:@{@"ouid":titleTextField.text}];
            [DJXManager loginWithParamsString:abc completionBlock:^(BOOL loginStatus, NSDictionary * _Nonnull userInfo) {
                NSString *type = [[userInfo valueForKey:@"login_type"] isEqualToString:@"guest"] ? @"游客" : @"媒体";
                NSString *status = loginStatus ? @"登录成功" : @"登录失败";
                [MBProgressHUD showToast:[NSString stringWithFormat:@"%@%@", type, status] dismissAfterDelay:1];
            }];
#endif
        }]];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    LCSActionModel *logoutModel = [LCSActionModel plainTitleActionModel:@"登出" cellType:LCSCellType_video action:^{
#if __has_include (<PangrowthDJX/DJXSDK.h>)
        [DJXManager logoutWithCompletionBlock:^(BOOL loginStatus, NSDictionary * _Nonnull userInfo) {
            NSString *status = loginStatus ? @"登出成功" : @"登出失败";
            [MBProgressHUD showToast:[NSString stringWithFormat:@"%@", status] dismissAfterDelay:1];
        }];
#endif
    }];
    [items addObject:@[loginModel, logoutModel]];
    
    LCSActionModel *statusModel = [LCSActionModel plainTitleActionModel:@"登录状态" cellType:LCSCellType_video action:^{
#if __has_include (<PangrowthDJX/DJXSDK.h>)
        NSString *status = [DJXManager isLogin] ? @"已登录" : @"未登录";
        [MBProgressHUD showToast:[NSString stringWithFormat:@"%@", status] dismissAfterDelay:1];
#endif
    }];
    [items addObject:@[statusModel]];
    
    self.items = items;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
