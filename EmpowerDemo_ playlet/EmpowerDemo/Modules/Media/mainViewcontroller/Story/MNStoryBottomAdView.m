//
//  MNStoryReaderBottomAdView.m
//  Pods
//
//  Created by liuyunxuan on 2021/5/27.
//

#if __has_include (<PangrowthMiniStory/MNManager.h>)

#import "MNStoryBottomAdView.h"


@interface MNStoryBottomAdView()

@property (nonatomic, strong) UILabel *failView;

@property (nonatomic, strong) UIImageView *adImage;

@property (nonatomic, strong) NSDictionary *readerTrackerDic;

@end

@implementation MNStoryBottomAdView

+ (nonnull instancetype)viewWithNovelReaderBook:(nonnull MNStoryReaderBook *)novelReaderBook {
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self addSubview:self.failView];
        [self addSubview:self.adImage];
        self.failView.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.failView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.adImage.frame = self.bounds;
}

- (void)readerThemeChange:(MNSReaderBackgroundType)type {
    
}

- (UIImageView *)adImage
{
    if (!_adImage) {
        _adImage = [[UIImageView alloc] initWithFrame:self.bounds];
        [_adImage setImage:[UIImage imageNamed:@"mns_bottom_banner"]];
    }
    return _adImage;
}


- (UILabel *)failView
{
    if (!_failView)
    {
        UILabel *label = [[UILabel alloc] init];
        [label setText:@"穿山甲短故事，免费阅读"];
        label.font = [UIFont systemFontOfSize:16.0];
        label.alpha = 0.2;
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        _failView = label;
    }
    return _failView;
}

- (void)refreshBanner {
    //需要重新请求
}

- (void)removeCurrentBanner {
    self.failView.hidden = NO;
}

@end
#endif
