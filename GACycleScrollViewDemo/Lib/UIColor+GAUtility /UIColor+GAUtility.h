//
//  UIColor+GAUtility.h
//  GATouchRippleViewDemo
//
//  Created by GikkiAres on 2016/12/1.
//  Copyright © 2016年 Explorer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GAUtility)
//获取随机颜色
+(instancetype)randomColor;
//16进制值: 0x1234ff
+(instancetype)colorWithHex:(long)hexColor;
+(instancetype)colorWithHex:(long)hexColor alpha:(float)opacity;
//10进制,rgb∈[0,255],a∈[0,1]
+(instancetype)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;

//10进制字符串,如:@"123,123,123,1";
+(instancetype)colorWithRGBADecimalString:(NSString *)str;

//16进制字符串,如 @"e54a52";
+(instancetype)colorWithRGBHexString:(NSString *)str;

@end
