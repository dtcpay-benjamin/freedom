//
//  LCSHotNewsViewController.m
//  LCDSamples
//
//  Created by yuxr on 2021/7/27.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "LCSHotNewsViewController.h"
#import <LCDSDK/LCDSDK.h>

//#define CUSTOM_COMPONENT

@interface LCSHotNewsViewController ()<LCDDrawVideoViewControllerDelegate, LCDAdvertCallBackProtocol>

@property (nonatomic) LCDNativeDataHolder *notiViewDataHolder;
@property (nonatomic) LCDHotNewsNotificationView *notiView;

@property (nonatomic) LCDNativeDataHolder *hotNewsTextDataHolder;
@property (nonatomic) LCDHotNewsTextGuideView *hotNewsTextGuideView;

@property (nonatomic) LCDNativeDataHolder *hotNewsBannderDataHolder;
@property (nonatomic) LCDHotNewsBannerView *hotNewsBannerView;

@end

@implementation LCSHotNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self addHotNewsTextGuideView];
    [self addHotNewsBubbleView];
    [self addHotNewsBannerView];
    [self showNotiViewAfterDelay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    lcs_weakify(self)
    [self.hotNewsTextDataHolder loadDataWithCompletion:^(NSArray<LCDNativeDataModel *> * _Nullable models, NSDictionary * _Nullable extra, NSError * _Nullable error) {
        lcs_strongify(self)
        [self.hotNewsTextGuideView reloadDataWithDataHolder:self.hotNewsTextDataHolder];
    }];
}

#pragma mark - 文字链组件
- (void)customTextGuideViewStyle:(LCDHotNewsTextGuideView *)view {
#ifdef CUSTOM_COMPONENT
    // 设置文字链组件背景色
    view.backgroundColor = UIColor.lightGrayColor;
    // 设置文字链组件宽高
    view.lcs_size = CGSizeMake(300, 50);
#endif
}

- (void)customTextGuideViewStyleConfig:(LCDHotNewsTextGuideViewConfig *)config {
#ifdef CUSTOM_COMPONENT
    config.customTitleLabelBlock = ^(UILabel * _Nonnull label) {
        // 设置标题内容最大长度
        label.preferredMaxLayoutWidth = 100;
        // 设置标题颜色
        label.textColor = UIColor.redColor;
        // 设置标题字体大小
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:30];
    };
    
    config.customFireImageViewBlock = ^(UIImageView * _Nonnull hotImageView) {
//        hotImageView.hidden = YES;
    };
    
    config.customWatchCountLabelBlock = ^(UILabel * _Nonnull label) {
        // 隐藏点赞信息
//        label.hidden = YES;
    };
    
    // 轮播滚动时间
    config.autoScrollTime = 3;
    // 单条内容停留时间
    config.contentDisplayTime = 3;
#endif
}

- (void)addHotNewsTextGuideView {
    self.hotNewsTextDataHolder = [LCDNativeDataHolder dataHolderWithSceneType:LCDNativeDataHolderSceneType_textChain];
    
    self.hotNewsTextDataHolder.delegate = self;
    self.hotNewsTextDataHolder.adDelegate = self;
//    self.hotNewsTextDataHolder.articleLevel = LCDNativeDataRequestArticleLevel_3;
    
    lcs_weakify(self)
    [self.hotNewsTextDataHolder loadDataWithCompletion:^(NSArray<LCDNativeDataModel *> * _Nullable models, NSDictionary * _Nullable extra, NSError * _Nullable error) {
        lcs_strongify(self)
        if (self) {
            if (models.count > 0) {
                LCDHotNewsTextGuideView *guideView = [[LCDHotNewsTextGuideView alloc] initWithFrame:CGRectMake(0, LCS_navBarHeight, self.view.lcs_width, LCDHotNewsTextGuideViewPreferredHeight)
                                                                                        configBlock:^(LCDHotNewsTextGuideViewConfig * _Nullable config) {
                    // -[LCDNativeTrackManager trackShowEventForComponent:]需要使用的参数
                    config.trackComponentPosition = LCDTrackComponentPosition_home;
                    config.rootVC = self;
                    
                    [self customTextGuideViewStyleConfig:config];
                }];
                self.hotNewsTextGuideView = guideView;
                
                [self customTextGuideViewStyle:self.hotNewsTextGuideView];
                
                [self.view addSubview:guideView];
                
                [guideView reloadDataWithDataHolder:self.hotNewsTextDataHolder];
                [LCDNativeTrackManager.shareInstance trackShowEventForComponent:guideView];
            }
        }
    }];
}

