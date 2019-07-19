//
//  UIImage+FQExtension.m
//  FQWidgets
//
//  Created by fan qi on 2018/4/17.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import "UIImage+FQExtension.h"

@implementation UIImage (FQExtension)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef buffer;
    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(buffer, 0);
    uint8_t *base;
    size_t width, height, bytesPerRow;
    base = (uint8_t *)CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    CGColorSpaceRef colorSpace;
    CGContextRef cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef cgImage;
    UIImage *image;
    cgImage = CGBitmapContextCreateImage(cgContext);
    image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    
    return image;
}

- (CVImageBufferRef)CVImageBuffer {
    CGImageRef imageRef = self.CGImage;
    
    CGSize frameSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    NSDictionary *options = @{
                              (__bridge NSString *)kCVPixelBufferCGImageCompatibilityKey: @(NO),
                              (__bridge NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @(NO),
                              };
    CVPixelBufferRef pixelBuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameSize.width,
                                          frameSize.height,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef)options,
                                          &pixelBuffer);
    if (status != kCVReturnSuccess) {
        return NULL;
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *data = CVPixelBufferGetBaseAddress(pixelBuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data,
                                                 frameSize.width,
                                                 frameSize.height,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pixelBuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(imageRef),
                                           CGImageGetHeight(imageRef)), imageRef);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CGImageRelease(imageRef);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return pixelBuffer;
    
    
    
//    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
//    CFDataRef pixelData = CGDataProviderCopyData(provider);
//    const unsigned char *data = CFDataGetBytePtr(pixelData);
//    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
//    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
//    size_t frameWidth = CGImageGetWidth(imageRef);
//    size_t frameHeight = CGImageGetHeight(imageRef);
//    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
//    CFRelease(pixelData);
//
//    NSDictionary *options = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
//    CVImageBufferRef pixelBuffer = NULL;
//    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameWidth, frameHeight, kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, (__bridge CFDictionaryRef)(options), &pixelBuffer);
//    NSParameterAssert(status == kCVReturnSuccess && pixelBuffer != NULL);
//
//    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//
//    size_t width = CVPixelBufferGetWidth(pixelBuffer);
//    size_t height = CVPixelBufferGetHeight(pixelBuffer);
//    size_t bpr = CVPixelBufferGetBytesPerRow(pixelBuffer);
//
//    size_t wh = width * height;
//    size_t size = CVPixelBufferGetDataSize(pixelBuffer);
//    size_t count = CVPixelBufferGetPlaneCount(pixelBuffer);
//
//    size_t width0 = CVPixelBufferGetWidthOfPlane(pixelBuffer, 0);
//    size_t height0 = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
//    size_t bpr0 = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
//
//    size_t width1 = CVPixelBufferGetWidthOfPlane(pixelBuffer, 1);
//    size_t height1 = CVPixelBufferGetHeightOfPlane(pixelBuffer, 1);
//    size_t bpr1 = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);
//
//    unsigned char *bufY = malloc(wh);
//    unsigned char *bufUV = malloc(wh/2);
//
//    size_t offset,p;
//
//    int r,g,b,y,u,v;
//    int a=255;
//    for (int row = 0; row < height; ++row) {
//        for (int col = 0; col < width; ++col) {
//            //
//            offset = ((width * row) + col);
//            p = offset*4;
//            //
//            r = data[p + 0];
//            g = data[p + 1];
//            b = data[p + 2];
//            a = data[p + 3];
//            //
//            y = 0.299*r + 0.587*g + 0.114*b;
//            u = -0.1687*r - 0.3313*g + 0.5*b + 128;
//            v = 0.5*r - 0.4187*g - 0.0813*b + 128;
//            //
//            bufY[offset] = y;
//            bufUV[(row/2)*width + (col/2)*2] = u;
//            bufUV[(row/2)*width + (col/2)*2 + 1] = v;
//        }
//    }
//    uint8_t *yPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
//    memset(yPlane, 0x80, height0 * bpr0);
//    for (int row=0; row<height0; ++row) {
//        memcpy(yPlane + row*bpr0, bufY + row*width0, width0);
//    }
//    uint8_t *uvPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
//    memset(uvPlane, 0x80, height1 * bpr1);
//    for (int row=0; row<height1; ++row) {
//        memcpy(uvPlane + row*bpr1, bufUV + row*width, width);
//    }
//
//    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//    free(bufY);
//    free(bufUV);
//
//    return pixelBuffer;
}

- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             self.size.width,
                                             self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage),
                                             0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)compress {
    NSData *imgData = [self compressQuality];
    UIImage *compressImage = [UIImage imageWithData:imgData];
    
    UIImage *image = [compressImage compressSize];
    
    return image;
}

- (NSData *)compressQuality {
    const float kMaxVideoUploadQuality = 1.5;
    CGFloat maxLength = kMaxVideoUploadQuality * 1024 * 1024;
    CGFloat compression = 1.0;
    
    NSData *imgData = UIImageJPEGRepresentation(self, compression);
    
    if (imgData.length < maxLength) {
        return imgData;
    }
    
    CGFloat min = 0.0, max = 1.0;
    while (min < max) {
        compression = (min + max) / 2.0;
        NSData *tmpData = UIImageJPEGRepresentation(self, compression);
        if (tmpData.length > maxLength) {
            max = compression;
        } else {
            imgData = tmpData;
            break;
        }
    }
    
    return imgData;
}

- (UIImage *)compressSize {
    /*
     静态图（jpg、png、gif、webp）
     压缩策略：本地尺寸和质量压缩；保证长图的体验；大图进行更多的压缩；输出格式为jpg；
     普通尺寸图如：宽和高小于等于1280则：尺寸不变，像素压缩到70%；
     普通尺寸长图和宽图如：宽或高大于1280，且0.5<=宽高比<=2 则： 长边压缩到1280，短边按比例缩放，像素压缩到70%；
     大尺寸长图和宽图如：宽或高大于1280，且宽高比>2或<0.5，且短边小于等于1280则：尺寸不变，像素压缩到50%（大图压缩）
     大尺寸图如：宽或高大于1280，且宽高比>2或<0.5，且短边大于1280则：短边压缩到1280，长边按比例缩放，像素压缩到50%；（保证图片比例同时压缩大图）
     
     动态图（gif）
     长边<=500像素，如超过5M，压缩到5M
     长边>500 压缩到500像素，如超过5M，压缩到5M
     */
    
    UIImage *image = self;
    CGFloat originalWidth = image.size.width;
    CGFloat originalHeight = image.size.height;
    
    if (originalWidth <= 1280 && originalHeight <= 1280) {
        return image;
    }
    
    
    return image;
}

- (UIImage *)resizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius {
    return [self imageByRoundCornerRadius:radius borderWidth:0 borderColor:nil];
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor {
    return [self imageByRoundCornerRadius:radius
                                  corners:UIRectCornerAllCorners
                              borderWidth:borderWidth
                              borderColor:borderColor
                           borderLineJoin:kCGLineJoinMiter];
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
