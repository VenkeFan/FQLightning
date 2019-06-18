//
//  FQAVPlayerView.h
//  FQWidgets
//
//  Created by fan qi on 2018/4/8.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import "FQAbstractPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface FQAVPlayerView : FQAbstractPlayerView

- (instancetype)initWithURLString:(NSString *)urlString;
- (instancetype)initWithAsset:(AVAsset *)asset;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) AVAsset *asset;

@property (nonatomic, strong) UIImage *previewImage;

@end
