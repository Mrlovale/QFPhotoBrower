//
//  QFPhotoBrower.m
//  QFPhotoBrower
//
//  Created by hlxdev on 16/6/29.
//  Copyright © 2016年 hlxdev. All rights reserved.
//

#import "QFPhotoBrower.h"
#import "QFActionSheet.h"
#import "QFPhotoItem.h"
#import "QFBrowerCell.h"
#import "UIView+frameAdjust.h"
#import "UIImage+Function.h"

#import <AssetsLibrary/AssetsLibrary.h>

static const CGFloat  cellMargin = 15;
static NSString *BrowerCellIdentifier = @"BrowerCellIdentifier";

@interface QFPhotoBrower ()<UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toContainerView;

@property (nonatomic, strong)UIImage *snapshotImage;
@property (nonatomic, strong)UIImage *snapshorImageHideFromView;

@property (nonatomic, strong)NSArray *groupItems; // <QFPhotoItem>
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, strong)UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong)UIImageView *background;
@property (nonatomic, strong)UIImageView *blurBackground;

@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIPageControl *pager;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, assign)BOOL fromNavigationBarHidden; //container的statusBar显示情况
@property (nonatomic, assign)BOOL animated;
@property (nonatomic, assign)BOOL isPresented;
@property (nonatomic, assign)CGPoint panGestureBeginPoint;

@property (nonatomic, assign)NSInteger fromItemIndex;

@end

@implementation QFPhotoBrower

- (instancetype)initWithPhotoItems:(NSArray *)items
{
    self = [super init];
    if (items.count == 0) {return nil;}
    
    self.groupItems = items;
    self.blurEffectBackground = YES;
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    self.clipsToBounds = YES;
    self.isPresented = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    press.minimumPressDuration = 0.5;
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    _panGesture = pan;
    
    [self addSubview:self.background];
    [self addSubview:self.blurBackground];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.pager];
    
    [self.collectionView registerClass:[QFBrowerCell class] forCellWithReuseIdentifier:BrowerCellIdentifier];
    
    return self;
}

- (void)presentFromImageView:(UIView *)fromView
                toContrainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion
{
    if (!container) {return;}
    
    self.fromView = fromView;
    self.toContainerView = container;
    self.animated = animated;
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[fromView snapshotImage]];
    [self addSubview:tempImageView];
    
    // 得到page
    NSInteger page = -1;
    for (NSInteger i = 0; i < self.groupItems.count; i++) {
        if (fromView == ((QFPhotoItem *)self.groupItems[i]).thumbView) {
            page = i;
            break;
        }
    }
    if (page == -1) {page = 0;}
    _fromItemIndex = page;
    
    // 设置背景图片
    _snapshotImage = [self.toContainerView snapshotImageAfterScreenUpdates:NO];
    BOOL fromViewHidden = fromView.hidden;
    fromView.hidden = YES;
    _snapshorImageHideFromView = [self.toContainerView snapshotImage];
    fromView.hidden = fromViewHidden;
    
    self.background.image = _snapshotImage;
    if (self.blurEffectBackground) {
        self.blurBackground.image = [_snapshotImage imageByBlurDark];
    } else {
        self.blurBackground.image = [UIImage imageWithColor:[UIColor blackColor]];
    }
    
    // 初始化显示样式
    self.size = self.toContainerView.size;
    self.blurBackground.alpha = 1;
    self.pager.alpha = 0;
    self.pager.numberOfPages = self.groupItems.count;
    self.pager.currentPage = self.fromItemIndex;
    [self.toContainerView addSubview:self];
    
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.fromItemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [UIView setAnimationsEnabled:YES];
    _fromNavigationBarHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];

    CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:container];
    tempImageView.frame = fromFrame;
    
    // 背景动画
    float animateTime = animated ? 0.25 : 0;
    [UIView animateWithDuration:animateTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        self.blurBackground.alpha = 1.0;
    } completion:NULL];

    // fromView动画
    self.collectionView.alpha = 0;
    QFPhotoItem *item = self.groupItems[self.fromItemIndex];
    CGSize fromViewToSize = [self fromViewDisplaySize:item.thumbImage];
    __weak typeof(self) wekSelf = self;
    [UIView animateWithDuration:animateTime*2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        tempImageView.frame = CGRectMake((self.width - fromViewToSize.width) / 2, (self.height - fromViewToSize.height) / 2, fromViewToSize.width, fromViewToSize.height);
    } completion:^(BOOL finished) {
        wekSelf.collectionView.alpha = 1.0;
        tempImageView.alpha = 0;
        [tempImageView removeFromSuperview];
        wekSelf.pager.alpha = 1;
        wekSelf.isPresented = YES;
    }];
    
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groupItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QFBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BrowerCellIdentifier forIndexPath:indexPath];
    QFPhotoItem *item = self.groupItems[indexPath.item];
    cell.item = item;
    return cell;
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger current = rintf(scrollView.contentOffset.x / scrollView.width);
    self.currentPage = current;
    self.pager.currentPage = current;
}

#pragma mark - prvite
- (CGSize)fromViewDisplaySize:(UIImage *)image
{
    CGFloat scale = image.size.height / image.size.width;
    CGFloat width = self.width;
    CGFloat height = width * scale;
    
    return CGSizeMake(width, height);
}

