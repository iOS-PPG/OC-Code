//
//  UIImageView+SD_Fade.m
//  Temp
//
//  Created by GiaJiang on 2019/5/15.
//  Copyright © 2019 PPG. All rights reserved.
//

#import "UIImageView+HJWebCache.h"

@implementation UIImageView (HJWebCache)


- (void)hj_setImageWithURL:(nullable NSString *)url {
    [self hj_setImageWithURL:url
             placeholderImage:nil
                      options:0
                     progress:nil
                    completed:nil];
}


- (void)hj_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder {
    [self hj_setImageWithURL:url
             placeholderImage:placeholder
                      options:0
                     progress:nil
                    completed:nil];
}

- (void)hj_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options {
    [self hj_setImageWithURL:url
             placeholderImage:placeholder
                      options:options
                     progress:nil
                    completed:nil];
}

- (void)hj_setImageWithURL:(nullable NSString *)url completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self hj_setImageWithURL:url
             placeholderImage:nil
                      options:0
                     progress:nil
                    completed:completedBlock];
}

- (void)hj_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self hj_setImageWithURL:url
             placeholderImage:placeholder
                      options:0
                     progress:nil
                    completed:completedBlock];
}

- (void)hj_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self hj_setImageWithURL:url
             placeholderImage:placeholder
                      options:options
                     progress:nil
                    completed:completedBlock];
}

- (void)hj_setImageWithURL:(nullable NSString *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock {
    
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                    progress:progressBlock
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       
                       if (cacheType == SDImageCacheTypeNone) {
                           CATransition *animation = [CATransition animation];
                           [animation setDuration:0.65f];
                           [animation setType:kCATransitionFade];
                           animation.removedOnCompletion = YES;
                           [self.layer addAnimation:animation forKey:@"transition"];
                           
                       }
                       
                       !completedBlock?:completedBlock(image, error, cacheType, imageURL);
                   }];
}


@end
