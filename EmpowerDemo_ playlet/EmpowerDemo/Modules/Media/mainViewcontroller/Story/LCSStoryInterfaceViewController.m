//
//  LCSStoryInterfaceViewController.m
//  EmpowerDemo
//
//  Created by ByteDance on 2023/2/7.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import "LCSStoryInterfaceViewController.h"
#if __has_include (<PangrowthMiniStory/MNManager.h>)
#import <PangrowthMiniStory/MNStoryManager.h>
#endif

#define kLeftSpace 10
#define kButtonWidth (([UIScreen mainScreen].bounds.size.width - kLeftSpace * 2)/2)
#define kButtonHeight 40
#define kTextFeildWidth ([UIScreen mainScreen].bounds.size.width - kLeftSpace * 2)

@interface LCSStoryInterfaceViewController ()
#if __has_include (<PangrowthMiniStory/MNManager.h>)

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UIButton *allRequestBtn;
@property (nonatomic, strong) UIImageView *allRequestSeperateLine;

@property (nonatomic, strong) UITextField *listTf;
@property (nonatomic, strong) UIButton *listRequstBtn;
@property (nonatomic, strong) UIImageView *listRequstSeperateLine;

@property (nonatomic, strong) UITextField *searchTf;
@property (nonatomic, strong) UIButton *searchRespBtn;
@property (nonatomic, strong) UIImageView *searchRespBtnSeperateLine;

@property (nonatomic, strong) UITextField *categoryTf;
@property (nonatomic, strong) UIButton *categoryRespBtn;
@property (nonatomic, strong) UIImageView *categoryRespBtnSeperateLine;

@property (nonatomic, strong) UITextField *pageTf;
@property (nonatomic, strong) UITextField *numTf;
@property (nonatomic, strong) UIButton *historyBtn;
@property (nonatomic, strong) UIButton *collectionListBtn;
@property (nonatomic, strong) UIView *historyLine;

@property (nonatomic, strong) UITextField *bookIDTf;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *cancelCollectBtn;
@property (nonatomic, strong) UIImageView *colletRespBtnSeperateLine;

@property (nonatomic, strong) UITextField *useResponseTf;
@property (nonatomic, strong) UITextField *resultIndexTf;
@property (nonatomic, strong) UITextField *episodeTf;
@property (nonatomic, strong) UIButton *enterPlayerBtn;

@property (nonatomic, strong) UISwitch *packageSwitch;
@property (nonatomic, strong) UISwitch *hiddenSwitch;
@property (nonatomic, strong) UISwitch *blockSwitch;
@property (nonatomic, strong) UISwitch *infiniteSwitch;

@property (nonatomic, strong) UIButton *historyPlayButton;

@property (nonatomic, strong) NSArray *dataArray1;
@property (nonatomic, strong) NSArray *dataArray2;

@property (nonatomic, strong) UITextField *topMargin;
@property (nonatomic, strong) UITextField *startTime;

@property (nonatomic, assign) NSInteger currentSkit;

@property (nonatomic, strong) UIButton *resButton;

//@property (nonatomic, strong) DJXDrawVideoViewController *vc;
#endif
@end


@implementation LCSStoryInterfaceViewController
#if __has_include (<PangrowthMiniStory/MNManager.h>)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self initSubViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllFirstResponder)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchStatusBar) name:@"statusBarTapActionNotification" object:nil];
}

- (void)resignAllFirstResponder {
    [self.listTf resignFirstResponder];
    [self.useResponseTf resignFirstResponder];
    [self.resultIndexTf resignFirstResponder];
    [self.episodeTf resignFirstResponder];
    [self.topMargin resignFirstResponder];
}

- (void)initSubViews {
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.bgScrollView];
    
    [self __initBgScrollViewSubViews];
    
    self.bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.resButton.frame) + 100);
}

