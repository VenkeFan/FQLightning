//
//  FQComponentFactory.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "FQComponentFactory.h"

@implementation FQComponentFactory

+ (CATextLayer *)textLayerWithFont:(UIFont *)font {
    CATextLayer *txtLayer = [CATextLayer layer];
    txtLayer.backgroundColor = [UIColor clearColor].CGColor;
    txtLayer.foregroundColor = [UIColor whiteColor].CGColor;
    txtLayer.contentsScale = kScreenScale;
    txtLayer.alignmentMode = kCAAlignmentNatural;
    txtLayer.truncationMode = kCATruncationNone;
    
    if (font) {
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        txtLayer.font = fontRef;
        txtLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
    }
    
    return txtLayer;
}

+ (UILabel *)labelWithFont:(UIFont *)font {
    UILabel *lab = [UILabel new];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.lineBreakMode = NSLineBreakByCharWrapping;
    lab.font = font;
    
    return lab;
}

@end
