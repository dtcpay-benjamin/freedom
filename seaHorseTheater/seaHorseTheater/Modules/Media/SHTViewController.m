//
//  SHTViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/22/25.
//

#import "SHTViewController.h"

@interface SHTViewController ()

@end

@implementation SHTViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置导航栏背景颜色（通常需要设置为深色）
    self.navigationController.navigationBar.barTintColor = SHT_BACK_COLOR_DARK;
    // 设置导航栏标题颜色为白色
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName : SHT_BACK_COLOR
    };
    // 设置返回按钮箭头（和其他 UIBarButtonItem）颜色为白色
    self.navigationController.navigationBar.tintColor = SHT_BACK_COLOR;
}

@end