#pragma mark - actions
- (void)dismiss
{
    QFBrowerCell *cell = [self.collectionView visibleCells].lastObject;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    if (indexPath) {
        QFPhotoItem *item = self.groupItems[indexPath.item];
        CGRect convertFrame = [item.thumbView convertRect:item.thumbView.bounds toView:self.toContainerView];
        
        UIImageView *tempView = [[UIImageView alloc] init];
        [self addSubview:tempView];
        tempView.image = item.thumbImage;
        CGSize fromViewToSize = [self fromViewDisplaySize:item.thumbImage];
        tempView.frame = CGRectMake((self.width - fromViewToSize.width) / 2, (self.height - fromViewToSize.height) / 2, fromViewToSize.width, fromViewToSize.height);
        
        // 背景动画
        float animateTime = self.animated ? 0.25 : 0;
        [UIView animateWithDuration:animateTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blurBackground.alpha = 0;
        } completion:NULL];
        
        __weak typeof(self) weakself = self;
        self.collectionView.hidden = YES;
        [UIView animateWithDuration:animateTime*2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            tempView.frame = convertFrame;
        } completion:^(BOOL finished) {
            [weakself removeFromSuperview];
            weakself.isPresented = NO;
        }];
    }
}

- (void)doubleTap:(UIGestureRecognizer *)gesture
{
    
    QFBrowerCell *cell = [self.collectionView visibleCells].lastObject;
    if (!cell.canZoom) {return;}
    
    if (cell.scrollView.zoomScale > 1) {
        [cell.scrollView setZoomScale:1.0 animated:YES];
    } else {
        if (cell.zoomScale == 0) {
            CGPoint point = [gesture locationInView:cell.scrollView];
            [cell.scrollView zoomToRect:CGRectMake(point.x - 50, point.y - 50, 50, 50) animated:YES];
        }else {
            [cell.scrollView setZoomScale:cell.zoomScale animated:YES];
        }
        
    }
}

- (void)longPress:(UIGestureRecognizer *)gesture
{
    if (!_isPresented) {return;}
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        QFBrowerCell *cell = [self.collectionView visibleCells].lastObject;
        
        QFActionSheet *sheet = [[QFActionSheet alloc] initWithButtonTitles:@[@"保存",@"取消"] delegate:nil];
        [sheet showInView:self.toContainerView];
        sheet.block = ^(QFActionSheet *actionSheet, NSInteger buttonIndex){
            if (buttonIndex == 0) {
                if ([ALAssetsLibrary authorizationStatus] != ALAuthorizationStatusAuthorized) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请允许本App可以访问相册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                UIImageWriteToSavedPhotosAlbum(cell.imageView.image, self, nil, NULL);
            }
        };
        
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (!_isPresented) {return;}
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            _panGestureBeginPoint = [gesture locationInView:self];
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [gesture locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            self.collectionView.y = deltaY;
            
            CGFloat alphaDelta = 200;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
            if (alpha <= 0) {
                alpha = 0;
            } else if (alpha >= 1) {
                alpha = 1;
            }
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                _blurBackground.alpha = alpha;
                _pager.alpha = alpha;
            } completion:nil];
            
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [gesture velocityInView:self];
            CGPoint p = [gesture locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                _isPresented = NO;
                [[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:UIStatusBarAnimationFade];
                
                BOOL moveToTop = (v.y < - 50 || (v.y < 50 && deltaY < 0));
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1;
                CGFloat duration = (moveToTop ? self.collectionView.bottom : self.height - self.collectionView.x) / vy;
                duration *= 0.8;
                if (duration <= 0.05) {
                    duration = 0.05;
                } else if (duration >= 0.3) {
                    duration = 0.3;
                }
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _blurBackground.alpha = 0;
                    _pager.alpha = 0;
                    if (moveToTop) {
                        self.collectionView.bottom = 0;
                    } else {
                        self.collectionView.y = self.height;
                    }
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
                
                _background.image = _snapshotImage;
                
            } else {
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self.collectionView.y = 0;
                    _blurBackground.alpha = 1;
                    _pager.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];

            }
            
        } break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载
- (UIImageView *)background
{
    if (!_background) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.bounds;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _background = imageView;
    }
    return _background;
}

- (UIImageView *)blurBackground
{
    if (!_blurBackground) {
        UIImageView *blurBackground = [[UIImageView alloc] init];
        blurBackground.frame = self.bounds;
        blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _blurBackground = blurBackground;
    }
    return _blurBackground;
}

- (UIView *)contentView
{
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.frame = self.bounds;
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView = contentView;
    }
    return _contentView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.width + cellMargin, self.height);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.width = self.width + cellMargin;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIPageControl *)pager
{
    if (!_pager) {
        UIPageControl *pager = [[UIPageControl alloc] init];
        pager.hidesForSinglePage = YES;
        pager.userInteractionEnabled = NO;
        pager.width = self.width - 36;
        pager.height = 10;
        pager.center = CGPointMake(self.width / 2, self.height - 18);
        pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _pager = pager;
    }
    return _pager;
}

@end
