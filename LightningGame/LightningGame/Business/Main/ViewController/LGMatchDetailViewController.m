//
//  LGMatchDetailViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchDetailViewController.h"

@interface LGMatchDetailViewController ()

@property (nonatomic, copy) NSString *matchID;

@end

@implementation LGMatchDetailViewController

- (instancetype)initWithMatchID:(NSString *)matchID {
    if (self = [super init]) {
        _matchID = [matchID copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"游戏竞猜";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
