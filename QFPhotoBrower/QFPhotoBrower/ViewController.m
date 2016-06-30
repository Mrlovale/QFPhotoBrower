//
//  ViewController.m
//  QFPhotoBrower
//
//  Created by hlxdev on 16/6/29.
//  Copyright © 2016年 hlxdev. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "QFPhotoBrower.h"
#import "QFPhotoItem.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@property (nonatomic, strong)NSArray *items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str1 = @"http://www.77331133.cc/imgall/mvqxg6lsmvqwiltqnaxdcmrwfzxgk5a/a9XkApua04_CNIY7YU4vrQ==/7916625556990539946.jpg";
    NSString *str2 = @"http://img1.gtimg.com/sports/pics/hv1/104/188/2086/135690194.jpg";
    NSString *str3 = @"http://v3img.ifensi.com/xw_imgs/2016/06/24/c5b4473682048.jpg";
    
    [_imageView1 sd_setImageWithURL:[NSURL URLWithString:str1]];
    [_imageView2 sd_setImageWithURL:[NSURL URLWithString:str2]];
    [_imageView3 sd_setImageWithURL:[NSURL URLWithString:str3]];
    
    QFPhotoItem *item1 = [[QFPhotoItem alloc] initWithThumbView:_imageView1 largeImageURL:[NSURL URLWithString:str1]];
    QFPhotoItem *item2 = [[QFPhotoItem alloc] initWithThumbView:_imageView2 largeImageURL:[NSURL URLWithString:str2]];
    QFPhotoItem *item3 = [[QFPhotoItem alloc] initWithThumbView:_imageView3 largeImageURL:[NSURL URLWithString:str3]];
    _items = @[item1, item2, item3];
    
}
- (IBAction)image1Tap:(UITapGestureRecognizer *)sender {
    NSLog(@"image1Tap");
    
    QFPhotoBrower *brower = [[QFPhotoBrower alloc] initWithPhotoItems:_items];
    [brower presentFromImageView:_imageView1 toContrainer:self.navigationController.view animated:YES completion:nil];
}
- (IBAction)image2Tap:(UITapGestureRecognizer *)sender {
    NSLog(@"image2Tap");
    
    QFPhotoBrower *brower = [[QFPhotoBrower alloc] initWithPhotoItems:_items];
    [brower presentFromImageView:_imageView2 toContrainer:self.navigationController.view animated:YES completion:nil];
}
- (IBAction)image3Tap:(UITapGestureRecognizer *)sender {
    NSLog(@"image3Tap");
    
    QFPhotoBrower *brower = [[QFPhotoBrower alloc] initWithPhotoItems:_items];
    [brower presentFromImageView:_imageView3 toContrainer:self.navigationController.view animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