#pragma mark - 气泡组件
- (void)customBubbleViewStyle:(LCDHotNewsBubbleView *)view {
#ifdef CUSTOM_COMPONENT
    // 设置组件背景色
    view.backgroundColor = UIColor.lightGrayColor;
    // 设置组件宽高
    view.lcs_size = CGSizeMake(200, 60);
    view.lcs_right = self.view.lcs_width;
#endif
}

- (void)customBubbleViewStyleConfig:(LCDHotNewsBubbleViewConfig *)config {
#ifdef CUSTOM_COMPONENT
    // 文字对齐方式：左、中、右
//    config.contentAlignment = LCDHotNewsBubbleContentAlignment_center;
    config.contentAlignment = LCDHotNewsBubbleContentAlignment_left;
//    config.contentAlignment = LCDHotNewsBubbleContentAlignment_right;
    
    // 内容左边距或右边距
    config.horizontalPadding = 20;
    
    config.cornerRadius = 20;
    config.maskCorners = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    config.customHotImageViewBlock = ^(UIImageView * _Nonnull hotImageView) {
//        hotImageView.hidden = YES;
    };
    
    config.customTitleLabelBlock = ^(UILabel * _Nonnull label) {
        // 标题内容
        label.text = @"今日头条";
        // 设置标题颜色
        label.textColor = UIColor.redColor;
        // 设置标题字体大小
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20];
    };
#endif
}

- (void)addHotNewsBubbleView {
    LCDHotNewsBubbleView *bubbleView = [LCDHotNewsBubbleView defaultSizeViewWithConfigBlock:^(LCDHotNewsBubbleViewConfig * _Nonnull config) {
        // -[LCDNativeTrackManager trackShowEventForComponent:]需要使用的参数
        config.trackComponentPosition = LCDTrackComponentPosition_tab2;
        config.rootVC = self;
        config.customDataHolderBlock = ^(LCDNativeDataHolder * _Nonnull dataHolder) {
            dataHolder.delegate = self;
            dataHolder.adDelegate = self;
        };
        [self customBubbleViewStyleConfig:config];
    }];
    bubbleView.lcs_right = self.view.lcs_width;
    bubbleView.lcs_top = LCS_navBarHeight + 150;
    [self customBubbleViewStyle:bubbleView];
    [self.view addSubview:bubbleView];
    [LCDNativeTrackManager.shareInstance trackShowEventForComponent:bubbleView];
}

#pragma mark - banner组件
- (void)customBannerViewStyle:(LCDHotNewsBannerView *)view {
#ifdef CUSTOM_COMPONENT
    // 设置组件背景色
    view.backgroundColor = UIColor.lightGrayColor;
    // 设置组件宽高
    view.lcs_size = CGSizeMake(300, 100);
    // 设置圆角大小
    view.layer.cornerRadius = 20;
#endif
}

- (void)customBannerViewStyleConfig:(LCDHotNewsBannerViewConfig *)config {
#ifdef CUSTOM_COMPONENT
    // 标题栏的位置，置顶或置底
    config.infoViewPosition = LCDHotNewsBannerInfoPosition_top;
//    config.infoViewPosition = LCDHotNewsBannerInfoPosition_bottom;
    
    config.infoViewLeftPadding = 12;
    config.infoViewRightPadding = 12;
    config.customTitleLabelBlock = ^(UILabel * _Nonnull label) {
        // 设置标题内容最大长度
        label.preferredMaxLayoutWidth = 100;
        // 设置标题颜色
        label.textColor = UIColor.redColor;
        // 设置标题字体大小
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:30];
    };
    config.customDiggCountLabelBlock = ^(UILabel * _Nonnull label) {
        // 隐藏点赞信息
//        label.hidden = YES;
    };
#endif
}

