//
//  LCSPlayletInterfaceViewController.m
//  EmpowerDemo
//
//  Created by ByteDance on 2023/2/7.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import "LCSPlayletInterfaceViewController.h"
#import "MBProgressHUD+Toast.h"

#define kLeftSpace 10
#define kButtonWidth 200
#define kButtonHeight 40
#define kTextFeildWidth ([UIScreen mainScreen].bounds.size.width - kLeftSpace * 2)

#if __has_include (<PangrowthDJX/DJXSDK.h>)
#import <PangrowthDJX/DJXSDK.h>
@interface LCSPlayletInterfaceViewController () <DJXPlayletInterfaceProtocol, DJXPlayletAdvertProtocol, DJXPlayletPlayerProtocol>

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UIButton *responseBtn1;
@property (nonatomic, strong) UIButton *allRequestBtn;
@property (nonatomic, strong) UIImageView *allRequestSeperateLine;
@property (nonatomic, strong) UITextField *orderTf;

@property (nonatomic, strong) UITextField *listTf;
@property (nonatomic, strong) UIButton *responseBtn2;
@property (nonatomic, strong) UIButton *listRequstBtn;
@property (nonatomic, strong) UIImageView *listRequstSeperateLine;

@property (nonatomic, strong) UITextField *searchTf;
@property (nonatomic, strong) UIButton *searchRespBtn2;
@property (nonatomic, strong) UIButton *searchRespBtn;
@property (nonatomic, strong) UIImageView *searchRespBtnSeperateLine;

@property (nonatomic, strong) UITextField *categoryTf;
@property (nonatomic, strong) UIButton *categoryRespBtn2;
@property (nonatomic, strong) UIButton *categoryRespBtn;
@property (nonatomic, strong) UIImageView *categoryRespBtnSeperateLine;
@property (nonatomic, strong) UITextField *categoryOrderTf;

@property (nonatomic, strong) UIButton *histortResultBtn;
@property (nonatomic, strong) UITextField *pageTf;
@property (nonatomic, strong) UITextField *numTf;
@property (nonatomic, strong) UIButton *historyBtn;
@property (nonatomic, strong) UIButton *cleanHistoryBtn;
@property (nonatomic, strong) UIView *historyLine;

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

/// 短剧解锁信息相关
@property (nonatomic) UITextField *unlockInfoShortplayId;
@property (nonatomic) UITextField *unlockInfoFreeCount;
@property (nonatomic) UIButton *unlockInfoButton;

@property (nonatomic, strong) DJXDrawVideoViewController *vc;

@end

@implementation LCSPlayletInterfaceViewController

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
    [self.unlockInfoFreeCount resignFirstResponder];
    [self.unlockInfoShortplayId resignFirstResponder];
}

- (void)initSubViews {
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.bgScrollView];
    
    [self __initBgScrollViewSubViews];
    
    self.bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.unlockInfoButton.frame) + 100);
}

