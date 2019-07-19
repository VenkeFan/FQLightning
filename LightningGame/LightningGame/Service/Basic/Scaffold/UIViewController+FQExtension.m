//
//  UIViewController+FQExtension.m
//  FQWidgets
//
//  Created by fan qi on 2019/5/28.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import "UIViewController+FQExtension.h"
#import "FQRunTimeUtility.h"

static NSDictionary *ignoreCtrNameDic;

@interface UIViewController () <FQNavigationBarDelegate>

@end

@implementation UIViewController (FQExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ignoreCtrNameDic = @{
                             @"UIAlertController": @"T",
                             @"UISearchController": @"T",
                             @"UIImagePickerController": @"T",
                             @"UIInputViewController": @"T",
                             @"UIDocumentMenuViewController": @"T",
                             @"UIDocumentPickerViewController": @"T",
                             @"UIDocumentBrowserViewController": @"T",
                             @"UISplitViewController": @"T",
                             @"UIPageViewController": @"T",
                             @"UIActivityViewController": @"T",
                             @"UITableViewController": @"T",
                             @"UICollectionViewController": @"T",
                             @"UISearchContainerViewController": @"T",
                             @"UIReferenceLibraryViewController": @"T",
                             @"MPMoviePlayerViewController": @"T",
                             @"AVPlayerViewController": @"T",
                             
                             @"CAMPreviewViewController": @"T",
                             @"CAMViewfinderViewController": @"T",
                             @"CAMImagePickerCameraViewController": @"T",
                             @"PUUIAlbumListViewController": @"T",
                             @"PUUIPhotosAlbumViewController": @"T",
                             @"PUUIMomentsGridViewController": @"T",
                             @"UIInputWindowController": @"T",
                             @"UITextInputController": @"T",
                             @"UICompatibilityInputViewController": @"T",
                             @"UIApplicationRotationFollowingControllerNoTouches": @"T",
                             @"UISystemKeyboardDockController": @"T",
                             };
        
        swizzleInstanceMethod(self, @selector(viewDidLoad), @selector(fqswizzle_viewDidLoad));
        swizzleInstanceMethod(self, @selector(viewDidLayoutSubviews), @selector(fqswizzle_viewDidLayoutSubviews));
    });
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

- (void)fqswizzle_viewDidLoad {
    [self fqswizzle_viewDidLoad];
    
    NSString *clsName = NSStringFromClass([self class]);
    if ([ignoreCtrNameDic objectForKey:clsName]) {
        return;
    }
    
    self.navigationBarAlwaysFront = YES;
    self.view.backgroundColor = kMainBgColor;
    [self.view addSubview:self.navBar];
}

- (void)fqswizzle_viewDidLayoutSubviews {
    [self fqswizzle_viewDidLayoutSubviews];
    
    if (self.navigationBarAlwaysFront) {
        [self.view bringSubviewToFront:self.navBar];
    }
}

#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
