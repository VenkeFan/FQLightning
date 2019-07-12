//
//  LGParlayHistoryViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGParlayHistoryViewController.h"
#import "FQSegmentedControl.h"
#import "LGParlayHistoryView.h"

@interface LGParlayHistoryViewController () <FQSegmentedControlDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) FQSegmentedControl *segmentedCtr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSArray<LGParlayHistoryView *> *listViewArray;

@end

@implementation LGParlayHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"profile_bet_history");
    
    [self initializeUI];
}

- (void)initializeUI {
    _segmentedCtr = ({
        FQSegmentedControl *seg = [[FQSegmentedControl alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kSegmentHeight)];
        seg.backgroundColor = kNavBarColor;
        seg.currentIndex = 0;
        seg.delegate = self;
        seg.markLineColor = kMainOnTintColor;
        seg.hasVSeparateLine = YES;
        seg.hSeparateLineColor = kMarqueeBgColor;
        [seg setItems:@[kLocalizedString(@"parlay_unSettle"),
                        kLocalizedString(@"parlay_settled")]];
        
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
    
    LGParlayHistoryView* (^createListView)(CGFloat) = ^(CGFloat x) {
        LGParlayHistoryView *listView = [LGParlayHistoryView new];
        listView.frame = CGRectMake(x, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        
        return listView;
    };
    
    LGParlayHistoryView *unSettleView = createListView(0);
    unSettleView.orderStatus = LGOrderStatus_UnSettle;
    [self.scrollView addSubview:unSettleView];
    
    LGParlayHistoryView *settledView = createListView(CGRectGetMaxX(unSettleView.frame));
    settledView.orderStatus = LGOrderStatus_Settled;
    [self.scrollView addSubview:settledView];
    
    
    self.listViewArray = @[unSettleView, settledView];
    
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
                         LGParlayHistoryView *listView = self.listViewArray[index];
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

@end
