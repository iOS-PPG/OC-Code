//
//  HJTextView.h
//  HJTextView
//
//  Created by GiaJiang on 2019/1/9.
//  Copyright © 2019 PPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HJTextViewDelegate <NSObject>

@optional
- (BOOL)hj_textViewShouldBeginEditing:(UITextView *)textView;
- (BOOL)hj_textViewShouldEndEditing:(UITextView *)textView;

- (void)hj_textViewDidBeginEditing:(UITextView *)textView;
- (void)hj_textViewDidEndEditing:(UITextView *)textView;

- (BOOL)hj_textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)hj_textViewDidChange:(UITextView *)textView;

- (void)hj_textViewDidChangeSelection:(UITextView *)textView;

- (BOOL)hj_textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0);
- (BOOL)hj_textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0);


@end

NS_ASSUME_NONNULL_BEGIN

@interface HJTextView : UITextView

@property (nonatomic, weak) id<HJTextViewDelegate> hj_delegate;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;
@property (nonatomic, assign) NSInteger maxTextNum;


@end

NS_ASSUME_NONNULL_END
