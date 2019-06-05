//
//  LGServiceButton.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGServiceButton.h"
#import "FQImageButton.h"

@interface LGServiceButton ()

@property (nonatomic, strong) FQImageButton *imgBtn;

@end

@implementation LGServiceButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, kSizeScale(76), kSizeScale(22))]) {
        self.backgroundColor = [UIColor clearColor];
        
        _imgBtn = [FQImageButton buttonWithType:UIButtonTypeCustom];
        _imgBtn.imageOrientation = FQImageButtonOrientation_Right;
        _imgBtn.backgroundColor = [UIColor clearColor];
        [_imgBtn setImage:[UIImage imageNamed:@"nav_kefu"] forState:UIControlStateNormal];
        _imgBtn.imageView.contentMode = UIViewContentModeCenter;
        [_imgBtn setTitle:kLocalizedString(@"navBar_kefu") forState:UIControlStateNormal];
        [_imgBtn setTitleColor:kMainOnTintColor forState:UIControlStateNormal];
        _imgBtn.titleLabel.font = kRegularFont(kNoteFontSize);
        [_imgBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imgBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imgBtn.frame = self.bounds;
}

- (void)btnClicked {
    NSLog(@"联系客服");
}

@end
