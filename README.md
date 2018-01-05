# QFPhotoBrower
### 使用方法
1.创建QFPhotoItem

2.创建QFPhotoBrower

3.显示QFPhotoBrower

### 显示网络图片
 ```
 QFPhotoItem *item1 = [[QFPhotoItem alloc] initWithThumbView:_imageView1 largeImageURL:[NSURL URLWithString:str1]];
 QFPhotoItem *item2 = [[QFPhotoItem alloc] initWithThumbView:_imageView2 largeImageURL:[NSURL URLWithString:str2]];
 QFPhotoItem *item3 = [[QFPhotoItem alloc] initWithThumbView:_imageView3 largeImageURL:[NSURL URLWithString:str3]];
 _items = @[item1, item2, item3];
 QFPhotoBrower *brower = [[QFPhotoBrower alloc] initWithPhotoItems:_items];
 brower.blurEffectBackground = YES; // 是否显示blur样式的背景
 [brower presentFromImageView:_imageView1 toContrainer:self.navigationController.view animated:YES completion:nil];
 ```
 
 
###显示本地图片
  ```
 QFPhotoItem *item1 = [[QFPhotoItem alloc] initWithThumbView:_imageView1 largeImageURL:nil];
 QFPhotoItem *item2 = [[QFPhotoItem alloc] initWithThumbView:_imageView2 largeImageURL:nil];
 QFPhotoItem *item3 = [[QFPhotoItem alloc] initWithThumbView:_imageView3 largeImageURL:nil];
 _items = @[item1, item2, item3];
 QFPhotoBrower *brower = [[QFPhotoBrower alloc] initWithPhotoItems:_items];
 brower.blurEffectBackground = NO; // 是否显示blur样式的背景
 [brower presentFromImageView:_imageView1 toContrainer:self.navigationController.view animated:YES completion:nil];
 ```
 
###显示无frame的网络图片
```
    NSString *str1 = @"str1";
    NSString *str2 = @"str2";
    NSString *str3 = @"str3";
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"curry3.jpg"]]; // 占位图片
    
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
```

###Tip
在iOS9之后，`[[UIApplication sharedApplication] setStatusBarHidden: withAnimation:]`这个方法不能隐藏statusBar了，所以要想隐藏的话，需要在自己的ViewController中自己监听。`QFPhotoBrower`提供了`CompletionBlock`即相册消失的回调，可以在回调中显示statusBar。具体的实现请看Demo。1

###示例：
![Example](./example.gif)

#### 在此要感谢YY同学，没有YY同学的[YYKit](https://github.com/ibireme/YYKit),我可能做不出这样的控件。如果觉得不错，请给我一个star吧！
