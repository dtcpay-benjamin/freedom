//
//  BUDActionCellView.m
//  BUAdSDKDemo
//
//  Created by bytedance on 2020/3/10.
//  Copyright © 2020年 bytedance. All rights reserved.
//

#import "LCSActionCellView.h"
#import "LCSChannelViewController.h"
#import "LCSTabViewController.h"
#import "UIView+LCSAddition.h"

@interface LCSActionModel ()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) LCSCellType cellType;
@property (nonatomic, copy) dispatch_block_t action;
@end

@implementation LCSActionModel

+ (instancetype)plainTitleActionModel:(NSString *)title cellType:(LCSCellType)type action:(dispatch_block_t)action {
    LCSActionModel *model = [LCSActionModel new];
    model.title = title;
    model.cellType = type;
    model.action = action;
    return model;
}

+ (instancetype)plainTitleActionModel:(NSString *)title cellType:(LCSCellType)cellType containerVCType:(LCSCellContainerVCType)containerVCType rootVC:(UIViewController *)rootVC modelVCBuilder:(UIViewController *(^)(__kindof UIViewController *parentVC))modelVCBuilder {
    lcs_weakify(rootVC)
    switch (containerVCType) {
        case LCSCellContainerVCTypeChannel:
        {
            return [LCSActionModel plainTitleActionModel:[title stringByAppendingString:@"(频道版)"] cellType:cellType action:^{
                lcs_strongify(rootVC)
                LCSChannelViewController *tab = [[LCSChannelViewController alloc] init];
                tab.categoryName = title;
                tab.categoryController = modelVCBuilder ? modelVCBuilder(tab) : nil;
                [rootVC.navigationController pushViewController:tab animated:YES];
            }];
        }
            break;
        case LCSCellContainerVCTypeTab:
        {
            return [LCSActionModel plainTitleActionModel:[title stringByAppendingString:@"(tab版)"] cellType:cellType action:^{
                lcs_strongify(rootVC)
                LCSTabViewController *tab = [[LCSTabViewController alloc] init];
                tab.tabName = title;
                tab.tabController = modelVCBuilder ? modelVCBuilder(tab) : nil;
                tab.modalPresentationStyle = UIModalPresentationFullScreen;
                [rootVC presentViewController:tab animated:YES completion:^{}];
            }];
        }
        case LCSCellContainerVCTypeBanner:
        {
            LCSActionModel *model = [LCSActionModel plainTitleActionModel:[title stringByAppendingString:@"(banner-v2300)"] cellType:cellType action:^{
                lcs_strongify(rootVC)
                UIViewController *modelVC = modelVCBuilder ? modelVCBuilder(nil) : nil;
                modelVC.modalPresentationStyle = UIModalPresentationFullScreen;
                modelVC.hidesBottomBarWhenPushed = YES;
                
                [rootVC presentViewController:modelVC animated:YES completion:^{}];
            }];
            return model;
        }
            break;
        case LCSCellContainerVCTypeCustomTopView:
        {
            LCSActionModel *model = [LCSActionModel plainTitleActionModel:[title stringByAppendingString:@"(自渲染-v2300)"] cellType:cellType action:^{
                lcs_strongify(rootVC)
                UIViewController *modelVC = modelVCBuilder ? modelVCBuilder(nil) : nil;
                modelVC.modalPresentationStyle = UIModalPresentationFullScreen;
                modelVC.hidesBottomBarWhenPushed = YES;
                
                [rootVC presentViewController:modelVC animated:YES completion:^{}];
            }];
            return model;
        }
            break;
        case LCSCellContainerVCTypeRoundCorner:
        {
            LCSActionModel *model = [LCSActionModel plainTitleActionModel:[title stringByAppendingString:@"(圆角-v2400)"] cellType:cellType action:^{
                lcs_strongify(rootVC)
                UIViewController *modelVC = modelVCBuilder ? modelVCBuilder(nil) : nil;
                modelVC.modalPresentationStyle = UIModalPresentationFullScreen;
                modelVC.hidesBottomBarWhenPushed = YES;
                
                [rootVC presentViewController:modelVC animated:YES completion:^{}];
            }];
            return model;
        }
            break;
        case LCSCellContainerVCTypeSingle:
        default:
        {
            LCSActionModel *model = [LCSActionModel plainTitleActionModel:title cellType:cellType action:^{
                lcs_strongify(rootVC)
                UIViewController *modelVC = modelVCBuilder ? modelVCBuilder(nil) : nil;
                modelVC.modalPresentationStyle = UIModalPresentationFullScreen;
                modelVC.hidesBottomBarWhenPushed = YES;
                
                [rootVC presentViewController:modelVC animated:YES completion:^{}];
            }];
            return model;
        }
            break;
    }
}

- (UIButton *)createCloseButton {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(15, LCS_stautsBarHeight, 24, 24);
    [closeButton setImage:[UIImage imageNamed:@"LCS_closeButton_black"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"LCS_closeButton_black"] forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(didClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    return closeButton;
}

- (void)didClickCloseButton:(UIButton *)button {
    [button.relatedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

@interface LCSActionCellView ()
@property (nonatomic, strong) LCSActionModel *model;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *titleLable;
@end

@implementation LCSActionCellView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.img = [UIImageView new];
        self.img.frame = CGRectMake(15, (self.height - LCS_inconWidth)/2, LCS_inconWidth , LCS_inconWidth);
        [self.contentView addSubview:self.img];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(LCS_inconWidth + self.img.left + 15, self.img.top, 300, LCS_inconWidth)];
        [self.contentView addSubview:self.titleLable];
    }
    return self;
}

- (void)configWithModel:(LCSActionModel *)model {
    if ([model isKindOfClass:[LCSActionModel class]]) {
        self.model = model;
        self.titleLable.text = self.model.title;
        NSString *imageString = nil;
        switch (model.cellType) {
            case LCSCellType_setting:
                imageString = @"LCS_setting.png";
                break;
            case LCSCellType_grid:
                imageString = @"LCS_gridvideo.png";
                break;
            case LCSCellType_feedExplor:
                imageString = @"LCS_explore.png";
                break;
            case LCSCellType_videoCard:
                imageString = @"LCS_videoCard.png";
                break;
            case LCSCellType_feedPraised:
                imageString = @"LCS_praised.png";
                break;
            case LCSCellType_feedFavorit:
                imageString = @"LCS_favorit.png";
                break;
            case LCSCellType_push:
                imageString = @"LCS_push.png";
                break;
            case LCSCellType_live:
                imageString = @"LCS_live.png";
                break;
            case LCSCellType_bind:
                imageString = @"LCS_bind.png";
                break;
            case LCSCellType_unbind:
                imageString = @"LCS_unbind.png";
                break;
            case LCSCellType_mine:
                imageString = @"LCS_Mine.png";
                break;
            default:
                imageString = @"LCS_video.png";
                break;
        }
        self.img.image = [UIImage imageNamed:imageString];
    }
}

- (void)execute {
    if (self.model.action) {
        self.model.action();
    }
}

@end
