//
//  LCSCustomSizeVideoCardViewController.m
//  LCDSamples
//
//  Created by yuxr on 2021/7/27.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "LCSCustomSizeVideoCardViewController.h"
#import "LCSMacros.h"
#import <LCDSDK/LCDVideoCardProvider.h>
#import "LCSSmallVideoSettingViewController.h"
#import "LCSVideoCardDislikeView.h"

@interface LCSCustomSizeVideoCardViewController ()<LCDVideoCardProviderDelegate , LCDAdvertCallBackProtocol , LCDVideoCardProviderUIDelegate>

@property (nonatomic) LCDVideoCardProvider *cardProvider;
@property (nonatomic) UIView<LCDVideoCardView> *elementView;
@property (nonatomic) id<LCDViewElement> viewElement;

@end

@implementation LCSCustomSizeVideoCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    LCDVideoCardProvider *cardProvider = [LCDVideoCardProvider new];
    cardProvider.cardType = LCDVideoCardTypeCustom;
    self.cardProvider = cardProvider;
    cardProvider.delegate = self;
    if ([lcsGetSmallVideoSettings() boolForKey:kLCSSmallVideoSettingKey_customVideoCardDislike]) {
        // 自定义dislike
        cardProvider.UIDelegate = self;
    }
    cardProvider.adDelegate = self;
    cardProvider.rootViewController = self;
    
    cardProvider.viewWidth = LCSScreenWidth - 50;
    cardProvider.viewHeight = 200;
    
    self.viewElement = [cardProvider buildViewElement];
    self.elementView = [cardProvider buildView];
    lcs_weakify(self)
    self.elementView.didClickDislikeButtonHandler = ^(UIButton * _Nonnull button) {
        lcs_strongify(self);
        // dislike按钮可以选择多种处理方式
        // 1.直接移除相关view
        [self.elementView removeFromSuperview];
        // 2.在cardProvider初始化的时候使用shouldShowTitleView禁止显示标题栏
    };
    
    self.elementView.lcs_top = 200;
    [self.view addSubview:self.elementView];
    
    [self.viewElement loadDataWithCompletion:^(id<LCDViewElement>  _Nonnull element, NSError * _Nonnull error) {
        lcs_strongify(self)
        [self.elementView refreshData:element];
        [LCDNativeTrackManager.shareInstance trackShowEventForComponent:self.elementView];
    }];
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

- (void)lcdVideoCardClickCellEvent:(LCDEvent *)event cardView:(UIView<LCDVideoCardView> *)cardView {
    LCS_COMMON_CALLBACK_LOG(@"【VideoCard-event】", @" click cell", nil);
}

- (void)lcdVideoCardSwipeEnter:(NSDictionary * _Nullable)params cardView:(UIView<LCDVideoCardView> *)cardView {
    LCDEvent *event = [LCDEvent new];
    event.params = params;
    LCS_COMMON_CALLBACK_LOG(@"【VideoCard-event】", @" swipe enter", nil);
}

#pragma mark - LCDVideoCardProviderUIDelegate
- (UIButton *)lcdVideoCardCellAddCloseBtnInView:(UIView *)superView cardView:(UIView<LCDVideoCardView> *)cardView {
    UIButton *dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat dislikeBtnTop = 5;
    CGFloat dislikeBtnRight = 20;
    CGFloat dislikeBtnWidth = 20;
    dislikeButton.frame = CGRectMake(superView.lcs_width - dislikeBtnRight - dislikeBtnWidth, dislikeBtnTop, dislikeBtnWidth, dislikeBtnWidth);

    dislikeButton.backgroundColor = UIColor.redColor;
    return dislikeButton;
}

- (UIView<LCDVideoCardProviderDislikeView> *)lcdVideoCardCellShowDislikeViewWithCardView:(UIView<LCDVideoCardView> *)cardView {
    LCSVideoCardDislikeView *dislikeView = [[LCSVideoCardDislikeView alloc] initWithFrame:CGRectMake(0, 0, cardView.lcs_width - 40, 100)];
    return dislikeView;
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
@end
