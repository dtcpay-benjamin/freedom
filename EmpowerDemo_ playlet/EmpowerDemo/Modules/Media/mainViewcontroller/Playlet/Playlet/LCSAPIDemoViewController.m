//
//  LCSAPIDemoViewController.m
//  EmpowerDemo
//
//  Created by ByteDance on 2024/2/28.
//  Copyright © 2024 bytedance. All rights reserved.
//

#import "LCSAPIDemoViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#if __has_include (<PangrowthDJX/DJXSDK.h>)
#import <PangrowthDJX/DJXSDK.h>

@interface LCSAPIDemoViewController ()

@property (nonatomic) UIScrollView *mainScrollView;

@property (nonatomic) UILabel *shortplayIdLabel;

@property (nonatomic) UITextField *shortplayIdTextField;

@property (nonatomic) UILabel *shortplayEpisodeLabel;

@property (nonatomic) UITextField *shortplayEpisodeTextField;

@property (nonatomic) UIButton *likeButton;

@property (nonatomic) UIButton *collectButton;

@property (nonatomic) UIButton *collectionListButton;

@property (nonatomic) UIButton *resultBtn;

@end

@implementation LCSAPIDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:self.mainScrollView];
    
    [self.mainScrollView addSubview:self.shortplayIdLabel];
    [self.mainScrollView addSubview:self.shortplayIdTextField];
    [self.mainScrollView addSubview:self.shortplayEpisodeLabel];
    [self.mainScrollView addSubview:self.shortplayEpisodeTextField];
    [self.mainScrollView addSubview:self.likeButton];
    [self.mainScrollView addSubview:self.collectButton];
    
    [self.mainScrollView addSubview:self.collectionListButton];
    [self.mainScrollView addSubview:self.resultBtn];
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mainScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mainScrollView.contentSize = self.view.frame.size;
    }
    return _mainScrollView;
}

- (UILabel *)shortplayIdLabel {
    if (!_shortplayIdLabel) {
        _shortplayIdLabel = [[UILabel alloc] init];
        _shortplayIdLabel.text = @"短剧id:";
        [_shortplayIdLabel sizeToFit];
        _shortplayIdLabel.frame = CGRectMake(20, 50, _shortplayIdLabel.frame.size.width, _shortplayIdLabel.frame.size.height);
    }
    return _shortplayIdLabel;
}

- (UITextField *)shortplayIdTextField {
    if (!_shortplayIdTextField) {
        _shortplayIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shortplayIdLabel.frame) + 20, self.shortplayIdLabel.frame.origin.y, 120, self.shortplayIdLabel.frame.size.height)];
        _shortplayIdTextField.text = @"14508";
    }
    return _shortplayIdTextField;
}

- (UILabel *)shortplayEpisodeLabel {
    if (!_shortplayEpisodeLabel) {
        _shortplayEpisodeLabel = [[UILabel alloc] init];
        _shortplayEpisodeLabel.text = @"第几集:";
        [_shortplayEpisodeLabel sizeToFit];
        _shortplayEpisodeLabel.frame = CGRectMake(20, CGRectGetMaxY(self.shortplayIdLabel.frame) + 20, _shortplayEpisodeLabel.frame.size.width, _shortplayEpisodeLabel.frame.size.height);
    }
    return _shortplayEpisodeLabel;
}

