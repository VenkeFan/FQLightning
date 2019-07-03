//
//  LGGameCollectionView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGGameCollectionView.h"
#import "LGGameListKeys.h"
#import "LGGameCollectionViewModel.h"
#import "FQComponentFactory.h"

@interface LGGameCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end


@implementation LGGameCollectionCell {
    UIImageView *_iconView;
    UILabel *_nameLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = kCornerRadius;
        self.layer.masksToBounds = YES;
        self.backgroundColor = kMarqueeBgColor;
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSizeScale(40.0), kSizeScale(40.0))];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconView];
        
        _nameLab = [FQComponentFactory labelWithFont:kRegularFont(kNameFontSize)];
        _nameLab.textColor = kNameFontColor;
        [self.contentView addSubview:_nameLab];
    }
    return self;
}

- (void)setDataDic:(NSMutableDictionary *)dataDic {
    _dataDic = dataDic;
    
    [_iconView fq_setImageWithURLString:dataDic[kGameKeyLogo]];
    
    _nameLab.text = dataDic[kGameKeyName];
    [_nameLab sizeToFit];
    
    CGFloat paddingY = kSizeScale(10.0);
    CGFloat y = (self.height - (_iconView.height + paddingY + _nameLab.height)) * 0.5;
    
    _iconView.center = CGPointMake(self.width * 0.5, y + _iconView.height * 0.5);
    _nameLab.center = CGPointMake(self.width * 0.5, CGRectGetMaxY(_iconView.frame) + paddingY + _nameLab.height * 0.5);
    
    BOOL isSelected = [dataDic[kGameKeyIsSelected] boolValue];
    if (isSelected) {
        self.layer.borderColor = kMainOnTintColor.CGColor;
        self.layer.borderWidth = 1.0;
    } else {
        self.layer.borderWidth = 0.0;
    }
}

@end

static NSString * const kGameCellReuseID = @"kGameCellReuseID";

@interface LGGameCollectionView () <LGGameCollectionViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) LGGameCollectionViewModel *viewModel;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation LGGameCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight)]) {
        self.backgroundColor = kCellBgColor;
        self.top = -(kScreenHeight - kNavBarHeight);
        _isDisplaying = NO;
        
        [self initializeUI];
        [self fetchData];
    }
    return self;
}

- (void)initializeUI {
    _titleView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        view.backgroundColor = kNavBarColor;
        
        UILabel *lab = [FQComponentFactory labelWithFont:kRegularFont(kNameFontSize)];
        lab.text = kLocalizedString(@"game_list_title");
        lab.textColor = kNameFontColor;
        [lab sizeToFit];
        lab.center = CGPointMake(view.width * 0.5, view.height * 0.5);
        [view addSubview:lab];
        
        view;
    });
    [self addSubview:_titleView];
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat spacing = kSizeScale(8.0);
    CGFloat width = (self.width - (spacing * 4)) / 3.0;
    _layout.minimumLineSpacing = spacing;
    _layout.minimumInteritemSpacing = spacing;
    _layout.sectionInset = UIEdgeInsetsMake(kSizeScale(12.0), spacing, kSizeScale(12.0), spacing);
    _layout.itemSize = CGSizeMake(width, width);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.width, self.height - CGRectGetMaxY(_titleView.frame)) collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = YES;
    [_collectionView registerClass:[LGGameCollectionCell class] forCellWithReuseIdentifier:kGameCellReuseID];
    [self addSubview:_collectionView];
}

#pragma mark - Public

- (void)displayInView:(UIView *)parentView {
    if (_isDisplaying) {
        return;
    }
    _isDisplaying = YES;
    
    [parentView addSubview:self];
    
    [UIView animateWithDuration:0.35
                          delay:0.0
              usingSpringWithDamping:0.8
               initialSpringVelocity:5.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.top = kNavBarHeight;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismiss {
    if (!_isDisplaying) {
        return;
    }
    _isDisplaying = NO;
    
    
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [self.itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[kGameKeyIsSelected] boolValue]) {
            [dicM setObject:@"T" forKey:obj[kGameKeyID]];
        }
    }];
    
    if (dicM.count > 0 && [self.delegate respondsToSelector:@selector(gameViewDidSelected:gameIDDic:)]) {
        [self.delegate gameViewDidSelected:self gameIDDic:dicM];
    }
    
    [UIView animateWithDuration:0.35
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:5.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.top = -(kScreenHeight - kNavBarHeight);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - Network

- (void)fetchData {
    [self.viewModel fetchGameList];
}

#pragma mark - LGGameCollectionViewModelDelegate

- (void)gameListDidFetch:(LGGameCollectionViewModel *)viewModel data:(NSArray *)data error:(NSError *)error {
    if (error) {
        return;
    }
    
    NSMutableArray *arrayM = [NSMutableArray array];
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithObjectsAndKeys:kAllGameID, kGameKeyID,
                                 kLocalizedString(@"game_list_all"), kGameKeyName, @(YES), kGameKeyIsSelected, nil];
    [arrayM addObject:dicM];
    [arrayM addObjectsFromArray:data];
    
    self.itemArray = arrayM;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LGGameCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameCellReuseID forIndexPath:indexPath];
    cell.dataDic = self.itemArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *indexArray = [NSMutableArray array];
    [indexArray addObject:indexPath];
    
    NSMutableDictionary *dataDic = self.itemArray[indexPath.row];
    
    if ([dataDic[kGameKeyID] isEqual:kAllGameID]) {
        [dataDic setObject:@(YES) forKey:kGameKeyIsSelected];
        
        [self.itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqual:dataDic]) {
                if ([dataDic[kGameKeyIsSelected] boolValue]) {
                    [obj setObject:@(NO) forKey:kGameKeyIsSelected];
                    
                    [indexArray addObject:[NSIndexPath indexPathForRow:idx inSection:indexPath.section]];
                }
            }
        }];
        
    } else {
        if ([self.itemArray.firstObject[kGameKeyIsSelected] boolValue]) {
            [self.itemArray.firstObject setObject:@(NO) forKey:kGameKeyIsSelected];
            
            [indexArray addObject:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        }
        
        if (dataDic[kGameKeyIsSelected]) {
            BOOL isSelected = [dataDic[kGameKeyIsSelected] boolValue];
            if (isSelected) {
                [dataDic setObject:@(NO) forKey:kGameKeyIsSelected];
                
                __block BOOL isCancelAll = YES;
                [self.itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj[kGameKeyIsSelected] boolValue]) {
                        *stop = YES;
                        isCancelAll = NO;
                    }
                }];
                
                if (isCancelAll) {
                    [self.itemArray.firstObject setObject:@(YES) forKey:kGameKeyIsSelected];
                    
                    [indexArray addObject:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
                }
            } else {
                [dataDic setObject:@(YES) forKey:kGameKeyIsSelected];
            }
            
        } else {
            [dataDic setObject:@(YES) forKey:kGameKeyIsSelected];
        }
    }
    
    [self.collectionView reloadItemsAtIndexPaths:indexArray];
}

#pragma mark - Getter

- (LGGameCollectionViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [LGGameCollectionViewModel new];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

@end
