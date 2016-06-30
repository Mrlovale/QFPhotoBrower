//
//  QFBrowerCell.m
//  QFPhotoBrower
//
//  Created by hlxdev on 16/6/29.
//  Copyright © 2016年 hlxdev. All rights reserved.
//

#import "QFBrowerCell.h"
#import "QFPhotoItem.h"
#import "UIView+frameAdjust.h"
#import "UIImageView+WebCache.h"

@interface QFBrowerCell ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *imageContainerView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, assign) BOOL itemDidLoad;

@end

@implementation QFBrowerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = [UIScreen mainScreen].bounds;
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageContainerView];
        [self.imageContainerView addSubview:self.imageView];
        [self.scrollView.layer addSublayer:self.progressLayer];
    }
    return self;
}

- (void)setItem:(QFPhotoItem *)item
{
    _item = item;
    
    [self.scrollView setZoomScale:1.0 animated:NO];
    
    self.progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.progressLayer.strokeEnd = 0;
    self.progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!item.largeImageURL) {
        self.imageView.image = item.thumbImage;
        [self resizeSubviewSize];
        [self caculateZommScale];
        _canZoom = YES;
    } else {
        self.imageView.image = item.thumbImage;
        [self resizeSubviewSize];
        self.progressLayer.hidden = NO;
        _canZoom = NO;
        
        __weak typeof(self) weakSelf = self;
        [self.imageView sd_setImageWithURL:item.largeImageURL placeholderImage:item.thumbImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            CGFloat progress = receivedSize / (float)expectedSize;
            progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
            if (isnan(progress)) progress = 0;
            self.progressLayer.hidden = NO;
            self.progressLayer.strokeEnd = progress;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.progressLayer.hidden = YES;
            if (image) {
                weakSelf.canZoom = YES;
                weakSelf.itemDidLoad = YES;
                weakSelf.imageView.image = image;
                [weakSelf resizeSubviewSize];
                [weakSelf caculateZommScale];
            }
        }];
    }
}

- (void)resizeSubviewSize {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.imageContainerView.origin = CGPointZero;
    self.imageContainerView.width = width;
    
    UIImage *image = self.imageView.image;
    if (image.size.height / image.size.width > self.height / width) {
        self.imageContainerView.height = floor(image.size.height / (image.size.width / width));
    } else {
        CGFloat height = image.size.height / image.size.width * width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        self.imageContainerView.height = height;
        CGPoint center = self.imageContainerView.center;
        center.y = self.height / 2;
        self.imageContainerView.center = center;
    }
    if (self.imageContainerView.height > self.height && self.imageContainerView.height - self.height <= 1) {
        self.imageContainerView.height = self.height;
    }
    self.scrollView.contentSize = CGSizeMake(width, MAX(self.imageContainerView.height, self.height));
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    
    if (self.imageContainerView.height <= self.height) {
        self.scrollView.alwaysBounceVertical = NO;
    } else {
        self.scrollView.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.imageView.frame = self.imageContainerView.bounds;
    [CATransaction commit];
}

- (void)caculateZommScale
{
    if (self.imageView.height < self.scrollView.height) {
        _zoomScale = self.scrollView.height / self.imageView.height;
    } else if (self.imageView.image.size.width < self.scrollView.width) {
        _zoomScale = self.scrollView.width / self.imageView.image.size.width;
    } else {
        _zoomScale = 0;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.progressLayer.frame = CGRectMake(width * 0.5, height * 0.5, 40, 40);
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (!_canZoom) {return;}
    
    UIView *subView = self.imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3;
        _scrollView.minimumZoomScale = 1;

        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.frame = [UIScreen mainScreen].bounds;
    }
    return _scrollView;
}

- (UIView *)imageContainerView
{
    if (!_imageContainerView) {
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
    }
    return _imageContainerView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    }
    return _imageView;
}

- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.bounds = CGRectMake(0, 0, 40, 40);
        _progressLayer.cornerRadius = 20;
        _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
        _progressLayer.path = path.CGPath;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineWidth = 4;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
        _progressLayer.hidden = YES;
    }
    return _progressLayer;
}

@end
