//
//  LCSMiniStoryDemoViewController.m
//  EmpowerDemo
//
//  Created by admin on 2023/12/8.
//  Copyright © 2023 bytedance. All rights reserved.
//

#if __has_include (<PangrowthMiniStory/MNManager.h>)

#import "LCSMiniStoryDemoViewController.h"
#import <PangrowthMiniStory/MNStoryManager.h>
#import "MNStoryReaderAdUtil.h"
#import <BUAdSDK/BUNativeExpressRewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>
#import "MNStoryMiddleAdViewController.h"
#import "MNStoryBottomAdView.h"

@interface LCSStoryLineView : UIView

@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) UISwitch *valueSwitch;

@property (nonatomic) UITextField *valueTextField;

@property (nonatomic) UIView *seperator;

@property (nonatomic, copy) NSString *title;

@end

@implementation LCSStoryLineView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    return [self initWithFrame:frame title:title hideSwitch:NO hideTextField:YES];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title hideSwitch:(BOOL)hideSwitch hideTextField:(BOOL)hideTextField {
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        [self addSubview:self.titleLabel];
        [self addSubview:self.valueSwitch];
        self.valueSwitch.hidden = hideSwitch;
        [self addSubview:self.valueTextField];
        self.valueTextField.hidden = hideTextField;
        [self addSubview:self.seperator];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.title;
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake(20, (self.frame.size.height - _titleLabel.frame.size.height) / 2, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    }
    return _titleLabel;
}

- (UISwitch *)valueSwitch {
    if (!_valueSwitch) {
        _valueSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - 81, (self.frame.size.height - 30) / 2, 51, 31)];
    }
    return _valueSwitch;
}

- (UITextField *)valueTextField {
    if (!_valueTextField) {
        _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, 7, 80, 36)];
//        _valueTextField.textAlignment = NSTextAlignmentRight;
        _valueTextField.text = @"";
        _valueTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _valueTextField;
}

- (UIView *)seperator {
    if (!_seperator) {
        _seperator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        if (@available(iOS 13.0, *)) {
            _seperator.backgroundColor = UIColor.systemFillColor;
        } else {
            _seperator.backgroundColor = UIColor.grayColor;
        }
    }
    return _seperator;
}

@end

@implementation LCSCustomRewardEntryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.myButton];
    }
    return self;
}

