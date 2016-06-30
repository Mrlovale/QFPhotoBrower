//
//  QFActionSheet.m
//  SImpleActionSheet
//
//  Created by hlxdev on 15/9/15.
//  Copyright (c) 2015年 hlxdev. All rights reserved.
//

#import "QFActionSheet.h"
#import "QFActionSheetItem.h"

#define screenW [[UIScreen mainScreen] bounds].size.width
#define screenH [[UIScreen mainScreen] bounds].size.height

@interface QFActionSheet ()

@property (nonatomic, strong)NSArray *titlesArray;
@property (nonatomic, weak)UIView *backgroundView;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)CGFloat bakgroundViewH;

@end

@implementation QFActionSheet

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTap)];
        [backgroundView addGestureRecognizer:tap];
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}

#pragma mark - public
- (instancetype)initWithButtonTitles:(NSArray *)btnTitles delegate:(id<QFActionSheetDelegate>) delegate
{
    return [self initWithButtonTitles:btnTitles title:nil delegate:delegate];
}

- (instancetype)initWithButtonTitles:(NSArray *)btnTitles title:(NSString *)title delegate:(id<QFActionSheetDelegate>) delegate
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.alpha = 0.1;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
        [self addGestureRecognizer:tap];
        
        self.titlesArray = btnTitles;
        self.title = title;
        self.delegate = delegate;
        [self setupSubViews];
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    if (view) {
        [UIView animateWithDuration:0.25 animations:^{
            [view addSubview:self];
            self.alpha = 1.0;
            CGRect rect = self.backgroundView.frame;
            rect.origin.y -= _bakgroundViewH;
            self.backgroundView.frame = rect;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:self];
            self.alpha = 1.0;
            CGRect rect = self.backgroundView.frame;
            rect.origin.y -= _bakgroundViewH;
            self.backgroundView.frame = rect;
        }];
    }
    
}


#pragma mark - privite
/** 初始化视图 */
- (void)setupSubViews
{
    NSInteger count = self.titlesArray.count;
    if (count == 0) {
        return;
    }
    
    if (self.title) {
        QFActionSheetItem *titleItem = [[QFActionSheetItem alloc] init];
        [titleItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        titleItem.titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleItem.userInteractionEnabled = NO;
        [titleItem setTitle:self.title forState:UIControlStateNormal];
        [self.backgroundView addSubview:titleItem];
    }
    
    for (int i = 0; i < count; i++) {
        QFActionSheetItem *item = [[QFActionSheetItem alloc] init];
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        item.identifier = i;
        NSString *title = self.titlesArray[i];
        [item setTitle:title forState:UIControlStateNormal];
        [self.backgroundView addSubview:item];
    }
    
    [self setFrames];
}

- (void)setFrames
{
    self.frame = CGRectMake(0, 0, screenW, screenH);
    
    NSInteger count = self.titlesArray.count;
    CGFloat width = screenW;
    CGFloat height = kBtnHeight * count + kMargin * (count - 1);
    CGFloat x = 0;
    if (self.title) {
        height  += kTitleHeight + 0.5;
        QFActionSheetItem *item = self.backgroundView.subviews[0];
        item.frame = CGRectMake(0, 0, width, kTitleHeight);
    }
    _bakgroundViewH = height;
    self.backgroundView.frame = CGRectMake(x, screenH, width, height);
    
    CGFloat itemW = width;
    CGFloat itemH = kBtnHeight;
    CGFloat itemX = 0;
    CGFloat margin = kMargin;
    CGFloat top = self.title ? kTitleHeight + 0.5 : 0;
    for (int i = (int)count - 1; i >= 0; i--) {
        int j = self.title ? i+1 : i;
        QFActionSheetItem *item = self.backgroundView.subviews[j];
        if (i < count - 1) {
            margin = 0.5;
        }
        CGFloat itemY = (itemH + margin) * i + top;
        item.frame = CGRectMake(itemX, itemY, itemW, itemH);
    }
    
}

- (void)itemClick:(QFActionSheetItem *)item
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:item.identifier];
        [self removeSelf];
    }
    
    if (self.block) {
        self.block(self, item.identifier);
        [self removeSelf];
    }
}

- (void)removeSelf
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect originRect = self.backgroundView.frame;
        originRect.origin.y += _bakgroundViewH;
        self.backgroundView.frame = originRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alpha = 0;
    }];
}

- (void)backgroundViewTap{
}

@end