- (void)addHotNewsBannerView {
    LCDHotNewsBannerView *bannerView = [[LCDHotNewsBannerView alloc] initWithFrame:CGRectMake(0, LCS_navBarHeight + 230, self.view.lcs_width, 200)
                                                                       configBlock:^(LCDHotNewsBannerViewConfig * _Nullable config) {
        // -[LCDNativeTrackManager trackShowEventForComponent:]需要使用的参数
        config.trackComponentPosition = LCDTrackComponentPosition_tab3;
        
        config.rootVC = self;
        [self customBannerViewStyleConfig:config];
    }];
    [self customBannerViewStyle:bannerView];
    [self.view addSubview:bannerView];
    
    self.hotNewsBannerView = bannerView;
    
    self.hotNewsBannderDataHolder = [LCDNativeDataHolder dataHolderWithSceneType:LCDNativeDataHolderSceneType_banner];
    self.hotNewsBannderDataHolder.smartCropSize = bannerView.smartCropSize;
    
    self.hotNewsBannderDataHolder.delegate = self;
    self.hotNewsBannderDataHolder.adDelegate = self;
    
    lcs_weakify(self)
    [self.hotNewsBannderDataHolder loadDataWithCompletion:^(NSArray<LCDNativeDataModel *> * _Nullable models, NSDictionary * _Nullable extra, NSError * _Nullable error) {
        lcs_strongify(self)
        if (self) {
            if (models.count > 0) {
                [self.hotNewsBannerView reloadDataWithDataHolder:self.hotNewsBannderDataHolder];
                [LCDNativeTrackManager.shareInstance trackShowEventForComponent:bannerView];
            }
        }
    }];
}

#pragma mark - 站内push组件
// 站内Push顶部位置
static CGFloat NotiViewTop = 150;
// 页面停留指定时间后才展示站内push
static NSTimeInterval NotiViewDelayShowTime = 3;
- (void)customNotiView:(LCDHotNewsNotificationView *)view {
#ifdef CUSTOM_COMPONENT
    // 长宽
    view.lcs_size = CGSizeMake(300, 150);
#endif
}

- (void)customNotiViewStyleConfig:(LCDHotNewsNotificationViewConfig *)config {
#ifdef CUSTOM_COMPONENT
    config.customImageViewBlock = ^(UIImageView * _Nonnull hotImageView) {
        hotImageView.backgroundColor = UIColor.lightGrayColor;
        hotImageView.layer.cornerRadius = 30;
    };
    config.customTitleLabelBlock = ^(UILabel * _Nonnull label) {
        // 设置标题内容最大长度
        label.preferredMaxLayoutWidth = 100;
        // 设置标题颜色
        label.textColor = UIColor.redColor;
        // 设置标题字体大小
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:30];
    };
    config.customSubTitleLabelBlock = ^(UILabel * _Nonnull label) {
        // 设置子标题颜色
        label.textColor = UIColor.redColor;
        // 设置子标题字体大小
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20];
    };
    
    config.customBackgroundViewBlock = ^(UIView * _Nonnull backgroundView) {
        backgroundView.backgroundColor = UIColor.lightGrayColor;
    };
#endif
}

- (void)customNotiViewAnimation:(LCDHotNewsNotificationViewAnimationConfig *)config {
#ifdef CUSTOM_COMPONENT
    config.appearDuration = 0.5;
    config.showDuration = 5;
    config.disappearDuration = 0.3;
#endif
}

- (void)showNotiViewAfterDelay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NotiViewDelayShowTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.notiViewDataHolder = [LCDNativeDataHolder dataHolderWithSceneType:LCDNativeDataHolderSceneType_inAppPush];
        self.notiViewDataHolder.delegate = self;
        self.notiViewDataHolder.adDelegate = self;
//        self.notiViewDataHolder.articleLevel = LCDNativeDataRequestArticleLevel_2;
        
        lcs_weakify(self)
        [self.notiViewDataHolder loadDataWithCompletion:^(NSArray<LCDNativeDataModel *> * _Nullable models, NSDictionary * _Nullable extra, NSError * _Nullable error) {
            lcs_strongify(self)
            if (self) {
                if (models.count > 0) {
                    LCDHotNewsNotificationView *notiView = [LCDHotNewsNotificationView defaultSizeViewWithConfigBlock:^(LCDHotNewsNotificationViewConfig * _Nullable config) {
                        // -[LCDNativeTrackManager trackShowEventForComponent:]需要使用的参数
                        config.trackComponentPosition = LCDTrackComponentPosition_me;
                        [self customNotiViewStyleConfig:config];
                    }];
                    
                    [self customNotiView:notiView];
                    
                    [notiView reloadDataWithDataHolder:self.notiViewDataHolder];
                    [notiView showInView:self.view onTopY:NotiViewTop rootVC:self animationConfigBlock:^(LCDHotNewsNotificationViewAnimationConfig * _Nullable config) {
                        [self customNotiViewAnimation:config];
                    }];
                    
                    [LCDNativeTrackManager.shareInstance trackShowEventForComponent:notiView];
                }
            }
        }];
    });
}

#pragma mark - LCDDrawVideoViewControllerDelegate
- (void)drawVideoDidClickedErrorButtonRetry:(UIViewController *)viewController {
    LCS_Log(@"LCSCallBack【Draw-event】 retry button click");
}

