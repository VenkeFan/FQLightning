//
//  LGMatchParlayView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/31.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayView.h"
#import "IQKeyboardManager.h"
#import "LGTournamentListKeys.h"
#import "LGMatchParlayTableView.h"
#import "LGMatchParlayTopView.h"
#import "LGMatchParlayBottomView.h"

#define kLGMatchParlayViewAnimationDuration         (0.4)
#define kLGMatchParlayViewSpringVelocity            (5.0)
#define kLGMatchParlayViewSpringDamping             (0.8)

#define kLGMatchParlayViewHintHeight                kSizeScale(45.0)
#define kLGMatchParlayViewMixHeight                 (kLGMatchParlayTableViewCellHeight + kLGMatchParlayViewTopHeight + kLGMatchParlayViewBottomHeight)


@interface LGMatchParlayView () <LGMatchParlayTableViewDelegate, LGMatchParlayTopViewDelegate, LGMatchParlayBottomViewDelegate>

@property (nonatomic, assign, readwrite) BOOL expanded;

@property (nonatomic, strong) LGMatchParlayTopView *topView;
@property (nonatomic, strong) LGMatchParlayTableView *contentView;
@property (nonatomic, strong) LGMatchParlayBottomView *bottomView;

@end

@implementation LGMatchParlayView

+ (instancetype)instance {
    static LGMatchParlayView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kLGMatchParlayViewMixHeight)];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LGMatchParlayView instance];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _expanded = NO;
        
//        [self initializeUI];
//        [self addObservers];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)dealloc {
    [self removeObservers];
}

- (void)initializeUI {
    _topView = ({
        LGMatchParlayTopView *view = [[LGMatchParlayTopView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLGMatchParlayViewTopHeight)];
        view.delegate = self;
        
        view;
    });
    [self addSubview:_topView];
    
    _contentView = ({
        LGMatchParlayTableView *view = [LGMatchParlayTableView new];
        view.delegate = self;
        view.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), self.width, kLGMatchParlayTableViewCellHeight);
        
        view;
    });
    [self addSubview:_contentView];
    
    _bottomView = ({
        LGMatchParlayBottomView *view = [LGMatchParlayBottomView new];
        view.delegate = self;
        view.frame = CGRectMake(0, kScreenHeight + CGRectGetMaxY(_contentView.frame), self.width, kLGMatchParlayViewBottomHeight);
        
        view;
    });
}

#pragma mark - Public

- (void)addTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(NSString *)matchName {
    if (!teamDic || !oddsDic) {
        return;
    }
    if (self.contentView.itemCount == 0) {
        [self initializeUI];
        [self addObservers];
    }
    
    [self.contentView addTeamDic:teamDic oddsDic:oddsDic matchName:matchName];
    
    if (self.contentView.itemCount == 1) {
        [self p_expand];
    }
}

#pragma mark - Observer

- (void)addObservers {
    [self.contentView addObserver:self forKeyPath:@"itemArray" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self.contentView removeObserver:self forKeyPath:@"itemArray"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self.contentView] && [keyPath isEqualToString:@"itemArray"]) {
        [self.topView setItemCount:self.contentView.itemCount];
        [self.bottomView setItemCount:self.contentView.itemCount];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - LGMatchParlayTableViewDelegate

- (void)matchParlayTableViewHeightDidChanged:(LGMatchParlayTableView *)view newHeight:(CGFloat)newHeight {
    if (self.isExpanded || self.contentView.itemCount > 0) {
        [UIView animateWithDuration:kLGMatchParlayViewAnimationDuration * 0.5
                         animations:^{
                             self.contentView.height = newHeight;
                             self.contentView.tableView.height = newHeight;
                             self.height = kLGMatchParlayViewTopHeight + kLGMatchParlayViewBottomHeight + self.contentView.height;
                             if (self.isExpanded) {
                                 self.top = kScreenHeight - self.height;
                             }
                         }];
    }
}

- (void)matchParlayTableViewDidClear:(LGMatchParlayTableView *)view {
    [self p_destroy];
}

#pragma mark - LGMatchParlayTopViewDelegate

- (void)matchParlayTopViewDidClose:(LGMatchParlayTopView *)view {
    [self p_fold];
}

- (void)matchParlayTopViewDidClear:(LGMatchParlayTopView *)view {
    [self.contentView clearAll];
}

#pragma mark - LGMatchParlayBottomViewDelegate

- (void)matchParlayBottomViewDidChangeExpand:(LGMatchParlayBottomView *)view {
    if (self.isExpanded) {
        [self p_fold];
    } else {
        [self p_expand];
    }
}

#pragma mark - Private

- (void)p_expand {
    if (self.isExpanded) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bottomView];
    
    [UIView animateWithDuration:kLGMatchParlayViewAnimationDuration * 0.5
                     animations:^{
                         self.bottomView.top = kScreenHeight - kLGMatchParlayViewBottomHeight;
                     }];
    
    [UIView animateWithDuration:kLGMatchParlayViewAnimationDuration
                          delay:0.0
//         usingSpringWithDamping:kLGMatchParlayViewSpringDamping
//          initialSpringVelocity:kLGMatchParlayViewSpringVelocity
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.top = kScreenHeight - self.height;
                     }
                     completion:^(BOOL finished) {
                         self.expanded = YES;
                     }];
}

- (void)p_fold {
    [self p_fold:NO
       completed:^{
           self.expanded = NO;
       }];
}

- (void)p_destroy {
    [self p_fold:YES
       completed:^{
           self.expanded = NO;
           
           [self removeObservers];
           
           [self removeAllSubviews];
           [self->_bottomView removeFromSuperview];
           self->_topView = nil;
           self->_contentView = nil;
           self->_bottomView = nil;
           [self removeFromSuperview];
       }];
}

- (void)p_fold:(BOOL)isDestroy completed:(void(^)(void))completed {
    [FQWindowUtility resignFirstResponder];
    
    if (!self.isExpanded) {
        return;
    }
    
    [UIView animateWithDuration:kLGMatchParlayViewAnimationDuration
                          delay:0.0
//         usingSpringWithDamping:kLGMatchParlayViewSpringDamping
//          initialSpringVelocity:kLGMatchParlayViewSpringVelocity
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         if (isDestroy) {
                             self.top = kScreenHeight;
                             self.bottomView.top = kScreenHeight + CGRectGetMaxY(self.contentView.frame);
                         } else {
                             self.top = kScreenHeight;
                         }
                     }
                     completion:^(BOOL finished) {
                         if (completed) {
                             completed();
                         }
                     }];
}

#pragma mark - Setter

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    
    [self.bottomView setExpanded:expanded];
}

@end
