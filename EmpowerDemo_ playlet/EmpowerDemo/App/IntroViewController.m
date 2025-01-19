//
//  IntroViewController.m
//  mPaaSProject_InHouse
//
//  Created by Bob on 2020/3/30. 
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroViewController.h"

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton* initButton = [UIButton buttonWithType:UIButtonTypeSystem];
    initButton.frame = CGRectMake(20, 300, UIScreen.mainScreen.bounds.size.width-40, 50);
    [initButton setTitle:@"初始化SDK" forState:UIControlStateNormal];
    [initButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    initButton.backgroundColor = UIColor.systemBlueColor;
    initButton.layer.cornerRadius = 10;
    [self.view addSubview:initButton];
    [initButton addTarget:self action:@selector(onTapPrepare) forControlEvents:UIControlEventTouchUpInside];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, UIScreen.mainScreen.bounds.size.width-40, 100)];
    label.textColor = UIColor.blackColor;
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"以下请在用户同意隐私协议后调用\n以下请确保在调用过初始化SDK后再调用";
    [self.view addSubview:label];
    
    UIButton* startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startButton.frame = CGRectMake(20, 500, UIScreen.mainScreen.bounds.size.width-40, 50);
    [startButton setTitle:@"进入内容主页" forState:UIControlStateNormal];
    [startButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    startButton.backgroundColor = UIColor.systemBlueColor;
    startButton.layer.cornerRadius = 10;
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(onTapSetup) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapPrepare {
    [(AppDelegate *)UIApplication.sharedApplication.delegate prepare];
}

- (void)onTapSetup {
    [(AppDelegate *)UIApplication.sharedApplication.delegate setup];
}
@end