- (void)__initBgScrollViewSubViews {
    self.responseBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, 0, kTextFeildWidth, kButtonHeight)];
    self.responseBtn1.backgroundColor = UIColor.grayColor;
    [self.responseBtn1 setTitle:@"请求结果1,点击复制" forState:UIControlStateNormal];
    [self.responseBtn1 addTarget:self action:@selector(touchResponseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.responseBtn1];
        
    self.allRequestBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.responseBtn1.bottom + 20, kButtonWidth, kButtonHeight)];
    [self.allRequestBtn setTitle:@"请求全部短剧" forState:UIControlStateNormal];
    self.allRequestBtn.backgroundColor = UIColor.darkGrayColor;
    [self.allRequestBtn addTarget:self action:@selector(requestAll) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.allRequestBtn];
    
    self.orderTf = [[UITextField alloc] initWithFrame:CGRectMake(self.allRequestBtn.right, self.allRequestBtn.top, kButtonWidth, kButtonHeight)];
    self.orderTf.layer.borderColor = UIColor.whiteColor.CGColor;
    self.orderTf.layer.borderWidth = 1;
    self.orderTf.placeholder = @"0:正序 1:倒序 2:推荐";
    self.orderTf.text = @"2";
    [self.bgScrollView addSubview:self.orderTf];
    
    self.allRequestSeperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.allRequestBtn.bottom + 10, self.view.bounds.size.width, 0.5)];
    self.allRequestSeperateLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.allRequestSeperateLine];
    
    self.responseBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.allRequestBtn.bottom + 40, kTextFeildWidth, kButtonHeight)];
    self.responseBtn2.backgroundColor = UIColor.grayColor;
    [self.responseBtn2 setTitle:@"请求结果2,点击复制" forState:UIControlStateNormal];
    [self.responseBtn2 addTarget:self action:@selector(touchResponseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.responseBtn2];
    
    self.listTf = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.responseBtn2.bottom + 20, kTextFeildWidth, kButtonHeight)];
    self.listTf.layer.borderColor = UIColor.whiteColor.CGColor;
    self.listTf.layer.borderWidth = 1;
    self.listTf.placeholder = @"请输入短剧id,多部使用英文的逗号分割";
    [self.bgScrollView addSubview:self.listTf];
    
    self.listRequstBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.listTf.bottom + 20, kButtonWidth, kButtonHeight)];
    self.listRequstBtn.backgroundColor = UIColor.darkGrayColor;
    [self.listRequstBtn setTitle:@"按id请求短剧" forState:UIControlStateNormal];
    [self.listRequstBtn addTarget:self action:@selector(requestWithList) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.listRequstBtn];
    
    self.listRequstSeperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.listRequstBtn.bottom + 10, self.view.bounds.size.width, 0.5)];
    self.listRequstSeperateLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.listRequstSeperateLine];
    
    //搜索关键词
    self.searchRespBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.listRequstBtn.bottom + 40, kTextFeildWidth, kButtonHeight)];
    self.searchRespBtn2.backgroundColor = UIColor.grayColor;
    [self.searchRespBtn2 setTitle:@"搜索请求结果,点击复制" forState:UIControlStateNormal];
    [self.searchRespBtn2 addTarget:self action:@selector(touchResponseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.searchRespBtn2];
    
    self.searchTf = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.searchRespBtn2.bottom + 20, kTextFeildWidth, kButtonHeight)];
    self.searchTf.layer.borderColor = UIColor.whiteColor.CGColor;
    self.searchTf.layer.borderWidth = 1;
    self.searchTf.placeholder = @"请输入短剧搜索关键词";
    [self.bgScrollView addSubview:self.searchTf];
    
    self.searchRespBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.searchTf.bottom + 20, kButtonWidth, kButtonHeight)];
    self.searchRespBtn.backgroundColor = UIColor.darkGrayColor;
    [self.searchRespBtn setTitle:@"按搜索关键词搜索" forState:UIControlStateNormal];
    [self.searchRespBtn addTarget:self action:@selector(requestWithSearchWord) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.searchRespBtn];
    
    self.searchRespBtnSeperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.searchRespBtn.bottom + 10, self.view.bounds.size.width, 0.5)];
    self.searchRespBtnSeperateLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.searchRespBtnSeperateLine];

    //搜分类搜索
    self.categoryRespBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.searchRespBtn.bottom + 40, kTextFeildWidth, kButtonHeight)];
    self.categoryRespBtn2.backgroundColor = UIColor.grayColor;
    [self.categoryRespBtn2 setTitle:@"分类请求结果,点击复制" forState:UIControlStateNormal];
    [self.categoryRespBtn2 addTarget:self action:@selector(touchResponseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.categoryRespBtn2];
    
    self.categoryTf = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.categoryRespBtn2.bottom + 20, kButtonWidth, kButtonHeight)];
    self.categoryTf.layer.borderColor = UIColor.whiteColor.CGColor;
    self.categoryTf.layer.borderWidth = 1;
    self.categoryTf.placeholder = @"请输入分类关键词";
    [self.bgScrollView addSubview:self.categoryTf];
    
    self.categoryOrderTf = [[UITextField alloc] initWithFrame:CGRectMake(self.categoryTf.right, self.categoryTf.top, kButtonWidth, kButtonHeight)];
    self.categoryOrderTf.layer.borderColor = UIColor.whiteColor.CGColor;
    self.categoryOrderTf.layer.borderWidth = 1;
    self.categoryOrderTf.placeholder = @"0:正序 1:倒序";
    self.categoryOrderTf.text = @"0";
    [self.bgScrollView addSubview:self.categoryOrderTf];
    
    self.categoryRespBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.categoryTf.bottom + 20, kButtonWidth, kButtonHeight)];
    self.categoryRespBtn.backgroundColor = UIColor.darkGrayColor;
    [self.categoryRespBtn setTitle:@"按分类关键词搜索" forState:UIControlStateNormal];
    [self.categoryRespBtn addTarget:self action:@selector(requestWithCategory) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.categoryRespBtn];
    
    UIButton *categoryListButton = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace + kButtonWidth + kLeftSpace, self.categoryTf.bottom + 20, self.view.bounds.size.width - 3 * kLeftSpace - kButtonWidth, kButtonHeight)];
    categoryListButton.backgroundColor = UIColor.darkGrayColor;
    [categoryListButton setTitle:@"分类列表" forState:UIControlStateNormal];
    [categoryListButton addTarget:self action:@selector(requestPlayletCategoryList) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:categoryListButton];
    
    self.categoryRespBtnSeperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.categoryRespBtn.bottom + 10, self.view.bounds.size.width, 0.5)];
    self.categoryRespBtnSeperateLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.categoryRespBtnSeperateLine];
    
    self.histortResultBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.categoryRespBtnSeperateLine.bottom + 40, kTextFeildWidth, kButtonHeight)];
    self.histortResultBtn.backgroundColor = UIColor.grayColor;
    [self.histortResultBtn setTitle:@"历史记录结果，点击复制" forState:UIControlStateNormal];
    [self.histortResultBtn addTarget:self action:@selector(touchResponseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.histortResultBtn];
    
    self.pageTf = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.histortResultBtn.bottom + 20, kTextFeildWidth * 0.5, kButtonHeight)];
    self.pageTf.placeholder = @"page";
    self.pageTf.layer.borderColor = UIColor.whiteColor.CGColor;
    self.pageTf.layer.borderWidth = 1;
    [self.bgScrollView addSubview:self.pageTf];
    
    self.numTf = [[UITextField alloc] initWithFrame:CGRectMake(self.pageTf.right, self.histortResultBtn.bottom + 20, kTextFeildWidth * 0.5, kButtonHeight)];
    self.numTf.placeholder = @"num";
    self.numTf.layer.borderColor = UIColor.whiteColor.CGColor;
    self.numTf.layer.borderWidth = 1;
    [self.bgScrollView addSubview:self.numTf];
    
    self.historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.pageTf.bottom + 20, kButtonWidth, kButtonHeight)];
    [self.historyBtn setTitle:@"请求历史记录" forState:UIControlStateNormal];
    self.historyBtn.backgroundColor = UIColor.darkGrayColor;
    [self.historyBtn addTarget:self action:@selector(requsetHistory) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.historyBtn];
    
    self.cleanHistoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.historyBtn.lcs_right + 20, self.historyBtn.lcs_top, kButtonWidth, kButtonHeight)];
    [self.cleanHistoryBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
    self.cleanHistoryBtn.backgroundColor = UIColor.darkGrayColor;
    [self.cleanHistoryBtn addTarget:self action:@selector(cleanHistory) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.cleanHistoryBtn];
    
    self.historyLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.historyBtn.bottom + 20, self.view.bounds.size.width, 0.5)];
    self.historyLine.backgroundColor = UIColor.blackColor;
    [self.bgScrollView addSubview:self.historyLine];
    
    self.useResponseTf = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.historyLine.bottom + 40, kTextFeildWidth / 3, kButtonHeight)];
    self.useResponseTf.layer.borderColor = UIColor.whiteColor.CGColor;
    self.useResponseTf.layer.borderWidth = 1;
    self.useResponseTf.placeholder = @"结果1或2";
    self.useResponseTf.text = @"1";
    [self.bgScrollView addSubview:self.useResponseTf];
    
    self.resultIndexTf = [[UITextField alloc] initWithFrame:CGRectMake(self.useResponseTf.right, self.historyLine.bottom + 40, kTextFeildWidth / 3, kButtonHeight)];
    self.resultIndexTf.layer.borderColor = UIColor.whiteColor.CGColor;
    self.resultIndexTf.layer.borderWidth = 1;
    self.resultIndexTf.placeholder = @"结果index";
    self.resultIndexTf.text = @"1";
    [self.bgScrollView addSubview:self.resultIndexTf];
    
    self.episodeTf = [[UITextField alloc] initWithFrame:CGRectMake(self.resultIndexTf.right, self.historyLine.bottom + 40, kTextFeildWidth / 3, kButtonHeight)];
    self.episodeTf.layer.borderColor = UIColor.whiteColor.CGColor;
    self.episodeTf.layer.borderWidth = 1;
    self.episodeTf.placeholder = @"跳转第几集";
    self.episodeTf.text = @"1";
    [self.bgScrollView addSubview:self.episodeTf];
    
    UILabel *modeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftSpace, self.episodeTf.bottom + 20, kButtonWidth, kButtonHeight)];
    modeLabel.text = @"封装模式开关";
    modeLabel.textColor = UIColor.darkGrayColor;
    [self.bgScrollView addSubview:modeLabel];
    
    self.packageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(modeLabel.right, modeLabel.top, kButtonWidth, kButtonHeight)];
    [self.bgScrollView addSubview:self.packageSwitch];
    
    UILabel *hiddenLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftSpace, modeLabel.bottom + 20, kButtonWidth, kButtonHeight)];
    hiddenLabel.text = @"隐藏返回开关";
    hiddenLabel.textColor = UIColor.darkGrayColor;
    [self.bgScrollView addSubview:hiddenLabel];
    
    self.hiddenSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(hiddenLabel.right, hiddenLabel.top, kButtonWidth, kButtonHeight)];
    [self.bgScrollView addSubview:self.hiddenSwitch];
    
    UILabel *infiniteLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftSpace, hiddenLabel.bottom + 20, kButtonWidth, kButtonHeight)];
    infiniteLabel.text = @"禁止无限下滑";
    infiniteLabel.textColor = UIColor.darkGrayColor;
    [self.bgScrollView addSubview:infiniteLabel];
    
    self.infiniteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(infiniteLabel.right, infiniteLabel.top, kButtonWidth, kButtonHeight)];
    [self.bgScrollView addSubview:self.infiniteSwitch];
    
    self.enterPlayerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, infiniteLabel.bottom + 20, kButtonWidth, kButtonHeight)];
    self.enterPlayerBtn.backgroundColor = UIColor.darkGrayColor;
    [self.enterPlayerBtn setTitle:@"跳转短剧播放页" forState:UIControlStateNormal];
    [self.enterPlayerBtn addTarget:self action:@selector(enterPlayer) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.enterPlayerBtn];
    
    self.historyPlayButton = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.enterPlayerBtn.bottom + 20, kButtonWidth + 100, kButtonHeight)];
    self.historyPlayButton.backgroundColor = UIColor.darkGrayColor;
    [self.historyPlayButton setTitle:@"暂无播放记录，点击播放" forState:UIControlStateNormal];
    [self.historyPlayButton addTarget:self action:@selector(enterPlayerWithHistoryData) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.historyPlayButton];
    
    self.topMargin = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.historyPlayButton.bottom + 40, kTextFeildWidth / 2, kButtonHeight)];
    self.topMargin.layer.borderColor = UIColor.whiteColor.CGColor;
    self.topMargin.layer.borderWidth = 1;
    self.topMargin.placeholder = @"提示文案上边距";
    [self.bgScrollView addSubview:self.topMargin];
    
    self.startTime = [[UITextField alloc] initWithFrame:CGRectMake(self.topMargin.right, self.topMargin.top, kTextFeildWidth / 2, kButtonHeight)];
    self.startTime.layer.borderColor = UIColor.whiteColor.CGColor;
    self.startTime.layer.borderWidth = 1;
    self.startTime.placeholder = @"短剧起播时间";
    [self.bgScrollView addSubview:self.startTime];
    
    self.blockSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kLeftSpace, self.topMargin.bottom + 20, kButtonWidth, kButtonHeight)];
    [self.bgScrollView addSubview:self.blockSwitch];
    
    self.unlockInfoShortplayId = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpace, self.blockSwitch.bottom + 40, kTextFeildWidth / 2, kButtonHeight)];
    self.unlockInfoShortplayId.layer.borderColor = UIColor.whiteColor.CGColor;
    self.unlockInfoShortplayId.layer.borderWidth = 1;
    self.unlockInfoShortplayId.placeholder = @"解锁信息短剧id";
    self.unlockInfoShortplayId.text = @"1570";
    [self.bgScrollView addSubview:self.unlockInfoShortplayId];
    
    self.unlockInfoFreeCount = [[UITextField alloc] initWithFrame:CGRectMake(self.unlockInfoShortplayId.right, self.blockSwitch.bottom + 40, kTextFeildWidth / 2, kButtonHeight)];
    self.unlockInfoFreeCount.layer.borderColor = UIColor.whiteColor.CGColor;
    self.unlockInfoFreeCount.layer.borderWidth = 1;
    self.unlockInfoFreeCount.placeholder = @"解锁信息免费集数";
    self.unlockInfoFreeCount.text = @"5";
    [self.bgScrollView addSubview:self.unlockInfoFreeCount];
    
    self.unlockInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(kLeftSpace, self.unlockInfoShortplayId.bottom + 20, kTextFeildWidth / 2, kButtonHeight)];
    self.unlockInfoButton.backgroundColor = UIColor.darkGrayColor;
    [self.unlockInfoButton setTitle:@"获取短剧解锁信息" forState:UIControlStateNormal];
    [self.unlockInfoButton addTarget:self action:@selector(onClickUnlockInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:self.unlockInfoButton];
}