- (UITextField *)shortplayEpisodeTextField {
    if (!_shortplayEpisodeTextField) {
        _shortplayEpisodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shortplayEpisodeLabel.frame) + 20, self.shortplayEpisodeLabel.frame.origin.y, 120, self.shortplayIdLabel.frame.size.height)];
        _shortplayEpisodeTextField.text = @"1";
    }
    return _shortplayEpisodeTextField;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.shortplayEpisodeLabel.frame) + 20, (self.view.frame.size.width - 60) / 2, 48)];;
        [_likeButton setTitle:@"点赞" forState:UIControlStateNormal];
        [_likeButton setTitle:@"取消点赞" forState:UIControlStateSelected];
        if (@available(iOS 13.0, *)) {
            [_likeButton setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
        } else {
            [_likeButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        }
        [_likeButton addTarget:self action:@selector(onClickLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (void)onClickLikeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[DJXPlayletManager shareInstance] likeShortplay:self.shortplayIdTextField.text.integerValue episode_index:self.shortplayEpisodeTextField.text.integerValue success:^{
            [self showHudView:self.view text:@"点赞成功"];
        } failure:^(NSError * _Nonnull error) {
            [self showHudView:self.view text:@"点赞失败"];            
        }];
    } else {
        [[DJXPlayletManager shareInstance] cancelLikeShortplay:self.shortplayIdTextField.text.integerValue episode_index:self.shortplayEpisodeTextField.text.integerValue success:^{
            [self showHudView:self.view text:@"取消点赞成功"];
        } failure:^(NSError * _Nonnull error) {
            [self showHudView:self.view text:@"取消点赞失败"];
        }];
    }
}

- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 10, self.likeButton.frame.origin.y, (self.view.frame.size.width - 60) / 2, 48)];
        [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectButton setTitle:@"取消收藏" forState:UIControlStateSelected];
        if (@available(iOS 13.0, *)) {
            [_collectButton setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
        } else {
            [_collectButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        }
        [_collectButton addTarget:self action:@selector(onClickCollectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
}

- (void)onClickCollectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[DJXPlayletManager shareInstance] collectShortplay:self.shortplayIdTextField.text.integerValue success:^{
            [self showHudView:self.view text:@"收藏成功"];
        } failure:^(NSError * _Nonnull error) {
            [self showHudView:self.view text:@"收藏失败"];
        }];
    } else {
        [[DJXPlayletManager shareInstance] cancelCollectShortplay:self.shortplayIdTextField.text.integerValue success:^{
            [self showHudView:self.view text:@"取消收藏成功"];
        } failure:^(NSError * _Nonnull error) {
            [self showHudView:self.view text:@"取消收藏失败"];
        }];
    }
}

- (UIButton *)collectionListButton {
    if (!_collectionListButton) {
        _collectionListButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.likeButton.frame.origin.y + 200, self.view.frame.size.width - 40, 48)];
        [_collectionListButton setTitle:@"获取短剧收藏列表" forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_collectionListButton setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
        } else {
            [_collectionListButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        }
        [_collectionListButton addTarget:self action:@selector(onClickCollectionListAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionListButton;
}

- (UIButton *)resultBtn {
    if (!_resultBtn) {
        _resultBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.collectionListButton.frame.origin.y + 200, self.view.frame.size.width - 40, 48)];
        _resultBtn.backgroundColor = UIColor.grayColor;
       [_resultBtn setTitle:@"获取结果，点击复制" forState:UIControlStateNormal];
       [_resultBtn addTarget:self action:@selector(touchResponseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resultBtn;
}

- (void)touchResponseBtn:(UIButton *)responseBtn {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = responseBtn.titleLabel.text;
    [self showHudView:self.view text:@"已复制"];
}

- (void)onClickCollectionListAction:(UIButton *)sender {
    [[DJXPlayletManager shareInstance] requestCollectionList:1 pageSize:20 success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList, BOOL hasMore) {
        [self showHudView:self.view text:[NSString stringWithFormat:@"本次拉取收藏列表%ld个", playletList.count]];
        NSMutableString *str = [NSMutableString string];
        for (DJXPlayletInfoModel *model in playletList) {
            [str appendString: [model performSelector:@selector(BUYY_modelToJSONString)]];
            [str appendString:@"/*/"];
        }
        [self.resultBtn setTitle:str forState:UIControlStateNormal];
    } failure:^(NSError * _Nonnull error) {
        [self showHudView:self.view text:@"拉去收藏列表失败"];
        NSString *failString = [NSString stringWithFormat:@"code:%@ msg:%@", @(error.code), error.localizedDescription];
        [self.resultBtn setTitle:failString forState:UIControlStateNormal];
    }];
}

#pragma mark -- private
- (void)showHudView:(UIView *)view text:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:1];
}

#else
@implementation LCSAPIDemoViewController
#endif
@end
