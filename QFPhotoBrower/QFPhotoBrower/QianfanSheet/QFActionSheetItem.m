//
//  QFActionSheetItem.m
//  SImpleActionSheet
//
//  Created by hlxdev on 15/9/15.
//  Copyright (c) 2015年 hlxdev. All rights reserved.
//

#import "QFActionSheetItem.h"

@implementation QFActionSheetItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.numberOfLines = 0;
        self.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return self;
}

@end
