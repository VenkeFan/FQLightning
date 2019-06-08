//
//  LGSignFieldView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGSignFieldView : UIView

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                        field:(__weak UITextField *_Nonnull*_Nonnull)field
                   titleWidth:(CGFloat)titleWidth;
- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                        field:(__weak UITextField *_Nonnull*_Nonnull)field
                   titleWidth:(CGFloat)titleWidth
                        isPwd:(BOOL)isPwd;

@property (nonatomic, strong, readonly) UITextField *txtField;

@end

NS_ASSUME_NONNULL_END
