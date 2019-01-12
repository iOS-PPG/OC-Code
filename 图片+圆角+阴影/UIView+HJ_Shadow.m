//
//  UIView+HJ_Shadow.m
//  HJTextView
//
//  Created by GiaJiang on 2019/1/10.
//  Copyright © 2019 PPG. All rights reserved.
//

#import "UIView+HJ_Shadow.h"

@implementation UIView (HJ_Shadow)

- (UIView *)hj_shadowViewAddForSuperView:(UIView *)superView
                                   frame:(CGRect)frame
                            shadowOffset:(CGSize)shadowOffset
                             shadowColor:(UIColor *)shadowColor
                            shadowRadius:(CGFloat)shadowRadius
                            cornerRadius:(CGFloat)cornerRadius {

    UIView *shadowView = [UIView new];
    shadowView.backgroundColor = [UIColor clearColor];
    // 偏移量
    [shadowView.layer setShadowOffset:shadowOffset];
    // 阴影颜色
    [shadowView.layer setShadowColor:[shadowColor CGColor]];
    // 透明度
    [shadowView.layer setShadowOpacity:1.0f];
    // 半径 默认 3
    shadowView.layer.shadowRadius = shadowRadius;
    shadowView.layer.masksToBounds = NO;
    shadowView.frame = frame;
    
    [shadowView addSubview:self];
    [superView addSubview:shadowView];
    self.frame = shadowView.bounds;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    return shadowView;
}

- (void)hj_addShadowWithOffset:(CGSize)offset
                  shadowRadius:(CGFloat)shadowRadius
                   shadowColor:(UIColor *)shadowColor {
    // 偏移量
    [self.layer setShadowOffset:offset];
    //  半径 默认 3
    self.layer.shadowRadius = shadowRadius;
    // 阴影颜色
    [self.layer setShadowColor:shadowColor.CGColor];
    // 透明度
    [self.layer setShadowOpacity:1.0f];
}

@end
