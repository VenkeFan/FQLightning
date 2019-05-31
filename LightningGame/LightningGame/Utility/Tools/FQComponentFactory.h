//
//  FQComponentFactory.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQComponentFactory : NSObject

+ (CATextLayer *)textLayerWithFont:(UIFont *)font;
+ (UILabel *)labelWithFont:(UIFont *)font;

@end
