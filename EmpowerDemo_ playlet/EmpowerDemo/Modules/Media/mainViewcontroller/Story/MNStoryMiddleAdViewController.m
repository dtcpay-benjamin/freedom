//
//  MNStoryMiddleCSJAdViewController.m
//  MNStorySDK
//
//  Created by liuyunxuan on 2020/12/30.
//
#if __has_include (<PangrowthMiniStory/MNManager.h>)

#import "MNStoryMiddleAdViewController.h"

@interface MNStoryMiddleAdViewController ()

@property (nonatomic, strong) UIImageView *adImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *label;

@end

@implementation MNStoryMiddleAdViewController

+ (nonnull instancetype)controllerWithNovelReaderBook:(nonnull MNStoryReaderBook *)novelReaderBook insertAdConfig:(nonnull MNStoryReaderBaseAdConfig *)insertAdConfig excitingAdConfig:(nonnull MNStoryReaderExcitingAdConfig *)excitingAdConfig chpaterIndex:(NSUInteger)chpaterIndex pageIndex:(NSInteger)pageIndex delegate:(nonnull id<MNStoryNewAdViewControllerDelegate>)delegate readerContext:(id)readerContext {
    return [[self alloc] initWithNovelReaderBook:novelReaderBook insertAdConfig:insertAdConfig excitingAdConfig:excitingAdConfig chpaterIndex:chpaterIndex pageIndex:pageIndex delegate:delegate readerContext:readerContext];
}

- (instancetype)initWithNovelReaderBook:(MNStoryReaderBook *)novelReaderBook
                         insertAdConfig:(MNStoryReaderBaseAdConfig *)insertAdConfig
                       excitingAdConfig:(MNStoryReaderExcitingAdConfig *)excitingAdConfig
                           chpaterIndex:(NSUInteger)chpaterIndex
                              pageIndex:(NSInteger)pageIndex
                               delegate:(id<MNStoryNewAdViewControllerDelegate>)delegate
                          readerContext:(id)readerContext
{
    if (self = [super init])
    {
        self.delegate = delegate;
        [self.class preloadAdWithReaderContext:readerContext];
    
        [self.view setNeedsLayout];
    }
    return self;
}
- (void)readerThemeChange:(MNSReaderBackgroundType)type {
}

- (BOOL)isInterruptAction
{
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.view addSubview:self.backButton];
//    [self.view addSubview:self.label];
    [self.view addSubview:self.adImage];
    self.adImage.center = self.view.center;
}

+ (void)preloadAdWithReaderContext:(id)readerContext
{
    if ([self cacheAdCount:readerContext] > 0)
    {
        return;
    }
  
}

+ (NSInteger)cacheAdCount:(id)readerContext
{
    return 1;
}

+ (nonnull NSString *)adFrom {
    return @"page";
}


- (void)onTapButton {
    if ([self.delegate respondsToSelector:@selector(adDidClickGoNext)]) {
        [self.delegate adDidClickGoNext];
    }
}

- (UIImageView *)adImage
{
    if (!_adImage) {
        _adImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 463)];
        [_adImage setImage:[UIImage imageNamed:@"mns_inter_ad"]];
    }
    return _adImage;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(20, 44, 40, 40);
     
        [_backButton setImage:[UIImage imageNamed:@"navigation_left_button"] forState:UIControlStateNormal];

        [_backButton addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;

}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(60, 44, 200, 40)];
        _label.textColor = [UIColor grayColor];
        _label.font = [UIFont systemFontOfSize:12];
        [_label setText:@"广告是为了更好地支持作者创作"];
    }
    return _label;
}


@end
#endif
