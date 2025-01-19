//
//  LCSDrawSimulateShareViewController.m
//  EmpowerDemo
//
//  Created by 崔亚楠 on 2021/11/4.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import "LCSDrawSimulateShareViewController.h"

@interface LCSDrawSimulateShareViewController ()
@property (nonatomic) BOOL sending;
@property (nonatomic) UITextField *textField;
@property (nonatomic) UIButton *submitButton;
@property (nonatomic) UIButton *submitButton1;
@end

@implementation LCSDrawSimulateShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, LCSScreenWidth - 20 * 2, 30)];
    self.textField.borderStyle = UITextBorderStyleBezel;
    self.textField.placeholder = @"请输入group_id";
    self.textField.text = @(7001400676135767310).stringValue;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.textField];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.backgroundColor = LCS_RGB(240, 65, 66);
    self.submitButton.frame = CGRectMake(self.textField.left, self.textField.bottom + 10, self.textField.width, 50);
    [self.submitButton setTitle:@"点击模拟打开小视频列表" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(tapSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    
    self.submitButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton1.backgroundColor = LCS_RGB(240, 65, 66);
    self.submitButton1.frame = CGRectMake(self.textField.left, self.submitButton.bottom + 10, self.textField.width, 50);
    [self.submitButton1 setTitle:@"点击模拟打开新的小视频" forState:UIControlStateNormal];
    [self.submitButton1 addTarget:self action:@selector(tapSubmitNewVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton1];
}

- (long long)groupId {
    return [self.textField.text longLongValue];
}

- (void)tapSubmit {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

- (void)tapSubmitNewVideo {
    if (self.tapNewVideoBlock) {
        self.tapNewVideoBlock();
    }
}

@end