- (void)onClickUnlockInfoButton:(UIButton *)sender {
    NSInteger shortplayId = [self.unlockInfoShortplayId.text integerValue];
    NSInteger freeCount = [self.unlockInfoFreeCount.text integerValue];
    if (shortplayId > 0 && freeCount >= 0) {
        [[DJXPlayletManager shareInstance] requestPlayletDetailsUnlockInfo:shortplayId freeEpisodeCount:freeCount success:^(NSArray<NSNumber *> * _Nonnull unlockStatusArray) {
            NSMutableString *s = [NSMutableString string];
            [unlockStatusArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.boolValue) {
                    [s appendFormat:@"%lu,", idx];
                } else {
                    [s appendFormat:@"-,"];
                }
            }];
            NSLog(@"跳集解锁状态成功, %@", s);
            [MBProgressHUD showToast:s dismissAfterDelay:5];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"获取解锁状态失败");
            NSString *failString = [NSString stringWithFormat:@"获取解锁状态失败 code:%@ msg:%@", @(error.code), error.localizedDescription];
            [MBProgressHUD showToast:failString dismissAfterDelay:5];
        }];
    }
}

- (void)touchStatusBar {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入要跳转的集数" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *titleTextField = alert.textFields.firstObject;
        [self.vc setCurrentPlayletEpisode:[titleTextField.text integerValue]];
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
    [[DJXPlayletManager shareInstance] requestAllPlayletListWithOrder:[self.orderTf.text integerValue] success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList, NSDictionary<NSString *,NSObject *> * _Nonnull info) {
        NSMutableString *str = [NSMutableString string];
        for (DJXPlayletInfoModel *model in playletList) {
            [str appendString: [model performSelector:@selector(BUYY_modelToJSONString)]];
            [str appendString:@"/*/"];
        }
        [self.responseBtn1 setTitle:str forState:UIControlStateNormal];
        self.dataArray1 = playletList;
    } failure:^(NSError * _Nonnull error) {
        NSString *failString = [NSString stringWithFormat:@"code:%@ msg:%@", @(error.code), error.localizedDescription];
        [self.responseBtn1 setTitle:failString forState:UIControlStateNormal];
    }];
}

