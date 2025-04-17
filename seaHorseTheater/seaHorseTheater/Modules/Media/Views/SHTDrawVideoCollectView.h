//
//  SHTDrawVideoCollectView.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTDrawVideoCollectView : UIView

@property(nonatomic, copy) void (^collectActionCallBack)(BOOL isCollect);

@end

NS_ASSUME_NONNULL_END
