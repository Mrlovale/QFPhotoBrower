//
//  UIColor+Hex.m
//  quan
//
//  Created by xizi on 14-7-8.
//  Copyright (c) 2014年 xizi. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha
{

    if (hex.length == 0 || hex.length != 6) {
        return nil;
    }

    NSString *rgb = hex;

    int R = 0, G = 0, B = 0;

    rgb = [rgb uppercaseString];

    //计算R的值
    int c1 = [rgb characterAtIndex:0];
    if(c1<=57&&c1>=48){
        R = R+(c1-'0')*16;
    } else if(c1>=65&&c1<=70){
        R = R+(c1-'0'-7)*16;
    }
    int c2 = [rgb characterAtIndex:1];
    if(c2<=57&&c2>=48){
        R = R+(c2-'0');
    } else if(c2>=65&&c2<=70){
        R = R+(c2-'0'-7);
    }

    //计算G的值
    int c3 = [rgb characterAtIndex:2];
    if(c3<=57&&c3>=48){
        G = G+(c3-'0')*16;
    } else if(c3>=65&&c3<=70){
        G = G+(c3-'0'-7)*16;
    }
    int c4 = [rgb characterAtIndex:3];
    if(c4<=57&&c4>=48){
        G = G+(c4-'0');
    } else if(c4>=65&&c4<=70){
        G = G+(c4-'0'-7);
    }

    //计算B的值
    int c5 = [rgb characterAtIndex:4];
    if(c5<=57&&c5>=48){
        B = B+(c5-'0')*16;
    } else if(c5>=65&&c5<=70){
        B = B+(c5-'0'-7)*16;
    }
    int c6 = [rgb characterAtIndex:5];
    if(c6<=57&&c6>=48){
        B = B+(c6-'0');
    } else if(c6>=65&&c6<=70){
        B = B+(c6-'0'-7);
    }

    UIColor *color = [[UIColor alloc] initWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:alpha];

    return color;

}
@end