- (void)drawVideoCloseButtonClicked:(UIViewController *)viewController {
    LCS_Log(@"LCSCallBack【Draw-event】 close button clicked");
}

- (void)drawVideoCurrentVideoChanged:(UIViewController *)viewController event:(LCDEvent *)event {
    NSString *desc = [NSString stringWithFormat:@", currentPageIdx=%@", event.params[@"position"]];
    LCS_COMMON_CALLBACK_LOG(@"【Draw-event】", @"currentPageChanged", desc);
}

#pragma mark - LCDRequestCallBackProtocol
- (void)lcdContentRequestStart:(LCDEvent * _Nullable)event {
    LCS_REQUEST_EVENT_CALLBACK_LOG(@"news request start");
}

- (void)lcdContentRequestSuccess:(NSArray<LCDEvent *> *)events {
    LCDEvent *event = events.firstObject;
    LCS_REQUEST_EVENT_CALLBACK_LOG(@"news request success");
}

- (void)lcdContentRequestFail:(LCDEvent *)event {
    LCS_REQUEST_EVENT_CALLBACK_LOG(@"news request fail");
}

#pragma mark - LCDPlayerCallBackProtocol
- (void)drawVideoStartPlay:(UIViewController *)viewController event:(LCDEvent *)event {
    LCS_PLAYER_CALLBACK_LOG(@"draw video start play");
}

- (void)drawVideoPlayCompletion:(UIViewController *)viewController event:(LCDEvent *)event {
    LCS_PLAYER_CALLBACK_LOG(@"draw video play completion");
}

- (void)drawVideoOverPlay:(UIViewController *)viewController event:(LCDEvent *)event {
    LCS_PLAYER_CALLBACK_LOG(@"draw video over play");
}

- (void)drawVideoPause:(UIViewController *)viewController event:(LCDEvent *)event {
    LCS_PLAYER_CALLBACK_LOG(@"draw video pause");
}

- (void)drawVideoContinue:(UIViewController *)viewController event:(LCDEvent *)event {
    LCS_PLAYER_CALLBACK_LOG(@"draw video continue");
}

#pragma mark - LCDUserInteractionCallBackProtocol
- (void)lcdClickAuthorAvatarEvent:(LCDEvent *)event {
    LCS_COVER_CALLBACK_LOG(@"click author avatar");
}

- (void)lcdClickAuthorNameEvent:(LCDEvent *)event {
    LCS_COVER_CALLBACK_LOG(@"click author name");
}

- (void)lcdClickLikeButton:(BOOL)isLike event:(LCDEvent *)event {
    NSString *desc = [NSString stringWithFormat:@"click like button, isLike:%d", isLike];
    LCS_COVER_CALLBACK_LOG(desc);
}

- (void)lcdClickCommentButtonEvent:(LCDEvent *)event {
    LCS_COVER_CALLBACK_LOG(@"click comment button");
}

- (void)lcdClickShareShareEvent:(LCDEvent *)event {
    LCS_COVER_CALLBACK_LOG(@"click share share");
}

#pragma mark - LCDAdvertCallBackProtocol
- (void)lcdSendAdRequest:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"send ad request");
}

- (void)lcdAdLoadSuccess:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"ad load success");
}

- (void)lcdAdLoadFail:(LCDAdTrackEvent *)event error:(NSError *)error {
    LCS_AD_CALLBACK_LOG(@"ad load fail");
}

- (void)lcdAdFillFail:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"ad fill fail");
}

- (void)lcdAdWillShow:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"ad will show");
}

- (void)lcdVideoAdStartPlay:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"video ad start play");
}

- (void)lcdVideoAdPause:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"video ad pause");
}

- (void)lcdVideoAdContinue:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"video ad continue");
}

- (void)lcdVideoAdOverPlay:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"video ad over play");
}

- (void)lcdClickAdViewEvent:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"click ad view");
}
- (void)lcdDataRefreshCompletion:(NSError *)error {
    NSString *desc = @"data refresh completion";
    if (error) {
        desc = [desc stringByAppendingFormat:@" with error: %@", error.localizedDescription];
    }
    LCS_LOG_WITH_TAG(@"【Draw-event】", desc);
}

- (void)drawVideoDataRefreshCompletion:(NSError *)error {
    NSString *desc = @"new data refresh completion";
    if (error) {
        desc = [desc stringByAppendingFormat:@" with error: %@", error.localizedDescription];
    }
    LCS_LOG_WITH_TAG(@"【Draw-event】", desc);
}

@end
