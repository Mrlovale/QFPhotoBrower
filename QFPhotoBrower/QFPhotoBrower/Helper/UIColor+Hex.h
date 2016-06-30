//
//  UIColor+Hex.h
//  quan
//
//  Created by xizi on 14-7-8.
//  Copyright (c) 2014年 xizi. All rights reserved.
//

#import <UIKit/UIKit.h>

//默认不透明度的
#define COLOR_WITH_HEX(HEX) [UIColor colorWithHex:(HEX) alpha:1]
#define COLOR_WITH_HEX_ALPHA(HEX,ALPLA) [UIColor colorWithHex:(HEX) alpha:ALPLA]

@interface UIColor (Hex)
/**
 *  通过16进制获取Color
 *
 *  @param hex 16进制字符串不需要#
 *  
 *  @param alpha 透明度
 *
 *  @return Color
 */
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

@end
