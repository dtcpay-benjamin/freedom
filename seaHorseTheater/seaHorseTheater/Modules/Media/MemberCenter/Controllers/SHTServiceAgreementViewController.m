//
//  SHTServiceAgreementViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/11.
//

#import "SHTServiceAgreementViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>

@interface SHTServiceAgreementViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation SHTServiceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_BACK_COLOR_DARK;
    self.title = @"会员服务协议";
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(self.view);
    }];
}

#pragma mark - actions

- (void)loadRequest:(NSString *)urlStr {
    // 加载网页
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadMainBundleHtml:(NSString *)resourceName {
    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:resourceName withExtension:@"html"];
        NSURL *baseURL = [htmlURL URLByDeletingLastPathComponent]; // 允许访问HTML引用的资源
    [self.webView loadFileURL:htmlURL allowingReadAccessToURL:baseURL];
}

#pragma mark - 懒加载

- (WKWebView *)webView {
    if (!_webView) {
        // 创建WKWebView配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 初始化WKWebView
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webView.navigationDelegate = self; // 设置代理
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_webView];
    }
    return _webView;
}

#pragma mark - WKNavigationDelegate

// 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载...");
}

// 页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
}

// 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败：%@", error.localizedDescription);
}

@end
