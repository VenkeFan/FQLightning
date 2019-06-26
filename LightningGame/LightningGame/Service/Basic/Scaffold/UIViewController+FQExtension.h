//
//  UIViewController+FQExtension.h
//  FQWidgets
//
//  Created by fan qi on 2019/5/28.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FQExtension)

@property (nonatomic, strong, readonly) FQNavigationBar *navBar;
@property (nonatomic, assign) BOOL navigationBarAlwaysFront;

@end

NS_ASSUME_NONNULL_END
