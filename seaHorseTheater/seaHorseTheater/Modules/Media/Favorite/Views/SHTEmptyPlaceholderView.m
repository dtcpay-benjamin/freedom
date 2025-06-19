//
//  SHTEmptyPlaceholderView.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import "SHTEmptyPlaceholderView.h"

@interface SHTEmptyPlaceholderView ()

@property (nonatomic, copy) void(^actionBlock)(void);

@end

@implementation SHTEmptyPlaceholderView


- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(nullable NSString *)imageName
                      message:(NSString *)message
                  buttonTitle:(NSString *)buttonTitle
                  actionBlock:(void(^)(void))actionBlock {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.actionBlock = actionBlock;
        
        CGFloat topSpacing = 80;
        
        // 图片
        if (imageName.length > 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:imageView];
            
            [NSLayoutConstraint activateConstraints:@[
                [imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                [imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:topSpacing],
                [imageView.widthAnchor constraintEqualToConstant:100],
                [imageView.heightAnchor constraintEqualToConstant:100]
            ]];
            topSpacing += 120;
        }
        
        // 文案
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.text = message;
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.font = SHTUIFontSystem(15);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:messageLabel];
        
        [NSLayoutConstraint activateConstraints:@[
            [messageLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [messageLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:topSpacing],
            [messageLabel.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.8]
        ]];
        
        if (buttonTitle.length > 0) {
            // 按钮
            UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [actionButton setTitle:buttonTitle forState:UIControlStateNormal];
            actionButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
            actionButton.titleLabel.font = SHTUIFontBold(16);
            actionButton.tintColor = [UIColor whiteColor];
            actionButton.layer.cornerRadius = 18;
            actionButton.clipsToBounds = YES;
            actionButton.translatesAutoresizingMaskIntoConstraints = NO;
            [actionButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:actionButton];
            
            [NSLayoutConstraint activateConstraints:@[
                [actionButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                [actionButton.topAnchor constraintEqualToAnchor:messageLabel.bottomAnchor constant:20],
                [actionButton.widthAnchor constraintEqualToConstant:120],
                [actionButton.heightAnchor constraintEqualToConstant:36]
            ]];
        }
    }
    return self;
}

- (void)buttonTapped {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
