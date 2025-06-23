//
//  SHTMemberSelectionCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import "SHTMemberSelectionCell.h"
#import "SHTMemberTypeView.h"

@interface SHTMemberSelectionCell()

@property(nonatomic, strong) UIScrollView *scrollView; //滚动视图
@property(nonatomic, strong) NSMutableArray *memberViewsArray; //内容视图数组

@end

@implementation SHTMemberSelectionCell

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setDatas:(NSMutableArray<SHTMemberModel *> *)datas {
    _datas = datas;
    [self addSubviews];
}

- (void)addSubviews {
    [self addScrollSubviews];
}

- (void)addScrollSubviews {
    [self.contentView addSubview:self.scrollView];
    CGFloat x = 0;
    CGFloat y = 20;
    CGFloat width = (SHTScreenWidth - 20 * 2 - 10 * 2) / 3;
    CGFloat height = 143.0;
    for (int i = 0; i < self.datas.count; i++) {
        SHTMemberModel *model = self.datas[i];
        x = 10 + 10 * (i + 1) + width * i;
        SHTMemberTypeView *view = [[SHTMemberTypeView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        view.onTapped = ^{
            // 会员点击事件
            if (self.memberSelectionTapped) {
                self.memberSelectionTapped(model);
            }
        };
        view.model = model;
        [self.scrollView addSubview:view];
        [self.memberViewsArray addObject:view];
    }
}

#pragma mark - 懒加载

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SHTScreenWidth, 183)];
        // 允许水平滚动
        _scrollView.contentSize = CGSizeMake(SHTScreenWidth + 20, 183); // 宽度大于 scrollView.frame.size.width
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