- (void)__initBgScrollViewSubViews {
        
    self.allRequestBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, 20, kButtonWidth * 2, kButtonHeight)];
    [self.allRequestBtn setTitle:@"获取类目列表" forState:UIControlStateNormal];
    self.allRequestBtn.backgroundColor = UIColor.darkGrayColor;
    [self.allRequestBtn addTarget:self action:@selector(requestAll) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.allRequestBtn];
    
    self.allRequestSeperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.allRequestBtn.bottom + 10, self.view.bounds.size.width, 0.5)];
    self.allRequestSeperateLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.allRequestSeperateLine];
    
    
    self.listTf = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.allRequestSeperateLine.bottom + 20, kTextFeildWidth, kButtonHeight)];
    self.listTf.layer.borderColor = UIColor.blackColor.CGColor;
    self.listTf.layer.borderWidth = 1;
    self.listTf.textColor = [UIColor blueColor];
    self.listTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入短故事id,多个使用英文的逗号分割" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.f], NSForegroundColorAttributeName: [UIColor blueColor]}];
    [self.bgScrollView addSubview:self.listTf];
    
    self.listRequstBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.listTf.bottom + 20, kButtonWidth * 2, kButtonHeight)];
    self.listRequstBtn.backgroundColor = UIColor.darkGrayColor;
    [self.listRequstBtn setTitle:@"请求短故事" forState:UIControlStateNormal];
    [self.listRequstBtn addTarget:self action:@selector(requestWithList) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.listRequstBtn];
    
    self.listRequstSeperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.listRequstBtn.bottom + 10, self.view.bounds.size.width, 0.5)];
    self.listRequstSeperateLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.listRequstSeperateLine];
    
    //搜索关键词
    
    self.searchTf = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.listRequstSeperateLine.bottom + 20, kTextFeildWidth, kButtonHeight)];
    self.searchTf.layer.borderColor = UIColor.blackColor.CGColor;
    self.searchTf.layer.borderWidth = 1;
    self.searchTf.textColor = [UIColor blueColor];
    self.searchTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入关键词" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.f], NSForegroundColorAttributeName: [UIColor blueColor]}];
    [self.bgScrollView addSubview:self.searchTf];
    
    self.searchRespBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.searchTf.bottom + 20, kButtonWidth * 2, kButtonHeight)];
    self.searchRespBtn.backgroundColor = UIColor.darkGrayColor;
    [self.searchRespBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchRespBtn addTarget:self action:@selector(requestWithSearchWord) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.searchRespBtn];
    
    self.searchRespBtnSeperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.searchRespBtn.bottom + 10, self.view.bounds.size.width, 0.5)];
    self.searchRespBtnSeperateLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.searchRespBtnSeperateLine];

    //搜分类搜索
    self.categoryTf = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.searchRespBtnSeperateLine.bottom + 20, kTextFeildWidth, kButtonHeight)];
    self.categoryTf.layer.borderColor = UIColor.blackColor.CGColor;
    self.categoryTf.layer.borderWidth = 1;
    self.categoryTf.textColor = [UIColor blueColor];
    self.categoryTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入类目id" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.f], NSForegroundColorAttributeName: [UIColor blueColor]}];
    [self.bgScrollView addSubview:self.categoryTf];
    
    self.categoryRespBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.categoryTf.bottom + 20, kButtonWidth * 2, kButtonHeight)];
    self.categoryRespBtn.backgroundColor = UIColor.darkGrayColor;
    [self.categoryRespBtn setTitle:@"请求短故事" forState:UIControlStateNormal];
    [self.categoryRespBtn addTarget:self action:@selector(requestWithCategory) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.categoryRespBtn];
    
    self.categoryRespBtnSeperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.categoryRespBtn.bottom + 10, self.view.bounds.size.width, 0.5)];
    self.categoryRespBtnSeperateLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.categoryRespBtnSeperateLine];
    
    
    self.historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.categoryRespBtnSeperateLine.bottom + 20, kButtonWidth * 2, kButtonHeight)];
    [self.historyBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    self.historyBtn.backgroundColor = UIColor.darkGrayColor;
    [self.historyBtn addTarget:self action:@selector(requsetHistory) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.historyBtn];
    
    self.historyLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.historyBtn.bottom + 20, self.view.bounds.size.width, 0.5)];
    self.historyLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.historyLine];
    
    
    self.bookIDTf = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.historyLine.bottom + 20, kTextFeildWidth, kButtonHeight)];
    self.bookIDTf.layer.borderColor = UIColor.blackColor.CGColor;
    self.bookIDTf.layer.borderWidth = 1;
    self.bookIDTf.textColor = [UIColor blueColor];
    self.bookIDTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入短故事id" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.f], NSForegroundColorAttributeName: [UIColor blueColor]}];
    [self.bgScrollView addSubview:self.bookIDTf];
    
    self.collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.bookIDTf.bottom + 20, kButtonWidth, kButtonHeight)];
    self.collectBtn.backgroundColor = UIColor.darkGrayColor;
    [self.collectBtn setTitle:@"收藏短故事" forState:UIControlStateNormal];
    [self.collectBtn addTarget:self action:@selector(collectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.collectBtn];
    
    self.cancelCollectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.collectBtn.right + 5, self.bookIDTf.bottom + 20, kButtonWidth, kButtonHeight)];
    self.cancelCollectBtn.backgroundColor = UIColor.darkGrayColor;
    [self.cancelCollectBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
    [self.cancelCollectBtn addTarget:self action:@selector(cancelCollectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.cancelCollectBtn];
    
    self.collectionListBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.cancelCollectBtn.bottom + 20, kButtonWidth * 2, kButtonHeight)];
    [self.collectionListBtn setTitle:@"收藏列表" forState:UIControlStateNormal];
    self.collectionListBtn.backgroundColor = UIColor.darkGrayColor;
    [self.collectionListBtn addTarget:self action:@selector(collectionList) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.collectionListBtn];
    
    self.colletRespBtnSeperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.collectionListBtn.bottom + 10, self.view.bounds.size.width, 0.5)];
    self.colletRespBtnSeperateLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.colletRespBtnSeperateLine];
    
    
