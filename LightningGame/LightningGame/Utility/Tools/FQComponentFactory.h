//
//  FQComponentFactory.h
//  FQWidgets
//
//  Created by fan qi on 2019/5/30.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQComponentFactory : NSObject

+ (CATextLayer *)textLayerWithFont:(UIFont *)font;
+ (UILabel *)labelWithFont:(UIFont *)font;

@end
