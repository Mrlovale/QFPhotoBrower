//
//  QFPhotoItem.m
//  QFPhotoBrower
//
//  Created by hlxdev on 16/6/29.
//  Copyright © 2016年 hlxdev. All rights reserved.
//

#import "QFPhotoItem.h"

@implementation QFPhotoItem

- (instancetype)initWithThumbView:(UIView *)thumbView largeImageURL:(NSURL *)largeImageURL
{
    self = [super init];
    if (self) {
        self.thumbView = thumbView;
        self.largeImageURL = largeImageURL;
    }
    return self;
}

- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
}

@end
