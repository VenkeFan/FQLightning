//
//  LGLazyLoadProtocol.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/18.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

@protocol LGLazyLoadProtocol <NSObject>

@required
@property (nonatomic, assign, getter=isLoaded) BOOL loaded;
- (void)display;

@end
