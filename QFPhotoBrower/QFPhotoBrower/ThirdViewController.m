//
//  ThirdViewController.m
//  QFPhotoBrower
//
//  Created by hlxdev on 16/6/30.
//  Copyright © 2016年 hlxdev. All rights reserved.
//

#import "ThirdViewController.h"
#import "QFPhotoBrower.h"
#import "QFPhotoItem.h"

@implementation ThirdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (IBAction)click:(id)sender {
    
    NSString *str1 = @"http://www.77331133.cc/imgall/mvqxg6lsmvqwiltqnaxdcmrwfzxgk5a/a9XkApua04_CNIY7YU4vrQ==/7916625556990539946.jpg";
    NSString *str2 = @"http://img1.gtimg.com/sports/pics/hv1/104/188/2086/135690194.jpg";
    NSString *str3 = @"http://v3img.ifensi.com/xw_imgs/2016/06/24/c5b4473682048.jpg";
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"curry3.jpg"]]; // 占位图片
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    tempImageView.frame = CGRectMake((width - 100) * 0.5, (height - 100) * 0.5, 100, 100);
    
    QFPhotoItem *item1 = [[QFPhotoItem alloc] initWithThumbView:tempImageView largeImageURL:[NSURL URLWithString:str1]];
    QFPhotoItem *item2 = [[QFPhotoItem alloc] initWithThumbView:tempImageView largeImageURL:[NSURL URLWithString:str2]];
    QFPhotoItem *item3 = [[QFPhotoItem alloc] initWithThumbView:tempImageView largeImageURL:[NSURL URLWithString:str3]];
    NSArray *items = @[item1, item2, item3];
    
    QFPhotoBrower *brower = [[QFPhotoBrower alloc] initWithPhotoItems:items];
    brower.explainDismiss = YES;
    [brower presentFromImageView:tempImageView toContrainer:self.navigationController.view animated:NO completion:nil];
    [self showStatusBar:brower];
    
    self.statusBarHidden = YES;
}

- (void)showStatusBar:(QFPhotoBrower *)brower
{
    __weak typeof(self) weakSelf = self;
    brower.completionBlock = ^(){
        weakSelf.statusBarHidden = NO;
    };
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    _statusBarHidden = statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
    return _statusBarHidden;
}

@end