- (void)onThemeChanged:(UIColor *)backgroundColor {
    CGFloat red, green, blue, alpha;
    [backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    [_myButton setBackgroundColor:[UIColor colorWithRed:1-red green:1-green blue:1-blue alpha:1]];
    [_myButton setTitleColor:backgroundColor forState:UIControlStateNormal];
}

- (UIButton *)entryButton {
    return self.myButton;
}

- (UIButton *)myButton {
    if (!_myButton) {
        _myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _myButton.frame = CGRectMake(20, 0, self.frame.size.width - 40, 48);
        _myButton.backgroundColor = UIColor.whiteColor;
        [_myButton setTitle:@"自定义激励入口按钮" forState:UIControlStateNormal];
        [_myButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    return _myButton;
}

@end

@interface LCSInsertView : UIView <MNStoryThemeViewProtocol>

@end

@implementation LCSInsertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)onThemeChanged:(UIColor *)backgroundColor {
    
}

@end


@interface LCSMiniStoryDemoViewController () <MNStoryReaderDelegate, BUNativeExpressRewardedVideoAdDelegate>

@property (nonatomic) UIScrollView *mainScrollView;

@property (nonatomic) LCSStoryLineView *storyIdLine;
@property (nonatomic) UITextField *storyIdTextField;

@property (nonatomic) LCSStoryLineView *customADLine;
@property (nonatomic) LCSStoryLineView *unlockPointLine;
@property (nonatomic) LCSStoryLineView *middleADLine;
@property (nonatomic) LCSStoryLineView *bottomBannerLine;
@property (nonatomic) LCSStoryLineView *customUnlcokEntryViewLine;
@property (nonatomic) LCSStoryLineView *customUnlcokEntryViewLineOriginY;

@property (nonatomic) LCSStoryLineView *fontSizeLevelLine;
@property (nonatomic) LCSStoryLineView *fontSizeLine;
@property (nonatomic) LCSStoryLineView *turnPageLine;

@property (nonatomic) LCSStoryLineView *insertViewLine; // 是否插入View
@property (nonatomic) LCSStoryLineView *insertGapLine; // 多少页展示一个
@property (nonatomic) LCSStoryLineView *insertStartLine; // 从第几行开始插入
@property (nonatomic) LCSStoryLineView *insertViewHeight; // 插入View的高度

@property (nonatomic) LCSStoryLineView *onlyTextLine;

@property (nonatomic) UIButton *enterButton;

@property (nonatomic, copy) void (^rewardADResultBlock)(MNStoryRewardADResult * _Nonnull);

@property (nonatomic) BUNativeExpressRewardedVideoAd *rewardedVideoAd;

@property (nonatomic) NSMutableDictionary<NSString *, NSNumber *> *unlockMap;

@property (nonatomic, copy) NSString *currentKey;

@end

@implementation LCSMiniStoryDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:self.mainScrollView];
    
    [self.mainScrollView addSubview:self.storyIdLine];
    [self.mainScrollView addSubview:self.customADLine];
    [self.mainScrollView addSubview:self.unlockPointLine];
    [self.mainScrollView addSubview:self.middleADLine];
    [self.mainScrollView addSubview:self.bottomBannerLine];
    [self.mainScrollView addSubview:self.customUnlcokEntryViewLine];
    
    [self.mainScrollView addSubview:self.fontSizeLevelLine];
    [self.mainScrollView addSubview:self.fontSizeLine];
    [self.mainScrollView addSubview:self.turnPageLine];
    
    [self.mainScrollView addSubview:self.insertViewLine];
    [self.mainScrollView addSubview:self.insertGapLine];
    [self.mainScrollView addSubview:self.insertStartLine];
    [self.mainScrollView addSubview:self.insertViewHeight];
    [self.mainScrollView addSubview:self.onlyTextLine];
    [self.mainScrollView addSubview:self.customUnlcokEntryViewLineOriginY];
    
    [self.mainScrollView addSubview:self.enterButton];
    
    self.mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.enterButton.frame) + 300);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mainScrollView.alwaysBounceVertical = YES;
        _mainScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _mainScrollView;
}

- (LCSStoryLineView *)storyIdLine {
    if (!_storyIdLine) {
        _storyIdLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) title:@"短故事id" hideSwitch:YES hideTextField:NO];
        _storyIdLine.valueTextField.text = @"3143";
    }
    return _storyIdLine;
}

- (LCSStoryLineView *)customADLine {
    if (!_customADLine) {
        _customADLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50) title:@"是否自定义激励"];
    }
    return _customADLine;
}

- (LCSStoryLineView *)unlockPointLine {
    if (!_unlockPointLine) {
        _unlockPointLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50) title:@"是否插入解锁点"];
    }
    return _unlockPointLine;
}

- (LCSStoryLineView *)middleADLine {
    if (!_middleADLine) {
        _middleADLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 50) title:@"是否插入章间广告"];
    }
    return _middleADLine;
}

- (LCSStoryLineView *)bottomBannerLine {
    if (!_bottomBannerLine) {
        _bottomBannerLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 50) title:@"是否使用底部Banner广告"];
    }
    return _bottomBannerLine;
}

- (LCSStoryLineView *)customUnlcokEntryViewLine {
    if (!_customUnlcokEntryViewLine) {
        _customUnlcokEntryViewLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 50) title:@"是否自定义激励入口View"];
    }
    return _customUnlcokEntryViewLine;
}

- (LCSStoryLineView *)fontSizeLevelLine {
    if (!_fontSizeLevelLine) {
        _fontSizeLevelLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 50) title:@"字体档位(0,1,2,3,4,5)" hideSwitch:YES hideTextField:NO];
        _fontSizeLevelLine.valueTextField.text = @"1";
    }
    return _fontSizeLevelLine;
}

- (LCSStoryLineView *)fontSizeLine {
    if (!_fontSizeLine) {
        _fontSizeLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 50) title:@"字体大小(10<=X<=40)" hideSwitch:YES hideTextField:NO];
        _fontSizeLine.valueTextField.text = @"20";
    }
    return _fontSizeLine;
}

