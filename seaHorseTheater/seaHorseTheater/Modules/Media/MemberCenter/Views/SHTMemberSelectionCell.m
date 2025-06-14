//
//  SHTMemberSelectionCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import "SHTMemberSelectionCell.h"
#import "SHTMemberTypeView.h"

@interface SHTMemberSelectionCell()

@property(nonatomic, strong) UIScrollView *scrollView;//滚动视图

@end

@implementation SHTMemberSelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)addSubviews {
    [self.contentView addSubview:self.scrollView];
    [self addScrollSubviews];
}

- (void)addScrollSubviews {
    
}

#pragma mark - 懒加载

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SHTScreenWidth, 500)];
        scrollView.backgroundColor = [UIColor lightGrayColor];
        // 允许水平滚动
        scrollView.contentSize = CGSizeMake(1080, 500); // 宽度大于 scrollView.frame.size.width

        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