//    self.enterPlayerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.colletRespBtnSeperateLine.bottom + 20, kButtonWidth, kButtonHeight)];
//    self.enterPlayerBtn.backgroundColor = UIColor.darkGrayColor;
//    [self.enterPlayerBtn setTitle:@"跳转短故事播放页" forState:UIControlStateNormal];
//    [self.enterPlayerBtn addTarget:self action:@selector(enterPlayer) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgScrollView addSubview:self.enterPlayerBtn];
    
    self.resButton = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.colletRespBtnSeperateLine.bottom + 20, kButtonWidth * 2, kButtonHeight*4)];
    self.resButton.backgroundColor = UIColor.darkGrayColor;
    [self.resButton setTitle:@"请求结果" forState:UIControlStateNormal];
    [self.bgScrollView addSubview:self.resButton];
}



- (void)touchStatusBar {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入要跳转的集数" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *titleTextField = alert.textFields.firstObject;
//        [self.vc setCurrentPlayletEpisode:[titleTextField.text integerValue]];
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [[UIViewController performSelector:@selector(djx_topViewController)] presentViewController:alert animated:YES completion:nil];
}

- (void)touchResponseBtn:(UIButton *)responseBtn {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = responseBtn.titleLabel.text;
}

- (void)requestAll {
    [[MNStoryManager shareInstance] requestCategoryList:^(BOOL success, NSArray<MNStoryCategoryListItemModel *> * _Nonnull categoryList) {
        if (success) {
            NSMutableString *str = [NSMutableString string];
            [self.resButton setTitle:@"request success" forState:UIControlStateNormal];
            self.dataArray1 = categoryList;
        } else {
            [self.resButton setTitle:@"request fail" forState:UIControlStateNormal];
        }
    }];
}

- (void)requsetHistory {
    [[MNStoryManager shareInstance] requestHistoryStoryList:1 num:9 completion:^(BOOL success, NSArray<MNStoryInfoModel *> * _Nonnull storyList) {
        if (success) {
            NSMutableString *str = [NSMutableString string];
            [self.resButton setTitle:@"request success" forState:UIControlStateNormal];
        } else {
            [self.resButton setTitle:@"request fail" forState:UIControlStateNormal];
        }
        NSLog(@"[短故事回调]历史记录");
    }];
}

- (void)collectionList {
    [[MNStoryManager shareInstance] requestStoryCollectionList:1 num:9 completeHandler:^(BOOL success, NSArray<MNStoryInfoModel *> * _Nonnull storyList, NSDictionary<NSString *,NSObject *> * _Nonnull totalDict, BOOL hasMore) {
        if (success) {
            NSMutableString *str = [NSMutableString string];
            [self.resButton setTitle:@"request success" forState:UIControlStateNormal];
        } else {
            [self.resButton setTitle:@"request fail" forState:UIControlStateNormal];
        }
        NSLog(@"[短故事回调]收藏列表");
    }];
}

- (void)requestPlayletCategoryList {
//    [[DJXPlayletManager shareInstance] requestCategoryList:^(BOOL success, NSArray<NSString *> *categoryList) {
//        if (success) {
//            [categoryList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSLog(@"[短故事回调]短故事分类 %2lu: %@", idx, obj);
//            }];
//        }
//    }];
}

- (void)collectBtnClicked {
    [[MNStoryManager shareInstance] requestCollectStory:self.bookIDTf.text.integerValue completeHandler:^(NSError * _Nullable error) {
        if (!error) {
            [self.resButton setTitle:@"request success" forState:UIControlStateNormal];
        } else {
            [self.resButton setTitle:@"request fail" forState:UIControlStateNormal];
        }
    }];
}

