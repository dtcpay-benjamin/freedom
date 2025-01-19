//
//  LCSVideoCardViewController.m
//  Samples
//
//  Created by yuxr on 2020/7/16.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSVideoCardViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LCSMacros.h"
#import "LCSSmallVideoSettingViewController.h"
#import "LCSVideoCardDislikeView.h"

@interface LCSVideoCardCell : UITableViewCell

@property (nonatomic) UIView<LCDVideoCardView> *elementView;

- (void)updateWithElement:(id<LCDViewElement>)element;

@end

@implementation LCSVideoCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.elementView = [LCDVideoCardProvider.sharedProvider buildView];
        [self.contentView addSubview:self.elementView];
    }
    return self;
}

- (void)updateWithElement:(id<LCDViewElement>)element {
    [self.elementView refreshData:element];
}

@end

@interface LCSVideoCardViewController ()<UITableViewDataSource, UITableViewDelegate, LCDVideoCardProviderDelegate , LCDAdvertCallBackProtocol , LCDVideoCardProviderUIDelegate>

@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) id<LCDViewElement> viewElement;

@end

@implementation LCSVideoCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.dataArray = [NSMutableArray array];

    if (self.videoCardType == LCDVideoCardType2_4) {
        LCDVideoCardProvider.sharedProvider.cardType = LCDVideoCardType2_4;
    } else {
        LCDVideoCardProvider.sharedProvider.cardType = LCDVideoCardTypeDefault;
    }
    LCDVideoCardProvider.sharedProvider.delegate = self;
    if ([lcsGetSmallVideoSettings() boolForKey:kLCSSmallVideoSettingKey_customVideoCardDislike]) {
        // 自定义dislike
        LCDVideoCardProvider.sharedProvider.UIDelegate = self;
    }
    LCDVideoCardProvider.sharedProvider.adDelegate = self;
    LCDVideoCardProvider.sharedProvider.rootViewController = self;
    
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [self.tableView registerClass:LCSVideoCardCell.class forCellReuseIdentifier:NSStringFromClass(LCSVideoCardCell.class)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData {
    [self.dataArray removeAllObjects];
    [self addData];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadData {
    [self addData];
    [self.tableView.mj_footer endRefreshing];
}

- (void)addData {
    NSInteger currentDataCount = self.dataArray.count;
    for (NSInteger i = currentDataCount + 1; i <= currentDataCount + 10; i++) {
        if (i % 6 == 0) {
            id<LCDViewElement> viewElement = [LCDVideoCardProvider.sharedProvider buildViewElement];
            [self.dataArray addObject:viewElement];
        } else {
            NSString *dataStr = [NSString stringWithFormat:@"第%ld条数据", (long)i];
            [self.dataArray addObject:dataStr];
        }
    }
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataArray[indexPath.row];
    UITableViewCell *cell = nil;
    if ([model isKindOfClass:NSString.class]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
        cell.textLabel.text = self.dataArray[indexPath.row];
    } else if ([model conformsToProtocol:@protocol(LCDViewElement)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LCSVideoCardCell.class)];
        if ([((id<LCDViewElement>)model) hasLoadData]) {
            cell.contentView.hidden = NO;
            lcs_weakify(self)
            lcs_weakify(tableView)
            ((LCSVideoCardCell *)cell).elementView.didClickDislikeButtonHandler = ^(UIButton * _Nonnull button) {
                lcs_strongify(self)
                lcs_strongify(tableView)
                [self.dataArray replaceObjectAtIndex:indexPath.row withObject:NSNull.null];
                [tableView reloadData];
            };
            [(LCSVideoCardCell *)cell updateWithElement:model];
            [LCDNativeTrackManager.shareInstance trackShowEventForComponent:((LCSVideoCardCell *)cell).elementView];
        } else {
            cell.contentView.hidden = YES;
            lcs_weakify(self)
            [((id<LCDViewElement>)model) loadDataWithCompletion:^(id<LCDViewElement>  _Nonnull element, NSError * _Nonnull error) {
                lcs_strongify(self)
                if (!error
                    && self.dataArray.count > indexPath.row) {
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
                }
            }];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
        cell.textLabel.text = @"";
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataArray[indexPath.row];
    if ([model isKindOfClass:NSString.class]) {
        return 30;
    } else if ([model conformsToProtocol:@protocol(LCDViewElement)]) {
        if ([(id<LCDViewElement>)model hasLoadData]) {
            return LCDVideoCardProvider.sharedProvider.viewHeight;
        }
    }
    return CGFLOAT_MIN;
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
