//
//  MNStoryReaderBottomAdView.h
//  Pods
//
//  Created by liuyunxuan on 2021/5/27.
//

#if __has_include (<PangrowthMiniStory/MNManager.h>)

#import <UIKit/UIKit.h>
#import <PangrowthMiniStory/MNStoryReaderAdProtocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface MNStoryBottomAdView : UIView <MNStoryReaderBannerAdViewProtocol>

+ (instancetype)viewWithNovelReaderBook:(MNStoryReaderBook *)novelReaderBook;

- (void)readerThemeChange:(MNSReaderBackgroundType)type;

//如果当前页面没有banner广告，会刷新banner广告
- (void)refreshBanner;

- (void)removeCurrentBanner;

@end

NS_ASSUME_NONNULL_END

#endif
