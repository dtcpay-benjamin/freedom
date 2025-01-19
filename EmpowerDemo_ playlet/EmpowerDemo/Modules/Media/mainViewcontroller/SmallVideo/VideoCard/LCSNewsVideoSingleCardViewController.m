//
//  LCSNewsVideoSingleCardViewController.m
//  LCDSamples
//
//  Created by iCuiCui on 2020/9/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "LCSNewsVideoSingleCardViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <LCDSDK/LCDNewsVideoSingleCardProvider.h>
#import "LCSMacros.h"

@interface LCSNewsVideoSingleCardCell : UITableViewCell

@property (nonatomic) UIView<LCDNewsVideoSingleCardView> *elementView;

- (void)updateWithElement:(id<LCDViewCustomElement>)element;

@end

@implementation LCSNewsVideoSingleCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.elementView = [LCDNewsVideoSingleCardProvider.sharedProvider buildView];
        [self.contentView addSubview:self.elementView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 上下左右留白
    self.elementView.frame = CGRectMake(12, 12, self.bounds.size.width-12*2, self.bounds.size.height-12*2);
}

- (void)updateWithElement:(id<LCDViewCustomElement>)element {
    [self.elementView refreshData:element];
    // 注册四周白边的点击事件
    [element unregisterView];
    [element registerView:self.contentView];
    // 可以取到原始数据
//    LCDNativeDataModel *model = [[element nativeDatas] firstObject];
    
}

@end

@interface LCSNewsVideoSingleCardViewController ()<UITableViewDataSource, UITableViewDelegate, LCDNewsVideoSingleCardProviderDelegate , LCDAdvertCallBackProtocol >
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) BOOL updating;

@end

@implementation LCSNewsVideoSingleCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.dataArray = [NSMutableArray array];
    
    LCDNewsVideoSingleCardProvider.sharedProvider.delegate = self;
    LCDNewsVideoSingleCardProvider.sharedProvider.adDelegate = self;
    LCDNewsVideoSingleCardProvider.sharedProvider.rootViewController = self;
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [self.tableView registerClass:LCSNewsVideoSingleCardCell.class forCellReuseIdentifier:NSStringFromClass(LCSNewsVideoSingleCardCell.class)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData {
    if (self.updating) {
        return;
    }
    self.updating = YES;
    [self.dataArray removeAllObjects];
    [self addData];
}

- (void)loadData {
    if (self.updating) {
        return;
    }
    self.updating = YES;
    [self addData];
}

- (void)addData {
    NSInteger currentDataCount = self.dataArray.count;
    dispatch_group_t dgroup = dispatch_group_create();
    for (NSInteger i = currentDataCount + 1; i <= currentDataCount + 10; i++) {
        if (i % 6 == 0) {// 拼接内容数据
            id<LCDViewCustomElement, LCDSmartCroppableElement> viewElement = [LCDNewsVideoSingleCardProvider.sharedProvider buildViewElement];
            [viewElement configSmartCropSize:CGSizeMake(390, 275)];
            [self.dataArray addObject:viewElement];
            dispatch_group_enter(dgroup);
            [viewElement loadDataWithCompletion:^(id<LCDViewElement>  _Nonnull element, NSError * _Nonnull error) {
                dispatch_group_leave(dgroup);
            }];
        } else {
            NSString *dataStr = [NSString stringWithFormat:@"第%ld条数据", (long)i];
            [self.dataArray addObject:dataStr];
        }
    }
    dispatch_group_notify(dgroup, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.updating = NO;
    });
}

#pragma mark UITableViewDataSource && UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataArray[indexPath.row];
    UITableViewCell *cell = nil;
    if ([model isKindOfClass:NSString.class]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
        cell.textLabel.text = self.dataArray[indexPath.row];
    }else if ([model conformsToProtocol:@protocol(LCDViewCustomElement)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LCSNewsVideoSingleCardCell.class)];
        if ([((id<LCDViewCustomElement>)model) hasLoadData]) {
            cell.contentView.hidden = NO;
            [(LCSNewsVideoSingleCardCell *)cell updateWithElement:model];
            [LCDNativeTrackManager.shareInstance trackShowEventForComponent:((LCSNewsVideoSingleCardCell *)cell).elementView];
        } else {
            cell.contentView.hidden = YES;
            lcs_weakify(self)
            [((id<LCDViewCustomElement>)model) loadDataWithCompletion:^(id<LCDViewElement>  _Nonnull element, NSError * _Nonnull error) {
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
    } else if ([model conformsToProtocol:@protocol(LCDViewCustomElement)]) {
        if ([(id<LCDViewCustomElement>)model hasLoadData]) {
            // 上下左右留白
            return [LCDNewsVideoSingleCardProvider.sharedProvider heightForElement:model viewWidth:LCSScreenWidth-12*2] + 12*2;
        }
    }
    return CGFLOAT_MIN;
}

#pragma mark - LCDNewsVideoSingleCardProviderDelegate
- (void)lcdNewsVideoSingleCardClickEvent:(nonnull LCDEvent *)event view:(UIView *)view {
    LCS_COVER_CALLBACK_LOG(@"click view");
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