- (void)requsetHistory {
    [[DJXPlayletManager shareInstance] requestPlayletHistoryListWithPage:self.pageTf.text.integerValue num:self.numTf.text.integerValue success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList) {
        NSMutableString *str = [NSMutableString string];
        for (DJXPlayletInfoModel *model in playletList) {
            [str appendString: [model performSelector:@selector(BUYY_modelToJSONString)]];
            [str appendString:@"/*/"];
        }
        [self.histortResultBtn setTitle:str forState:UIControlStateNormal];
        NSLog(@"[短剧回调]历史记录 %@",str);
    } failure:^(NSError * _Nonnull error) {
        NSString *failString = [NSString stringWithFormat:@"code:%@ msg:%@", @(error.code), error.localizedDescription];
        [self.histortResultBtn setTitle:failString forState:UIControlStateNormal];
        NSLog(@"[短剧回调]历史记录 %@",failString);
    }];
}

- (void)cleanHistory {
    [[DJXPlayletManager shareInstance] requestPlayletHistoryCleanWithCompletion:^{
        NSString *str = @"成功";
        NSLog(@"[短剧回调]历史记录清除%@",str);
    } failure:^(NSError * _Nonnull error) {
        NSString *failString = [NSString stringWithFormat:@"失败 code:%@ msg:%@", @(error.code), error.localizedDescription];
        NSLog(@"[短剧回调]历史记录清除%@",failString);
    }];
}

