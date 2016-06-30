//
//  QFBrowerCell.h
//  QFPhotoBrower
//
//  Created by hlxdev on 16/6/29.
//  Copyright © 2016年 hlxdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QFPhotoItem;
@interface QFBrowerCell : UICollectionViewCell

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL canZoom;
@property (nonatomic, assign) CGFloat zoomScale;

@property (nonatomic, strong)QFPhotoItem *item;

@end
