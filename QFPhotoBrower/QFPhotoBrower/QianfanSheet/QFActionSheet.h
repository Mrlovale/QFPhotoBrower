//
//  QFActionSheet.h
//  SImpleActionSheet
//
//  Created by hlxdev on 15/9/15.
//  Copyright (c) 2015年 hlxdev. All rights reserved.
//

#import <UIKit/UIKit.h>

// 按钮之间的间距
static CGFloat const kMargin = 5;
// 按钮的高度
static CGFloat const kBtnHeight = 50;
// 提示文字的高度
static CGFloat const kTitleHeight = 65;

// 点击Button执行的代理方法
@class QFActionSheet;
@protocol QFActionSheetDelegate <NSObject>

- (void)actionSheet:(QFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

/** 定义block */
typedef void(^QFActionSheetBlock)(QFActionSheet *actionSheet, NSInteger buttonIndex);
@interface QFActionSheet : UIView

@property (nonatomic, assign)id<QFActionSheetDelegate> delegate;

/** 
 *  btnTitles：传入的是按钮的标题数组，最后的一个最好加上"取消"按钮
 */
- (instancetype)initWithButtonTitles:(NSArray *)btnTitles delegate:(id<QFActionSheetDelegate>) delegate;

/**
 *  btnTitles：传入的是按钮的标题数组，最后的一个最好加上"取消"按钮
 *  title: 显示在最上面的title
 */
- (instancetype)initWithButtonTitles:(NSArray *)btnTitles title:(NSString *)title delegate:(id<QFActionSheetDelegate>) delegate;

/** 使用block */
@property (nonatomic, copy)QFActionSheetBlock block;

/** 初始化之后，需要调用show方法展示QFActionSheet,可以传空，传空则加在window上面 */
- (void)showInView:(UIView *)view;

@end