- (void)requestPlayletCategoryList {
    [[DJXPlayletManager shareInstance] requestCategoryList:^(NSArray<NSString *> * _Nonnull categoryList) {
        [categoryList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"[短剧回调]短剧分类 %2lu: %@", idx, obj);
        }];
    } failure:^(NSError * _Nonnull error) {
        NSString *failString = [NSString stringWithFormat:@"失败 code:%@ msg:%@", @(error.code), error.localizedDescription];
        NSLog(@"[短剧回调]短剧分类%@",failString);
    }];
}

- (void)requestWithCategory {
    [[DJXPlayletManager shareInstance] requestCategoryPlayletLisWithCategory:self.categoryTf.text page:1 num:100 order:[self.categoryOrderTf.text integerValue] success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList) {
        NSMutableString *str = [NSMutableString string];
        for (DJXPlayletInfoModel *model in playletList) {
            [str appendString: [model performSelector:@selector(BUYY_modelToJSONString)]];
            [str appendString:@"/*/"];
        }
        [self.categoryRespBtn2 setTitle:str forState:UIControlStateNormal];
    } failure:^(NSError * _Nonnull error) {
        NSString *failString = [NSString stringWithFormat:@"失败 code:%@ msg:%@", @(error.code), error.localizedDescription];
        [self.categoryRespBtn2 setTitle:failString forState:UIControlStateNormal];
    }];
}

