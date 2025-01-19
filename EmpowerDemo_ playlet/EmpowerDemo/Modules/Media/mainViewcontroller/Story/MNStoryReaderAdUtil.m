//
//  MNStoryReaderAdUtil.m
//  MNStorySDK
//
//  Created by liuyunxuan on 2020/12/30.
//
#if __has_include (<PangrowthMiniStory/MNManager.h>)

#import "MNStoryReaderAdUtil.h"
#import "MNStoryMiddleAdViewController.h"
#import <PangrowthMiniStory/MNStoryCSJRewardVideoObject.h>
#import "MNStoryBottomAdView.h"

@implementation MNStoryReaderAdUtil

- (Class <MNStoryReaderNewAdViewControllerProtocol>)mnStoryNewMiddleAdViewControllerClass
{
    return MNStoryMiddleAdViewController.class;
}

- (Class <MNStoryReaderNewAdViewControllerProtocol>)mnStoryNewPreAdViewControllerClass
{
    return MNStoryMiddleAdViewController.class;
}

- (Class <MNStoryReaderBannerAdViewProtocol>)mnStoryBannerAdViewClass
{
    return MNStoryBottomAdView.class;
}

- (NSObject<MNStoryRewardObjectProtocol> *)fetchRewardObject
{
    return [[MNStoryCSJRewardVideoObject alloc] init];
}

@end
#endif
