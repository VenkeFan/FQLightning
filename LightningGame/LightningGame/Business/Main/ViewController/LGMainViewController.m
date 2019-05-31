//
//  LGMainViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMainViewController.h"

#import "FQImageButton.h"
#import "FQSegmentedControl.h"
#import "LGTournamentListView.h"

@interface LGMainViewController () <FQSegmentedControlDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) FQSegmentedControl *segmentedCtr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSArray<LGTournamentListView *> *listViewArray;

@end

@implementation LGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNavigationBar];
    [self layoutBody];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    FQImageButton *rightBtn = [FQImageButton buttonWithType:UIButtonTypeCustom];
    rightBtn.imageOrientation = FQImageButtonOrientation_Right;
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setImage:[UIImage imageNamed:@"nav_kefu"] forState:UIControlStateNormal];
    rightBtn.imageView.contentMode = UIViewContentModeCenter;
    rightBtn.frame = CGRectMake(0, 0, kSizeScale(76), kSizeScale(22));
    rightBtn.centerX = CGRectGetWidth(self.navBar.contentView.frame) - CGRectGetWidth(rightBtn.frame) * 0.5 - kNavBarPaddingX;
    [rightBtn setTitle:kLocalizedString(@"navBar_kefu") forState:UIControlStateNormal];
    [rightBtn setTitleColor:kMainOnTintColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kRegularFont(kNoteFontSize);
    [rightBtn addTarget:self action:@selector(navRightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
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

- (void)layoutBody {
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
    
    LGTournamentListView* (^createListView)(CGFloat) = ^(CGFloat x) {
        LGTournamentListView *listView = [LGTournamentListView new];
        listView.frame = CGRectMake(x, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        
        return listView;
    };
    
    LGTournamentListView *beforeView = createListView(0);
    beforeView.listType = LGTournamentListType_Before;
    [self.scrollView addSubview:beforeView];
    
    LGTournamentListView *todayView = createListView(CGRectGetMaxX(beforeView.frame));
    todayView.listType = LGTournamentListType_Today;
    [self.scrollView addSubview:todayView];
    
    LGTournamentListView *rollingView = createListView(CGRectGetMaxX(todayView.frame));
    rollingView.listType = LGTournamentListType_Rolling;
    [self.scrollView addSubview:rollingView];
    
    LGTournamentListView *finishedView = createListView(CGRectGetMaxX(rollingView.frame));
    finishedView.listType = LGTournamentListType_Finished;
    [self.scrollView addSubview:finishedView];
    
    self.listViewArray = @[beforeView, todayView, rollingView, finishedView];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * self.listViewArray.count, 0);
    self.scrollView.contentOffset = CGPointMake(kScreenWidth * self.segmentedCtr.currentIndex, 0);
    
    if (self.segmentedCtr.currentIndex < self.listViewArray.count) {
        [self.listViewArray[self.segmentedCtr.currentIndex] display];
    }
}

#pragma mark - FQSegmentedControlDelegate

- (void)segmentedControl:(FQSegmentedControl *)control didSelectedIndex:(NSInteger)index preIndex:(NSInteger)preIndex {
    if (index >= self.listViewArray.count) {
        return;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.scrollView.contentOffset = CGPointMake(kScreenWidth * index, 0);
                     }
                     completion:^(BOOL finished) {
                         LGTournamentListView *listView = self.listViewArray[index];
                         [listView display];
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
    NSLog(@"!!!!!!navLeft1BtnClicked");
}

- (void)navLeft2BtnClicked {
    NSLog(@"******navLeft2BtnClicked");
}

- (void)navRightBtnClicked {
    NSLog(@"联系客服");
}

@end