- (void)requestWithSearchWord {
    [[DJXPlayletManager shareInstance] requestCategoryPlayletLisWithSearchWord:self.searchTf.text isFuzzy:false page:1 num:100 success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList, BOOL hasMore) {
        NSMutableString *str = [NSMutableString string];
        for (DJXPlayletInfoModel *model in playletList) {
            [str appendString: [model performSelector:@selector(BUYY_modelToJSONString)]];
            [str appendString:@"/*/"];
        }
        [self.searchRespBtn2 setTitle:str forState:UIControlStateNormal];
    } failure:^(NSError * _Nonnull error) {
        NSString *failString = [NSString stringWithFormat:@"失败 code:%@ msg:%@", @(error.code), error.localizedDescription];
        [self.searchRespBtn2 setTitle:failString forState:UIControlStateNormal];
    }];
}

- (void)requestWithList {
    
    NSArray *array = [self.listTf.text componentsSeparatedByString:@","];
    [[DJXPlayletManager shareInstance] requestPlayletListWithPlayletId:array success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList) {
        NSMutableString *str = [NSMutableString string];
        for (DJXPlayletInfoModel *model in playletList) {
            [str appendString: [model performSelector:@selector(BUYY_modelToJSONString)]];
            [str appendString:@"/*/"];
        }
        [self.responseBtn2 setTitle:str forState:UIControlStateNormal];
        self.dataArray2 = playletList;
    } failure:^(NSError * _Nonnull error) {
        NSString *failString = [NSString stringWithFormat:@"失败 code:%@ msg:%@", @(error.code), error.localizedDescription];
        [self.responseBtn2 setTitle:failString forState:UIControlStateNormal];
    }];
}

