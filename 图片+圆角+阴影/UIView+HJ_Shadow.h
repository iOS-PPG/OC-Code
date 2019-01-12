//
//  UIView+HJ_Shadow.h
//  HJTextView
//
//  Created by GiaJiang on 2019/1/10.
//  Copyright © 2019 PPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HJ_Shadow)

//  给含有图片的视图 + 阴影 + 圆角
- (UIView *)hj_shadowViewAddForSuperView:(UIView *)superView
                                   frame:(CGRect)frame
                            shadowOffset:(CGSize)shadowOffset
                             shadowColor:(UIColor *)shadowColor
                            shadowRadius:(CGFloat)shadowRadius
                            cornerRadius:(CGFloat)cornerRadius;

// 直接加阴影
- (void)hj_addShadowWithOffset:(CGSize)offset
                  shadowRadius:(CGFloat)shadowRadius
                   shadowColor:(UIColor *)shadowColor;

@end

