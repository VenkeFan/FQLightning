//
//  LGMatchParlayTextField.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/4.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMatchParlayKeyboard.h"

@class LGMatchParlayTextField;

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchParlayTextFieldDelegate <NSObject>

- (void)matchParlayTextFieldShouldBeginEditing:(LGMatchParlayTextField *)textField;
- (void)matchParlayTextFieldShouldEndEditing:(LGMatchParlayTextField *)textField;
- (void)matchParlayTextFieldShouldReturn:(LGMatchParlayTextField *)textField;
- (void)matchParlayTextField:(LGMatchParlayTextField *)textField didEditing:(NSString *)string;

@end

@interface LGMatchParlayTextField : UIView <LGMatchParlayKeyboardDelegate>

@property (nonatomic, weak) UIView *inputView;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL isResponder;
@property (nonatomic, weak) id<LGMatchParlayTextFieldDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