- (void)enterPlayer {
    
    BOOL useListData = YES;
    if ([self.useResponseTf.text isEqualToString:@"1"]) {
        useListData = NO;
    }
    
    DJXPlayletInfoModel *model;
    
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
    
    DJXPlayletConfig *config = [DJXPlayletConfig new];
    config.skitId = model.shortplay_id;
    config.episode = [self.episodeTf.text integerValue];
    config.playletUnlockADMode = self.packageSwitch.isOn ? DJXPlayletUnlockADMode_Common : DJXPlayletUnlockADMode_Specific;
    config.fromTopMargin = [self.topMargin.text integerValue];
    config.playerDelegate = self;
    config.interfaceDelegate = self;
    
    if (self.hiddenSwitch.isOn) {
        config.hideBackButton = YES;
        config.hideMoreButton = YES;
    }
    if (self.infiniteSwitch.isOn) {
        config.closeInfiniteScroll = YES;
    }
    if (self.startTime.text) {
        config.playStartTime = [self.startTime.text floatValue];
    }
    
    self.vc = [[DJXPlayletManager shareInstance] playletViewControllerWithParams:config];
    self.vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.vc animated:YES completion:nil];
}

- (void)enterPlayerWithHistoryData {
    
    if (self.currentSkit == 0) {
        return;
    }
    DJXPlayletConfig *config = [DJXPlayletConfig new];
    config.playletUnlockADMode = DJXPlayletUnlockADMode_Specific;
    config.skitId = self.currentSkit;
    NSInteger currentEpisode = [[NSUserDefaults standardUserDefaults] integerForKey:@(self.currentSkit).stringValue];
    config.episode = currentEpisode;
    
    self.vc = [[DJXPlayletManager shareInstance] playletViewControllerWithParams:config];
    self.vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.vc animated:YES completion:nil];
}

#pragma mark 短剧播放校验(接口接入必须实现)

- (void)nextPlayletWillPlay:(DJXPlayletInfoModel *)infoModel {
    NSLog(@"[短剧回调]接口形式回调 %s skitID:%ld skitName:%@", __func__, infoModel.shortplay_id, infoModel.title);
}

- (void)clickEnterView:(nonnull DJXPlayletInfoModel *)infoModel {
    
}

- (void)playletDetailUnlockFlowStart:(DJXPlayletInfoModel *)infoModel unlockInfoHandler:(void (^)(DJXPlayletUnlockModel * _Nonnull))unlockInfoHandler extraInfo:(NSDictionary * _Nullable)extraInfo {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"看广告解锁"
                                                                   message:[NSString stringWithFormat:@"看一个激励广告解锁%d集", 5]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        DJXPlayletUnlockModel *unlockInfo = [[DJXPlayletUnlockModel alloc] init];
        unlockInfo.cancelUnlock = YES;
        unlockInfoHandler(unlockInfo);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"看广告" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        DJXPlayletUnlockModel *unlockInfo = [[DJXPlayletUnlockModel alloc] init];
        unlockInfo.playletId = infoModel.shortplay_id;
        unlockInfo.unlockEpisodeCount = 5;
        unlockInfoHandler(unlockInfo);
    }]];
    [self.presentedViewController presentViewController:alert animated:YES completion:nil];
}

- (void)playletDetailUnlockFlowShowCustomAD:(DJXPlayletInfoModel *)infoModel onADWillShow:(void (^)(NSString * cpm))onADWillShow onADRewardDidVerified:(void (^)(DJXRewardAdResult * _Nonnull))onADRewardDidVerified {
    !onADWillShow ?: onADWillShow(@"1000");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.presentedViewController.view animated:YES];
    hud.label.text = @"模拟开发者激励广告";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.presentedViewController.view animated:YES];
        DJXRewardAdResult *result = [[DJXRewardAdResult alloc] init];
        result.success = YES;
        result.cpm = @"80";
        !onADRewardDidVerified ?: onADRewardDidVerified(result);
    });
}