- (LCSStoryLineView *)turnPageLine {
    if (!_turnPageLine) {
        _turnPageLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 50) title:@"翻页模式" hideSwitch:YES hideTextField:NO];
        _turnPageLine.valueTextField.text = @"1";
    }
    return _turnPageLine;
}

- (LCSStoryLineView *)insertViewLine {
    if (!_insertViewLine) {
        _insertViewLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 450, self.view.frame.size.width, 50) title:@"是否插入文字中间View"];
    }
    return _insertViewLine;
}

- (LCSStoryLineView *)insertGapLine {
    if (!_insertGapLine) {
        _insertGapLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 500, self.view.frame.size.width, 50) title:@"多少页插入一个" hideSwitch:YES hideTextField:NO];
        _insertGapLine.valueTextField.text = @"2";
    }
    return _insertGapLine;
}

- (LCSStoryLineView *)insertStartLine {
    if (!_insertStartLine) {
        _insertStartLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 550, self.view.frame.size.width, 50) title:@"从第几行插入" hideSwitch:YES hideTextField:NO];
        _insertStartLine.valueTextField.text = @"3";
    }
    return _insertStartLine;
}

- (LCSStoryLineView *)insertViewHeight {
    if (!_insertViewHeight) {
        _insertViewHeight = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 600, self.view.frame.size.width, 50) title:@"插入View的高度" hideSwitch:YES hideTextField:NO];
        _insertViewHeight.valueTextField.text = @"200";
    }
    return _insertViewHeight;
}

- (LCSStoryLineView *)onlyTextLine {
    if (!_onlyTextLine) {
        _onlyTextLine = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 650, self.view.frame.size.width, 50) title:@"书末推荐是否纯文字样式" hideSwitch:NO hideTextField:YES];
    }
    return _onlyTextLine;
}

