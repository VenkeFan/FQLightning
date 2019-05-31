//
//  UIImageView+FQExtension.m
//  FQWidgets
//
//  Created by fan qi on 2018/4/25.
//  Copyright © 2018年 redefine. All rights reserved.
//

#import "UIImageView+FQExtension.h"
#import "UIImageView+WebCache.h"
#import "UIImage+FQExtension.h"
#import <objc/runtime.h>

@interface UIImageView ()

@property (nonatomic, assign) UIViewContentMode originalContentMode;

@end

@implementation UIImageView (FQExtension)

- (void)fq_setImageWithURLString:(NSString *)urlString {
    [self fq_setImageWithURLString:urlString
                       placeholder:nil
                           options:kNilOptions
                      cornerRadius:0
                       borderWidth:0
                       borderColor:nil
                         completed:nil];
}

- (void)fq_setImageWithURLString:(NSString *)urlString
                     placeholder:(UIImage *)placeholder {
    [self fq_setImageWithURLString:urlString
                       placeholder:placeholder
                           options:kNilOptions
                      cornerRadius:0
                       borderWidth:0
                       borderColor:nil
                         completed:nil];
}

- (void)fq_setImageWithURLString:(NSString *)urlString
                       completed:(FQWebImageCompletionBlock)completed {
    [self fq_setImageWithURLString:urlString
                       placeholder:nil
                           options:kNilOptions
                      cornerRadius:0
                       borderWidth:0
                       borderColor:nil
                         completed:completed];
}

- (void)fq_setImageWithURLString:(NSString *)urlString
                     placeholder:(UIImage *)placeholder
                       completed:(FQWebImageCompletionBlock)completed {
    [self fq_setImageWithURLString:urlString
                       placeholder:placeholder
                           options:kNilOptions
                      cornerRadius:0
                       borderWidth:0
                       borderColor:nil
                         completed:completed];
}

- (void)fq_setImageWithURLString:(NSString *)urlString
                     placeholder:(UIImage *)placeholder
                    cornerRadius:(CGFloat)cornerRadius
                       completed:(FQWebImageCompletionBlock)completed {
    [self fq_setImageWithURLString:urlString
                       placeholder:placeholder
                      cornerRadius:cornerRadius
                       borderWidth:0
                       borderColor:nil
                         completed:completed];
}

- (void)fq_setImageWithURLString:(NSString *)urlString
                     placeholder:(UIImage *)placeholder
                    cornerRadius:(CGFloat)cornerRadius
                     borderWidth:(CGFloat)borderWidth
                     borderColor:(UIColor *)borderColor
                       completed:(FQWebImageCompletionBlock)completed {
    [self fq_setImageWithURLString:urlString
                       placeholder:placeholder
                           options:SDWebImageAvoidAutoSetImage
                      cornerRadius:cornerRadius
                       borderWidth:borderWidth
                       borderColor:borderColor
                         completed:completed];
}

- (void)fq_setImageWithURLString:(NSString *)urlString
                     placeholder:(UIImage *)placeholder
                         options:(SDWebImageOptions)options
                    cornerRadius:(CGFloat)cornerRadius
                     borderWidth:(CGFloat)borderWidth
                     borderColor:(UIColor *)borderColor
                       completed:(FQWebImageCompletionBlock)completed {
    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                                 forHTTPHeaderField:@"Accept"];
    
    self.originalContentMode = self.contentMode;
    
    if (!placeholder) {
        placeholder = [self p_defaultPlaceholder];
    }
    
    NSURL *url = nil;
    if ([urlString isKindOfClass:[NSString class]]) {
        if ([urlString hasPrefix:@"https"] || [urlString hasPrefix:@"http"]) {
            url = [NSURL URLWithString:urlString];
        } else {
            url = [NSURL fileURLWithPath:urlString];
        }
    } else if ([urlString isKindOfClass:[NSURL class]]) {
        url = (NSURL *)urlString;
    }
    
    if (!url) {
        self.image = placeholder;
        return;
    }
    
    if ([url isFileURL]) {
        self.image = [UIImage imageWithContentsOfFile:url.absoluteString];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    CGSize size = weakSelf.frame.size;
    
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       if (!image) {
                           dispatch_sync(dispatch_get_main_queue(), ^{
                               if (completed) {
                                   completed(image, url, error);
                               }
                           });
                           
                           return;
                       }
                       
                       __strong typeof(weakSelf) strongSelf = weakSelf;
                       
                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                           UIImage *img = image;
                           
                           img = [image resizeToSize:size];
                           if (cornerRadius > 0) {
                               img = [img imageByRoundCornerRadius:cornerRadius borderWidth:borderWidth borderColor:borderColor];
                           }
                           
                           dispatch_sync(dispatch_get_main_queue(), ^{
                               strongSelf.contentMode = strongSelf.originalContentMode;
                               
                               if (cacheType == SDImageCacheTypeNone) {
                                   CATransition *transition = [CATransition animation];
                                   transition.type = kCATransitionFade;
                                   transition.duration = 0.35;
                                   [strongSelf.layer addAnimation:transition forKey:nil];
                               }
                               strongSelf.image = img;
                           });
                       });
                     }];
}

#pragma mark - Private

- (UIViewContentMode)originalContentMode {
    return [objc_getAssociatedObject(self, @selector(originalContentMode)) integerValue];
}

- (void)setOriginalContentMode:(UIViewContentMode)originalContentMode {
    objc_setAssociatedObject(self, @selector(originalContentMode), @(originalContentMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)p_defaultPlaceholder {
    UIImage *image = nil;
    
    return image;
}

- (UIImage *)p_defaultBadImage {
    UIImage *image = nil;
    
    return image;
}

@end