- (void)playletDetailUnlockFlowEnd:(DJXPlayletInfoModel *)infoModel success:(BOOL)success error:(NSError *)error extraInfo:(NSDictionary * _Nullable)extraInfo {
    if (success) {
        NSLog(@"《%@》解锁成功", infoModel.title);
    } else if (error.code == DJXPlayletUnlockResult_Request_Error) {
        NSLog(@"《%@》解锁时发生网络错误", infoModel.title);
    } else if (error.code == DJXPlayletUnlockResult_AD_Not_Show) {
        NSLog(@"《%@》广告未展示", infoModel.title);
    } else {
        NSLog(@"《%@》未知错误", infoModel.title);
    }
}

#pragma mark 播放器回调(可选)

- (void)drawVideoContinue:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s skitID:%ld skitName:%@", __func__, config.shortplay_id, config.title);
}

- (void)drawVideoOverPlay:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s skitID:%ld skitName:%@", __func__, config.shortplay_id, config.title);
}

- (void)drawVideoPause:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s skitID:%ld skitName:%@", __func__, config.shortplay_id, config.title);
}

- (void)drawVideoPlayCompletion:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s skitID:%ld skitName:%@", __func__, config.shortplay_id, config.title);
}

- (void)drawVideoStartPlay:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s skitID:%ld skitName:%@", __func__, config.shortplay_id, config.title);
    self.currentSkit = config.shortplay_id;
    [[NSUserDefaults standardUserDefaults] setInteger:config.current_episode forKey:@(config.shortplay_id).stringValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSInteger currentEpisode = [[NSUserDefaults standardUserDefaults] integerForKey:@(config.shortplay_id).stringValue];
    if (currentEpisode > 0) {
        [self.historyPlayButton setTitle:[NSString stringWithFormat:@"播放至%@第%@集", config.title, @(currentEpisode).stringValue] forState:UIControlStateNormal];
    } else {
        [self.historyPlayButton setTitle:@"暂无播放记录，点击播放" forState:UIControlStateNormal];
    }
    
}

- (void)onVideSeekToTime:(NSTimeInterval)endTime inPosition:(NSInteger)position {
    NSLog(@"[短剧回调]播放器回调 %s", __func__);
}

- (void)drawVideo:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config progress:(CGFloat)progress {
    
}


- (void)drawVideoError:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config { 
    
}

#pragma mark 广告回调(接口接入无此回调)
- (void)lcdAdFillFail:(nonnull DJXAdTrackEvent *)event {
    
}

- (void)lcdAdLoadFail:(nonnull DJXAdTrackEvent *)event error:(nonnull NSError *)error {
    
}

- (void)lcdAdLoadSuccess:(nonnull DJXAdTrackEvent *)event {
    
}

- (void)lcdAdWillShow:(nonnull DJXAdTrackEvent *)event {
    
}

- (void)lcdClickAdViewEvent:(nonnull DJXAdTrackEvent *)event {
    
}

- (void)lcdSendAdRequest:(nonnull DJXAdTrackEvent *)event {
    
}

- (void)lcdVideoAdContinue:(nonnull DJXAdTrackEvent *)event {
    
}

- (void)lcdVideoAdOverPlay:(nonnull DJXAdTrackEvent *)event {
    
}

- (void)lcdVideoAdPause:(nonnull DJXAdTrackEvent *)event {
    
}

- (void)lcdVideoAdStartPlay:(nonnull DJXAdTrackEvent *)event {
    
}

- (void)lcdVideoBufferEvent:(nonnull DJXAdTrackEvent *)event {
    
}

- (void)lcdVideoRewardFinishEvent:(DJXAdTrackEvent *)event {
    
}

- (void)lcdVideoRewardSkipEvent:(DJXAdTrackEvent *)event {
    
}

#else
@interface LCSPlayletInterfaceViewController ()
#endif
@end
