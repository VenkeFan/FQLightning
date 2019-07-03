//
//  LGMainViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMainViewController.h"
#import "YYFPSLabel.h"
#import "CTMediator+LGProfileActions.h"
#import "LGServiceButton.h"
#import "FQSegmentedControl.h"
#import "LGMatchListView.h"
#import "LGGameCollectionView.h"

@interface LGMainViewController () <FQSegmentedControlDelegate, LGGameCollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) FQSegmentedControl *segmentedCtr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSArray<LGMatchListView *> *listViewArray;
@property (nonatomic, strong) LGGameCollectionView *gameView;

@end

@implementation LGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNavigationBar];
    [self initializeBody];
    
    {
        YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] init];
        [fpsLabel sizeToFit];
        fpsLabel.center = CGPointMake(CGRectGetMidX(kCurrentWindow.frame), kSystemStatusBarHeight);
        [kCurrentWindow addSubview:fpsLabel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UI

- (void)layoutNavigationBar {
    UIImage *titleImg = [UIImage imageNamed:@"nav_title"];
    self.navBar.titleView.layer.contents = (__bridge id)titleImg.CGImage;
    self.navBar.titleView.layer.contentsGravity = kCAGravityCenter;
    self.navBar.titleView.layer.contentsScale = kScreenScale;
    
    UIButton *left1 = [self btnFactory:CGRectZero imgName:@"nav_profile" target:self action:@selector(navLeft1BtnClicked)];
    UIButton *left2 = [self btnFactory:CGRectZero imgName:@"nav_rein" target:self action:@selector(navLeft2BtnClicked)];
    self.navBar.leftBtnArray = @[left1, left2];
    
    LGServiceButton *rightBtn = [LGServiceButton new];
    rightBtn.centerX = CGRectGetWidth(self.navBar.contentView.frame) - CGRectGetWidth(rightBtn.frame) * 0.5 - kNavBarPaddingX;
    self.navBar.rightBtn = rightBtn;
}

- (UIButton *)btnFactory:(CGRect)frame imgName:(NSString *)imgName target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeCenter;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)initializeBody {
    _segmentedCtr = ({
        FQSegmentedControl *seg = [[FQSegmentedControl alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kSegmentHeight)];
        seg.backgroundColor = kNavBarColor;
        seg.currentIndex = 0;
        seg.delegate = self;
        seg.markLineColor = kMainOnTintColor;
        seg.hasVSeparateLine = YES;
        seg.hSeparateLineColor = kMarqueeBgColor;
        [seg setItems:@[kLocalizedString(@"main_before"),
                        kLocalizedString(@"main_today"),
                        kLocalizedString(@"main_rolling"),
                        kLocalizedString(@"main_finished")]];
        
        seg;
    });
    [self.view addSubview:_segmentedCtr];
    
    _scrollView = ({
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedCtr.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.segmentedCtr.frame))];
        sv.delegate = self;
        sv.showsHorizontalScrollIndicator = NO;
        sv.pagingEnabled = YES;
        
        sv;
    });
    [self.view addSubview:_scrollView];
    
    LGMatchListView* (^createListView)(CGFloat) = ^(CGFloat x) {
        LGMatchListView *listView = [LGMatchListView new];
        listView.frame = CGRectMake(x, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        
        return listView;
    };
    
    LGMatchListView *beforeView = createListView(0);
    beforeView.listType = LGMatchListType_Prepare;
    [self.scrollView addSubview:beforeView];
    
    LGMatchListView *todayView = createListView(CGRectGetMaxX(beforeView.frame));
    todayView.listType = LGMatchListType_Today;
    [self.scrollView addSubview:todayView];
    
    LGMatchListView *rollingView = createListView(CGRectGetMaxX(todayView.frame));
    rollingView.listType = LGMatchListType_Rolling;
    [self.scrollView addSubview:rollingView];
    
    LGMatchListView *finishedView = createListView(CGRectGetMaxX(rollingView.frame));
    finishedView.listType = LGMatchListType_Finished;
    [self.scrollView addSubview:finishedView];
    
    self.listViewArray = @[beforeView, todayView, rollingView, finishedView];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * self.listViewArray.count, 0);
    self.scrollView.contentOffset = CGPointMake(kScreenWidth * self.segmentedCtr.currentIndex, 0);
    
    if (self.segmentedCtr.currentIndex < self.listViewArray.count) {
        [self.listViewArray[self.segmentedCtr.currentIndex] display];
    }
}

#pragma mark - FQSegmentedControlDelegate

- (void)segmentedControl:(FQSegmentedControl *)control didSelectedIndex:(NSInteger)index preIndex:(NSInteger)preIndex animated:(BOOL)animated {
    if (index >= self.listViewArray.count) {
        return;
    }
    
    [UIView animateWithDuration:animated ? 0.3 : 0.0
                     animations:^{
                         self.scrollView.contentOffset = CGPointMake(kScreenWidth * index, 0);
                     }
                     completion:^(BOOL finished) {
                         LGMatchListView *listView = self.listViewArray[index];
                         [listView display];
                     }];
}

#pragma mark - LGGameCollectionViewDelegate

- (void)gameViewDidSelected:(LGGameCollectionView *)gameView gameIDDic:(nonnull NSDictionary *)gameIDDic {
    [self.listViewArray enumerateObjectsUsingBlock:^(LGMatchListView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setFilterGameIDDic:gameIDDic];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = x / kScreenWidth;
    
    self.segmentedCtr.currentIndex = index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.segmentedCtr setLineOffsetX:scrollView.contentOffset.x];
}

#pragma mark - Event

- (void)navLeft1BtnClicked {
    UIViewController *profileCtr = [[CTMediator sharedInstance] mediator_generateProfileController];
    [self.navigationController pushViewController:profileCtr animated:YES];
}

- (void)navLeft2BtnClicked {
    if (!_gameView) {
        _gameView = [LGGameCollectionView new];
        _gameView.delegate = self;
    }
    
    _gameView.isDisplaying ? [_gameView dismiss] : [_gameView displayInView:self.view];
}

@end
