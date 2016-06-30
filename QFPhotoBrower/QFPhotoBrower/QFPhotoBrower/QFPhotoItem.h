//
//  QFPhotoItem.h
//  QFPhotoBrower
//
//  Created by hlxdev on 16/6/29.
//  Copyright © 2016年 hlxdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFPhotoItem : NSObject

@property (nonatomic, strong)UIView *thumbView;
@property (nonatomic, strong)NSURL *largeImageURL;

@property (nonatomic, readonly)UIImage *thumbImage;

- (instancetype)initWithThumbView:(UIView *)thumbView largeImageURL:(NSURL *)largeImageURL;

@end
