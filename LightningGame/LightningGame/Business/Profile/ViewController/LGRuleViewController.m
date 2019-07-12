//
//  LGRuleViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGRuleViewController.h"
#import <WebKit/WebKit.h>

@interface LGRuleViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, weak) UIProgressView *progressView;

@end

@implementation LGRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"profile_rule");
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.selectionGranularity = WKSelectionGranularityCharacter;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight)
                                  configuration:configuration];
    _webView.opaque = false;
    _webView.backgroundColor = kMainBgColor;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.53:8080/rule.html"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double progress = [change[NSKeyValueChangeNewKey] doubleValue];;
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:progress animated:YES];
        
        if(progress >= 1.0f) {
            [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
        
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Getter

- (UIProgressView *)progressView {
    if (!_progressView) {
        UIProgressView *view = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        view.alpha = 0.0;
        view.progressTintColor = kMainOnTintColor;
        view.trackTintColor = kMainBgColor;
        view.frame = CGRectMake(0, kNavBarHeight, kScreenWidth, 2.0);
        [self.view addSubview:view];
        _progressView = view;
    }
    return _progressView;
}

@end
