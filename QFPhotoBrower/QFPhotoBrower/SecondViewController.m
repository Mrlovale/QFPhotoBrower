//
//  SecondViewController.m
//  QFPhotoBrower
//
//  Created by hlxdev on 16/6/30.
//  Copyright © 2016年 hlxdev. All rights reserved.
//

#import "SecondViewController.h"
#import "QFPhotoBrower.h"
#import "QFPhotoItem.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@property (nonatomic, strong)NSArray *imagesArray;
@property (nonatomic, strong)NSArray *itemsArray;
@property (nonatomic, assign)BOOL statusBarHidden;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imagesArray = @[_imageView1.image, _imageView2.image, _imageView3.image];
    
    QFPhotoItem *item1 = [[QFPhotoItem alloc] initWithThumbView:_imageView1 largeImageURL:nil];
    QFPhotoItem *item2 = [[QFPhotoItem alloc] initWithThumbView:_imageView2 largeImageURL:nil];
    QFPhotoItem *item3 = [[QFPhotoItem alloc] initWithThumbView:_imageView3 largeImageURL:nil];
    self.itemsArray = @[item1,item2,item3];
}

- (IBAction)imageTap:(UITapGestureRecognizer *)sender {
    
    
    QFPhotoBrower *brower = [[QFPhotoBrower alloc] initWithPhotoItems:self.itemsArray];
    [brower presentFromImageView:_imageView1 toContrainer:self.navigationController.view animated:YES completion:nil];
    [self showStatusBar:brower];
    
    self.statusBarHidden = YES;
}

- (IBAction)image2Tap:(id)sender {
    QFPhotoBrower *brower = [[QFPhotoBrower alloc] initWithPhotoItems:self.itemsArray];
    [brower presentFromImageView:_imageView2 toContrainer:self.navigationController.view animated:YES completion:nil];
    [self showStatusBar:brower];
    
    self.statusBarHidden = YES;
}

- (IBAction)image3Tap:(id)sender {
    QFPhotoBrower *brower = [[QFPhotoBrower alloc] initWithPhotoItems:self.itemsArray];
    [brower presentFromImageView:_imageView3 toContrainer:self.navigationController.view animated:YES completion:nil];
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
