//
//  LGTradeHistoryViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGTradeHistoryViewController.h"
#import "FQSegmentedControl.h"
#import "LGTradeListView.h"

@interface LGTradeHistoryViewController () <FQSegmentedControlDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) FQSegmentedControl *segmentedCtr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray<id<LGLazyLoadProtocol>> *listViewArray;

@end

@implementation LGTradeHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"profile_trade_history");
    
    [self initializeUI];
}

- (void)initializeUI {
    UIView *containerView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(kCellMarginX, kNavBarHeight, kScreenWidth - kCellMarginX * 2, kScreenHeight - kNavBarHeight - kCellMarginY);
        view.backgroundColor = kCellBgColor;
        view.layer.cornerRadius = kCornerRadius;
        view.layer.masksToBounds = YES;
        
        view;
    });
    [self.view addSubview:containerView];
    
    _segmentedCtr = ({
        FQSegmentedControl *seg = [[FQSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, containerView.width, kSegmentHeight)];
        seg.backgroundColor = [UIColor clearColor];
        seg.currentIndex = 0;
        seg.delegate = self;
        seg.markLineColor = kMainOnTintColor;
        seg.hasVSeparateLine = NO;
        seg.hSeparateLineColor = kMarqueeBgColor;
        [seg setItems:@[kLocalizedString(@"trade_all"),
                        kLocalizedString(@"trade_charge"),
                        kLocalizedString(@"trade_withdraw"),
                        kLocalizedString(@"trade_discount")]];
        
        seg;
    });
    [containerView addSubview:_segmentedCtr];
    
    _scrollView = ({
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedCtr.frame), containerView.width, containerView.height - CGRectGetMaxY(self.segmentedCtr.frame))];
        sv.delegate = self;
        sv.showsHorizontalScrollIndicator = NO;
        sv.pagingEnabled = YES;
        
        sv;
    });
    [containerView addSubview:_scrollView];
    
    LGTradeListView* (^createListView)(CGFloat) = ^(CGFloat x) {
        LGTradeListView *listView = [LGTradeListView new];
        listView.frame = CGRectMake(x, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);

        return listView;
    };

    LGTradeListView *allView = createListView(0);
    allView.tradeType = LGTradeTypeAll;
    [self.scrollView addSubview:allView];

    LGTradeListView *chargeView = createListView(CGRectGetMaxX(allView.frame));
    chargeView.tradeType = LGTradeTypeCharge;
    [self.scrollView addSubview:chargeView];

    LGTradeListView *withdrawView = createListView(CGRectGetMaxX(chargeView.frame));
    withdrawView.tradeType = LGTradeTypeWithdraw;
    [self.scrollView addSubview:withdrawView];

    LGTradeListView *discountView = createListView(CGRectGetMaxX(withdrawView.frame));
    discountView.tradeType = LGTradeTypeDiscount;
    [self.scrollView addSubview:discountView];

    self.listViewArray = @[allView, chargeView, withdrawView, discountView];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.listViewArray.count, 0);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.width * self.segmentedCtr.currentIndex, 0);
    
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
                         self.scrollView.contentOffset = CGPointMake(self.scrollView.width * index, 0);
                     }
                     completion:^(BOOL finished) {
                         id<LGLazyLoadProtocol> listView = self.listViewArray[index];
                         [listView display];
                     }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = x / scrollView.width;
    
    self.segmentedCtr.currentIndex = index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.segmentedCtr setLineOffsetX:scrollView.contentOffset.x];
}

@end
