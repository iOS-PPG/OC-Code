//
//  UIImageView+HJWebCache.h
//  Temp
//
//  Created by GiaJiang on 2019/5/15.
//  Copyright © 2019 PPG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (HJWebCache)

- (void)hj_setImageWithURL:(nullable NSString *)url;

- (void)hj_setOriginalImageWithURL:(nullable NSString *)url;

- (void)hj_setImageWithURL:(nullable NSString *)url
           placeholderImage:(nullable UIImage *)placeholder;

- (void)hj_setImageWithURL:(nullable NSString *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options;

- (void)hj_setImageWithURL:(nullable NSString *)url
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)hj_setImageWithURL:(nullable NSString *)url
           placeholderImage:(nullable UIImage *)placeholder
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)hj_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)hj_setImageWithURL:(nullable NSString *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
