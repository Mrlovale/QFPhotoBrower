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
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"curry3.jpg"]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"curry3.jpg"]];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"curry3.jpg"]];
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    imageView1.frame = CGRectMake((width - 100) * 0.5, (height - 100) * 0.5, 100, 100);
    imageView2.frame = CGRectMake((width - 100) * 0.5, (height - 100) * 0.5, 100, 100);
    imageView3.frame = CGRectMake((width - 100) * 0.5, (height - 100) * 0.5, 100, 100);
    
    QFPhotoItem *item1 = [[QFPhotoItem alloc] initWithThumbView:imageView1 largeImageURL:[NSURL URLWithString:str1]];
    QFPhotoItem *item2 = [[QFPhotoItem alloc] initWithThumbView:imageView2 largeImageURL:[NSURL URLWithString:str2]];
    QFPhotoItem *item3 = [[QFPhotoItem alloc] initWithThumbView:imageView3 largeImageURL:[NSURL URLWithString:str3]];
    NSArray *items = @[item1, item2, item3];
    
    QFPhotoBrower *brower = [[QFPhotoBrower alloc] initWithPhotoItems:items];
    brower.explainDismiss = YES;
    [brower presentFromImageView:imageView1 toContrainer:self.navigationController.view animated:YES completion:nil];
}

@end

