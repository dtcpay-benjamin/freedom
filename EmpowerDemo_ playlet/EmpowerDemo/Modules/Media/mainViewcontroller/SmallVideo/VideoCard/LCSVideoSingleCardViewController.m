//
//  LCSVideoSingleCardViewController.m
//  Samples
//
//  Created by yuxr on 2020/8/21.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSVideoSingleCardViewController.h"
#import <LCDSDK/LCDSDK.h>
#import "LCSMacros.h"

@interface LCSVideoSingleCardViewController ()<LCDVideoSingleCardProviderDelegate , LCDAdvertCallBackProtocol >

@property (nonatomic) UIView<LCDVideoSingleCardView> *cardView;
@property (nonatomic) id<LCDViewCustomElement, LCDSmartCroppableElement> element;
@property (nonatomic) UILabel *titleLabel;

@end

@implementation LCSVideoSingleCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    LCDVideoSingleCardProvider.sharedProvider.delegate = self;
    LCDVideoSingleCardProvider.sharedProvider.adDelegate = self;
    LCDVideoSingleCardProvider.sharedProvider.shouldShowPlayIcon = YES;
    LCDVideoSingleCardProvider.sharedProvider.shouldShowTitle = NO;//不展示标题
    
    self.element = [LCDVideoSingleCardProvider.sharedProvider buildViewElement];
    
    CGSize cardSize = CGSizeMake(240, 300); // 需要和-[LCDVideoSingleCardView smartCropSize]的值一致
    [self.element configSmartCropSize:cardSize];
    
    lcs_weakify(self)
    [self.element loadDataWithCompletion:^(id<LCDViewElement>  _Nonnull element, NSError * _Nonnull error) {
        lcs_strongify(self)
        if (error) {
            // 错误处理
        } else {
            self.cardView = [LCDVideoSingleCardProvider.sharedProvider buildView];
            self.cardView.frame = CGRectMake(0, 0, cardSize.width, cardSize.height);
            [self.cardView refreshData:element];
            
            UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, self.cardView.width+60, self.cardView.height+40)];
            customView.backgroundColor = [UIColor orangeColor];
            [self.view addSubview:customView];
            [LCDNativeTrackManager.shareInstance trackShowEventForComponent:self.cardView];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.frame = CGRectMake(0, 0, customView.width, 20);
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [customView addSubview:titleLabel];
            
            self.cardView.center =   CGPointMake(customView.width/2, customView.height/2+10);
            [customView addSubview:self.cardView];
            
            [self.element registerView:customView];
            LCDNativeDataModel *model = [self.element.nativeDatas firstObject];
            titleLabel.text = model.title;//自定义标题
            self.titleLabel = titleLabel;
        }
    }];
}

- (void)lcdNativeDatasChanged:(NSArray<LCDNativeDataModel *> *)newNativeData {
    LCDNativeDataModel *model = [self.element.nativeDatas firstObject];
    self.titleLabel.text = model.title;//自定义标题
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

- (void)lcdSingleCardClickEvent:(LCDEvent *)event view:(UIView *)view {
    LCS_COMMON_CALLBACK_LOG(@"【SingleCard-event】", @"clicked", nil);
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
