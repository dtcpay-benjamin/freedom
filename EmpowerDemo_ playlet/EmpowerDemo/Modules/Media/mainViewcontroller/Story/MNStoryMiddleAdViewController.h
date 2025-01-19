//
//  MNStoryMiddleAdViewController.h
//  MNStorySDK
//
//  Created by liuyunxuan on 2020/12/30.
//

#if __has_include (<PangrowthMiniStory/MNManager.h>)

#import <PangrowthMiniStory/MNStoryReaderAdProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface MNStoryMiddleAdViewController: UIViewController<MNStoryReaderNewAdViewControllerProtocol>

+ (instancetype)controllerWithNovelReaderBook:(MNStoryReaderBook *)novelReaderBook
                               insertAdConfig:(MNStoryReaderBaseAdConfig *)insertAdConfig
                             excitingAdConfig:(MNStoryReaderExcitingAdConfig *)excitingAdConfig
                                 chpaterIndex:(NSUInteger)chpaterIndex
                                    pageIndex:(NSInteger)pageIndex
                                     delegate:(id<MNStoryNewAdViewControllerDelegate>)delegate
                                readerContext:(id)readerContext;;

- (void)readerThemeChange:(MNSReaderBackgroundType)type;


// 当前缓存的广告数目
+ (NSInteger)cacheAdCount:(id)readerContext;

+ (NSString *)adFrom;

@property (nonatomic, weak) id<MNStoryNewAdViewControllerDelegate>delegate;

@property (nonatomic, assign) BOOL isTTSSync;
@end

NS_ASSUME_NONNULL_END
#endif
