//
//  AppDelegate.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/5/25.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

// 初始化短剧SDK
- (void)initDJX;
// 创建主页
- (void)setUpHome;
@end

