//
//  SHTSearchBarView.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/25.
//

#import "SHTSearchBarView.h"

@interface SHTSearchBarView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation SHTSearchBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    // 输入框
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = @"请输入";
    self.textField.font = SHTUIFontSystem(15);
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.layer.cornerRadius = 16.0;
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.borderColor = SHT_SEARCH_BACK_BORDERCOLOR.CGColor;
    self.textField.layer.borderWidth = 1.0f;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 26, 20)];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
    iconView.frame = CGRectMake(10, 2, 16, 16);
    [leftView addSubview:iconView];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.delegate = self;
    [self addSubview:self.textField];

    // 搜索按钮
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.searchButton.titleLabel.font = SHTUIFontSystem(15);
    [self.searchButton addTarget:self action:@selector(searchTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 12.0;
    CGFloat buttonWidth = 40.0;
    
    self.backButton.frame = CGRectMake(padding, self.bounds.size.height - 40, 40, 40);
    
    self.searchButton.frame = CGRectMake(self.bounds.size.width - padding - 40, self.bounds.size.height - 40, 40, 40);
    
    CGFloat textFieldX = CGRectGetMaxX(self.backButton.frame) + 5;
    CGFloat textFieldWidth = CGRectGetMinX(self.searchButton.frame) - textFieldX - 5;
    self.textField.frame = CGRectMake(textFieldX, self.bounds.size.height - 40, textFieldWidth, 36);
}

#pragma mark - Actions

- (void)backTapped {
    if (self.onBackTapped) {
        self.onBackTapped();
    }
}

- (void)searchTapped {
    if (self.textField.text.length > 0) {
        if (self.onSearchTapped) {
            [self.textField resignFirstResponder];
            self.onSearchTapped(self.textField.text);
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textField.text.length > 0) {
        if (self.onSearchTapped) {
            [textField resignFirstResponder];
            self.onSearchTapped(textField.text);
        }
        return YES;
    } else {
        return NO;
    }
}
@end