- (void)cancelCollectBtnClicked {
    [[MNStoryManager shareInstance] requestCancelCollectStory:self.bookIDTf.text.integerValue completeHandler:^(NSError * _Nullable error) {
        if (!error) {
            [self.resButton setTitle:@"request success" forState:UIControlStateNormal];
        } else {
            [self.resButton setTitle:@"request fail" forState:UIControlStateNormal];
        }
    }];
}

- (void)requestWithCategory {
    [[MNStoryManager shareInstance] requestCategoryStoryListWithCategoryId:self.categoryTf.text.integerValue page:1 num:9 order:1 completion:^(BOOL success, NSArray<MNStoryInfoModel *> * _Nonnull storyList) {
        if (success) {
            NSMutableString *str = [NSMutableString string];
            [self.resButton setTitle:@"request success" forState:UIControlStateNormal];
        } else {
            [self.resButton setTitle:@"request fail" forState:UIControlStateNormal];
        }
    }];
}

- (void)requestWithSearchWord {
    [[MNStoryManager shareInstance] requestStoryListWithSearchWord:self.searchTf.text isFuzzy:YES page:1 num:9 completion:^(BOOL success, NSArray<MNStoryInfoModel *> * _Nonnull storyList, BOOL hasMore) {
        if (success) {
            NSMutableString *str = [NSMutableString string];
  
            [self.resButton setTitle:@"request success" forState:UIControlStateNormal];
        } else {
            [self.resButton setTitle:@"request fail" forState:UIControlStateNormal];
        }
    }];
}

- (void)requestWithList {
    
    NSArray *array = [self.listTf.text componentsSeparatedByString:@","];
    [[MNStoryManager shareInstance] requestStoryListWithBookId:array completion:^(BOOL success, NSArray<MNStoryInfoModel *> * _Nonnull storyList) {
        if (success) {
            NSMutableString *str = [NSMutableString string];
            [self.resButton setTitle:@"request success" forState:UIControlStateNormal];
            self.dataArray2 = storyList;
        } else {
            [self.resButton setTitle:@"request fail" forState:UIControlStateNormal];
        }
    }];
}

- (void)enterPlayer {
    
    BOOL useListData = YES;
    if ([self.useResponseTf.text isEqualToString:@"1"]) {
        useListData = NO;
    }
    
   id model;
    
    NSInteger index = [self.resultIndexTf.text integerValue];
    if (useListData) {
        if (index >= self.dataArray2.count) {
            index = self.dataArray2.count - 1;
        }
        if (index < self.dataArray2.count) {
            model = self.dataArray2[index];
        }
    } else {
        if (index >= self.dataArray1.count) {
            index = self.dataArray1.count - 1;
        }
        if (index < self.dataArray1.count) {
            model = self.dataArray1[index];
        }
    }
    
//    DJXPlayletConfig *config = [DJXPlayletConfig new];
//    config.skitId = 1008;//model.skit_id ?: model.shortplay_id;
//    config.episode = [self.episodeTf.text integerValue];
//    config.playletUnlockADMode = self.packageSwitch.isOn ? DJXPlayletUnlockADMode_Common : DJXPlayletUnlockADMode_Specific;
//    config.fromTopMargin = [self.topMargin.text integerValue];
//    config.playerDelegate = self;
//    config.interfaceDelegate = self;
//    
//    if (self.hiddenSwitch.isOn) {
//        config.hideBackButton = YES;
//        config.hideMoreButton = YES;
//    }
//    if (self.infiniteSwitch.isOn) {
//        config.closeInfiniteScroll = YES;
//    }
//    if (self.startTime.text) {
//        config.playStartTime = [self.startTime.text floatValue];
//    }
//    
//    self.vc = [[DJXPlayletManager shareInstance] playletViewControllerWithParams:config];
//    self.vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:self.vc animated:YES completion:nil];
}

- (void)enterPlayerWithHistoryData {
    
    if (self.currentSkit == 0) {
        return;
    }
//    DJXPlayletConfig *config = [DJXPlayletConfig new];
//    config.playletUnlockADMode = DJXPlayletUnlockADMode_Specific;
//    config.skitId = self.currentSkit;
//    NSInteger currentEpisode = [[NSUserDefaults standardUserDefaults] integerForKey:@(self.currentSkit).stringValue];
//    config.episode = currentEpisode;
//    
//    self.vc = [[DJXPlayletManager shareInstance] playletViewControllerWithParams:config];
//    self.vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:self.vc animated:YES completion:nil];
}

#endif

@end
