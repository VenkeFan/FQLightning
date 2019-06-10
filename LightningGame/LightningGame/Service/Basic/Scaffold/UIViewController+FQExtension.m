//
//  UIViewController+FQExtension.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "UIViewController+FQExtension.h"
#import "FQRunTimeUtility.h"

@interface UIViewController () <FQNavigationBarDelegate>

@end

@implementation UIViewController (FQExtension)

+ (void)load {
    swizzleInstanceMethod(self, @selector(viewDidLoad), @selector(swizzle_viewDidLoad));
    swizzleInstanceMethod(self, @selector(viewDidLayoutSubviews), @selector(swizzle_viewDidLayoutSubviews));
}

- (void)setTitle:(NSString *)title {
    if (kIsNullOrEmpty(title)) {
        return;
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    [[self navBar] setTitle:title];
}

#pragma mark - Swizzle Method

- (void)swizzle_viewDidLoad {
    [self swizzle_viewDidLoad];
    
    NSString *clsName = NSStringFromClass([self class]);
    if ([clsName isEqualToString:@"UIInputWindowController"]
        || [clsName isEqualToString:@"UICompatibilityInputViewController"]
        || [clsName isEqualToString:@"UIApplicationRotationFollowingControllerNoTouches"]
        || [clsName isEqualToString:@"UISystemKeyboardDockController"]) {
        return;
    }
    
    self.navigationBarAlwaysFront = YES;
    self.view.backgroundColor = kMainBgColor;
    [self.view addSubview:self.navBar];
}

- (void)swizzle_viewDidLayoutSubviews {
    [self swizzle_viewDidLayoutSubviews];
    
    if (self.navigationBarAlwaysFront) {
        [self.view bringSubviewToFront:self.navBar];
    }
}

#pragma mark - FQNavigationBarDelegate

- (void)navigationBarLeftBtnDidClicked {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Getter & Setter

- (FQNavigationBar *)navBar {
    FQNavigationBar *bar = (FQNavigationBar *)objc_getAssociatedObject(self, @selector(navigationBar));
    if (!bar) {
        bar = [[FQNavigationBar alloc] init];
        bar.delegate = self;
        bar.leftBtn.hidden = !self.presentingViewController && self.navigationController.viewControllers.count <= 1;
        
        objc_setAssociatedObject(self, @selector(navigationBar), bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return bar;
}

- (BOOL)navigationBarAlwaysFront {
    return [objc_getAssociatedObject(self, @selector(navigationBarAlwaysFront)) boolValue];
}

- (void)setNavigationBarAlwaysFront:(BOOL)navigationBarAlwaysFront {
    objc_setAssociatedObject(self, @selector(navigationBarAlwaysFront), @(navigationBarAlwaysFront), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end