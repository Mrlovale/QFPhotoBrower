//
//  QFPhotoBrower.h
//  QFPhotoBrower
//
//  Created by hlxdev on 16/6/29.
//  Copyright © 2016年 hlxdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFPhotoBrower : UIView

@property (nonatomic, assign)BOOL blurEffectBackground; // Default is YES

- (instancetype)initWithPhotoItems:(NSArray *)items; // <QFPhotoItem>

- (void)presentFromImageView:(UIView *)fromView
                toContrainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

- (void)dismiss;

@end
