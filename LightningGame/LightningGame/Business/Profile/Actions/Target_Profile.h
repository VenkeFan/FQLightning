//
//  Target_Profile.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_Profile : NSObject

- (UIViewController *)action_nativeGenerateProfileController:(NSDictionary *)params;
- (UIViewController *)action_nativeGenerateParlayHistoryController:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