- (LCSStoryLineView *)customUnlcokEntryViewLineOriginY {
    if (!_customUnlcokEntryViewLineOriginY) {
        _customUnlcokEntryViewLineOriginY = [[LCSStoryLineView alloc] initWithFrame:CGRectMake(0, 700, self.view.frame.size.width, 50) title:@"自定义激励入口View的位置Y" hideSwitch:YES hideTextField:NO];
        _customUnlcokEntryViewLineOriginY.valueTextField.text = @"200";
    }
    return _customUnlcokEntryViewLineOriginY;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.frame = CGRectMake(10, 800, self.view.frame.size.width - 20, 48);
        _enterButton.layer.cornerRadius = 8;
        _enterButton.layer.masksToBounds = YES;
        [_enterButton setTitle:@"进入短故事" forState:UIControlStateNormal];
        [_enterButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _enterButton.backgroundColor = UIColor.systemBlueColor;
        [_enterButton addTarget:self action:@selector(onTapEnterButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (void)onTapEnterButton:(UIButton *)sender {
    MNStoryReaderOpenParams *params = [[MNStoryReaderOpenParams alloc] init];
    params.storyId = self.storyIdLine.valueTextField.text.integerValue ?: 3143;
    params.customRewardAD = self.customADLine.valueSwitch.isOn;
    params.addCustomRewardPoint = self.unlockPointLine.valueSwitch.isOn;
    params.showCustomBottomBannerAD = self.bottomBannerLine.valueSwitch.isOn;
    params.showCustomMiddleAD = self.middleADLine.valueSwitch.isOn;
    params.pageIntervalForMiddleAD = 4;
    params.customRewardEntryView = self.customUnlcokEntryViewLine.valueSwitch.isOn;
    
    params.fontSizeLevel = self.fontSizeLevelLine.valueTextField.text.integerValue;
    params.fontSize = self.fontSizeLine.valueTextField.text.integerValue;
    params.pageTurnType = self.turnPageLine.valueTextField.text.integerValue;
    
    params.insertViewInsideContent = self.insertViewLine.valueSwitch.isOn;
    params.startLineForInsertView = self.insertStartLine.valueTextField.text.integerValue;
    params.pageIntervalForInsertView = self.insertGapLine.valueTextField.text.integerValue;
    params.insertViewHeight = self.insertViewHeight.valueTextField.text.doubleValue;
    
    params.endPageCellStyle = self.onlyTextLine.valueSwitch.isOn ? MNStoryEndPageCellStyleText : MNStoryEndPageCellStyleImageText;
    
    params.delegate = self;
    params.responder = self;
    
    [[MNStoryManager shareInstance] openMiniStory:params];
}

#pragma mark - MNStoryReaderDelegate

- (Class<MNStoryReaderBannerAdViewProtocol>)mns_bottomBannerADClass {
    return [MNStoryBottomAdView class];
}

- (Class<MNStoryReaderNewAdViewControllerProtocol>)mns_middleADClass {
    return [MNStoryMiddleAdViewController class];
}

- (UIView<MNStoryThemeViewProtocol> *)mns_insertViewInsideContent:(CGSize)containerSize {
    return [[LCSInsertView alloc] initWithFrame:CGRectMake(0, 0, containerSize.width, containerSize.height)];
}

- (BOOL)mns_shouldShowEntryView:(MNStorySessionContext *)sessionContext {
    self.currentKey = [NSString stringWithFormat:@"%ld_%ld", sessionContext.chapterIndex, sessionContext.pageIndex];
    if ([self.unlockMap objectForKey:self.currentKey].boolValue) {
        return NO;
    }
    if (sessionContext.pageIndex == 0 && sessionContext.isTextPage) {
        [self.unlockMap setObject:@(NO) forKey:self.currentKey];
        return YES;
    }
    return NO;
}

- (UIView<MNStoryRewardADEntryViewProtocol> *)mns_rewardEntryView:(MNStorySessionContext *)sessionContext {
    NSLog(@"#短故事# %s", __FUNCTION__);
    return [[LCSCustomRewardEntryView alloc] initWithFrame:CGRectMake(0, self.customUnlcokEntryViewLineOriginY.valueTextField.text.doubleValue, self.view.frame.size.width, 48)];
}

- (void)mns_onUnlockFlowStart:(MNStorySessionContext *)sessionContext {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

- (void)mns_showCustomAD:(MNStorySessionContext *)sessionContext onADWillShow:(void (^)(NSString * cpm))onADWillShow onADRewardDidVerified:(void (^)(MNStoryRewardADResult * _Nonnull))onADRewardDidVerified {
    NSLog(@"#短故事# %s", __FUNCTION__);
    !onADWillShow ?: onADWillShow(@"1000");
    self.rewardADResultBlock = onADRewardDidVerified;
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    self.rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:@"954640448" rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
    
    NSString *key = [NSString stringWithFormat:@"%ld_%ld", sessionContext.chapterIndex, sessionContext.pageIndex];
    [self.unlockMap setObject:@(YES) forKey:key];
}

- (void)mns_onUnlockFlowEnd:(MNStorySessionContext *)sessionContext success:(BOOL)success error:(NSError *)error {
    NSLog(@"#短故事# %s", __FUNCTION__);
    if (success) {
        self.currentKey = [NSString stringWithFormat:@"%ld_%ld", sessionContext.chapterIndex, sessionContext.pageIndex];
        [self.unlockMap setObject:@(YES) forKey:self.currentKey];
    }
}

- (void)mns_startReading:(MNStorySessionContext *)sessionContext {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

- (void)mns_turnPage:(MNStorySessionContext *)sessionContext from:(NSInteger)fromPage to:(NSInteger)toPage {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

- (void)mns_stopReading:(MNStorySessionContext *)sessionContext {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

- (void)mns_finishReading:(MNStorySessionContext *)sessionContext {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

#pragma mark - BURewardedVideoAdDelegate
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    [self.rewardedVideoAd showAdFromRootViewController:self];
}

- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    if (self.rewardedVideoAd) {
        MNStoryRewardADResult *r = [[MNStoryRewardADResult alloc] init];
        r.success = YES;
        self.rewardADResultBlock(r);
        self.rewardADResultBlock = nil;
    }
}

- (NSMutableDictionary<NSString *,NSNumber *> *)unlockMap {
    if (!_unlockMap) {
        _unlockMap = [NSMutableDictionary dictionary];
    }
    return _unlockMap;
}

@end

#endif
