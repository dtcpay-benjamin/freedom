//
//  LCSPlayletCardSettingsViewController.m
//  EmpowerDemo
//
//  Created by admin on 2023/6/1.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import "LCSPlayletCardSettingsViewController.h"
#import "LCSPlayletCardDemoViewController.h"

@interface LCSLineView : UIView

@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) UISwitch *valueSwitch;

@property (nonatomic) UIView *seperator;

@property (nonatomic, copy) NSString *title;

@end

@implementation LCSLineView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        [self addSubview:self.titleLabel];
        [self addSubview:self.valueSwitch];
        [self addSubview:self.seperator];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.title;
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake(10, (self.frame.size.height - _titleLabel.frame.size.height) / 2, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    }
    return _titleLabel;
}

- (UISwitch *)valueSwitch {
    if (!_valueSwitch) {
        _valueSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - 61, (self.frame.size.height - 30) / 2, 51, 31)];
    }
    return _valueSwitch;
}

- (UIView *)seperator {
    if (!_seperator) {
        _seperator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        if (@available(iOS 13.0, *)) {
            _seperator.backgroundColor = UIColor.systemFillColor;
        } else {
            _seperator.backgroundColor = UIColor.grayColor;
        }
    }
    return _seperator;
}

@end


@interface LCSPlayletCardSettingsViewController ()

@property (nonatomic) UIScrollView *mainScrollView;

@property (nonatomic) LCSLineView *playletIDLine;
@property (nonatomic) UITextField *playletIDTextField;

@property (nonatomic) LCSLineView *widthLine;
@property (nonatomic) UITextField *widthTextField;

@property (nonatomic) LCSLineView *autoplayLine;
@property (nonatomic) LCSLineView *loopLine;
@property (nonatomic) LCSLineView *muteLine;
@property (nonatomic) LCSLineView *hideUILine;
@property (nonatomic) LCSLineView *hidePlayButtonLine;
@property (nonatomic) LCSLineView *hideMuteButtonLine;

@property (nonatomic) UIButton *enterButton;

@end

@implementation LCSPlayletCardSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:self.mainScrollView];
    
    [self.mainScrollView addSubview:self.playletIDLine];
    [self.mainScrollView addSubview:self.widthLine];
    [self.mainScrollView addSubview:self.autoplayLine];
    [self.mainScrollView addSubview:self.loopLine];
    [self.mainScrollView addSubview:self.muteLine];
    [self.mainScrollView addSubview:self.hideUILine];
    [self.mainScrollView addSubview:self.hidePlayButtonLine];
    [self.mainScrollView addSubview:self.hideMuteButtonLine];
    
    [self.mainScrollView addSubview:self.enterButton];
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mainScrollView.alwaysBounceVertical = YES;
        _mainScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _mainScrollView;
}

- (LCSLineView *)playletIDLine {
    if (!_playletIDLine) {
        _playletIDLine = [[LCSLineView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50) title:@"短剧id"];
        _playletIDLine.valueSwitch.hidden = YES;
        [_playletIDLine addSubview:self.playletIDTextField];
    }
    return _playletIDLine;
}

- (UITextField *)playletIDTextField {
    if (!_playletIDTextField) {
        _playletIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.width - 100, 7, 90, 36)];
        _playletIDTextField.textAlignment = NSTextAlignmentRight;
        _playletIDTextField.text = @"2305";
        _playletIDTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _playletIDTextField;
}

- (LCSLineView *)widthLine {
    if (!_widthLine) {
        _widthLine = [[LCSLineView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 50) title:@"卡片宽度"];
        _widthLine.valueSwitch.hidden = YES;
        [_widthLine addSubview:self.widthTextField];
    }
    return _widthLine;
}

- (UITextField *)widthTextField {
    if (!_widthTextField) {
        _widthTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.width - 100, 7, 90, 36)];
        _widthTextField.textAlignment = NSTextAlignmentRight;
        _widthTextField.text = @"120";
        _widthTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _widthTextField;
}

- (LCSLineView *)autoplayLine {
    if (!_autoplayLine) {
        _autoplayLine = [[LCSLineView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 50) title:@"自动播放"];
        _autoplayLine.valueSwitch.on = YES;
    }
    return _autoplayLine;
}

- (LCSLineView *)loopLine {
    if (!_loopLine) {
        _loopLine = [[LCSLineView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 50) title:@"循环播放"];
        _loopLine.valueSwitch.on = YES;
    }
    return _loopLine;
}

- (LCSLineView *)muteLine {
    if (!_muteLine) {
        _muteLine = [[LCSLineView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 50) title:@"静音"];
        _muteLine.valueSwitch.on = YES;
    }
    return _muteLine;
}

- (LCSLineView *)hideUILine {
    if (!_hideUILine) {
        _hideUILine = [[LCSLineView alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 50) title:@"隐藏UI"];
    }
    return _hideUILine;
}

- (LCSLineView *)hidePlayButtonLine {
    if (!_hidePlayButtonLine) {
        _hidePlayButtonLine = [[LCSLineView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 50) title:@"隐藏播放按钮"];
    }
    return _hidePlayButtonLine;
}

- (LCSLineView *)hideMuteButtonLine {
    if (!_hideMuteButtonLine) {
        _hideMuteButtonLine = [[LCSLineView alloc] initWithFrame:CGRectMake(0, 450, self.view.frame.size.width, 50) title:@"隐藏静音按钮"];
    }
    return _hideMuteButtonLine;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.frame = CGRectMake(10, 550, self.view.frame.size.width - 20, 48);
        _enterButton.layer.cornerRadius = 8;
        _enterButton.layer.masksToBounds = YES;
        [_enterButton setTitle:@"进入短剧卡片" forState:UIControlStateNormal];
        [_enterButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _enterButton.backgroundColor = UIColor.systemBlueColor;
        [_enterButton addTarget:self action:@selector(onTapEnterButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (void)onTapEnterButton:(UIButton *)sender {
    LCSPlayletCardDemoViewController *vc = [[LCSPlayletCardDemoViewController alloc] init];
    vc.skit_id = self.playletIDTextField.text.integerValue;
    vc.autoplay = self.autoplayLine.valueSwitch.isOn;
    vc.loop = self.loopLine.valueSwitch.isOn;
    vc.mute = self.muteLine.valueSwitch.isOn;
    vc.hideUI = self.hideUILine.valueSwitch.isOn;
    vc.hidePlayButton = self.hidePlayButtonLine.valueSwitch.isOn;
    vc.hideMuteButton = self.hideMuteButtonLine.valueSwitch.isOn;
    vc.cardWith = self.widthTextField.text.doubleValue;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
