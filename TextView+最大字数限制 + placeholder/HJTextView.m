//
//  HJTextView.m
//  HJTextView
//
//  Created by GiaJiang on 2019/1/9.
//  Copyright © 2019 PPG. All rights reserved.
//

#import "HJTextView.h"

@interface HJTextView ()
<
    UITextViewDelegate
>
{
    struct {
        unsigned int shouldBeginEdit: 1;
        unsigned int shouldEndEdit: 1;
        unsigned int didBeginEdit: 1;
        unsigned int didEndEdit: 1;
        unsigned int shouldChangeTextInRange: 1;
        unsigned int didChange: 1;
        unsigned int didChangeSelection: 1;
        unsigned int shouldInteractWithURL: 1;
        unsigned int shouldInteractWithTextAttachment: 1;
        
    } _delegateFlags;
}

@property (nonatomic, strong) UILabel *placeHolderLab;
@property (nonatomic, assign) BOOL hidePlaceHolderWhenEdit;

@end


@implementation HJTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self initWithSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        [self initWithSubViews];
    }
    return self;
}

#pragma mark -----------------
#pragma mark - Private
- (void)initWithSubViews {
    self.delegate = self;
    [self addSubview:self.placeHolderLab];
    _hidePlaceHolderWhenEdit = YES;
    _maxTextNum = 10^10;
    _placeholderFont = [UIFont systemFontOfSize:12];
    _placeholderColor =
    _placeHolderLab.textColor =
    [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:)
                                                 name:@"UITextViewTextDidChangeNotification" object:self];
    
}

#pragma mark - setter/getter
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [_placeholder boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _placeholderFont} context:nil].size;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = size.height;
    
    if (self.text.length == 0) {
        // 获取光标的 origin
        CGRect cursorRect = [self caretRectForPosition:self.selectedTextRange.start];
        _placeHolderLab.frame = CGRectMake(cursorRect.origin.x, cursorRect.origin.y, width - cursorRect.origin.x * 2, height);
    }
    
}

#pragma mark -----------------
#pragma mark - NSNotification
- (void)textViewEditChanged:(NSNotification *)notify {
    
    UITextView *textView = (UITextView *)notify.object;
    NSString *toBeString = textView.text;
    
    NSString *lang = [textView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入
        
        // 获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _maxTextNum) {
                textView.text = [toBeString substringToIndex:_maxTextNum];
            }
        }
        
    }else { // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > _maxTextNum) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_maxTextNum];
            if (rangeIndex.length == 1) {
                textView.text = [toBeString substringToIndex:_maxTextNum];
            }else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxTextNum)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
        
    }
    
    if (_delegateFlags.didChange) {
        [_hj_delegate hj_textViewDidChange:textView];
    }
    
}

#pragma mark -----------------
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (_hidePlaceHolderWhenEdit) {
        _placeHolderLab.text = @"";
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (_hidePlaceHolderWhenEdit) {
        _placeHolderLab.text = textView.text.length == 0 ? _placeholder : @"";
    }
    
    if (_delegateFlags.didEndEdit) {
        [_hj_delegate hj_textViewDidEndEditing:textView];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView {
    

    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (_delegateFlags.shouldBeginEdit) {
        return [_hj_delegate hj_textViewShouldBeginEditing:textView];
    }
    return YES;
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
 
    if (_delegateFlags.didChangeSelection) {
        [_hj_delegate hj_textViewDidChangeSelection:textView];
    }
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (_delegateFlags.didEndEdit) {
        [_hj_delegate hj_textViewDidEndEditing:textView];
    }
    
    return YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (_delegateFlags.shouldChangeTextInRange) {
        [_hj_delegate hj_textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(nonnull NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if (_delegateFlags.shouldInteractWithTextAttachment) {
        [_hj_delegate hj_textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction];
    }
    
    return YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if (_delegateFlags.shouldInteractWithURL) {
        [_hj_delegate hj_textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    }
    
    return YES;
    
}

#pragma mark - setter and getter
- (void)setHj_delegate:(id<HJTextViewDelegate>)hj_delegate {
    _hj_delegate = hj_delegate;
    
    _delegateFlags.didChange = [hj_delegate respondsToSelector:@selector(hj_textViewDidChange:)];
    _delegateFlags.didEndEdit = [hj_delegate respondsToSelector:@selector(hj_textViewDidEndEditing:)];
    _delegateFlags.didBeginEdit = [hj_delegate respondsToSelector:@selector(hj_textViewDidBeginEditing:)];
    _delegateFlags.didChangeSelection = [hj_delegate respondsToSelector:@selector(hj_textViewDidChangeSelection:)];
    _delegateFlags.shouldBeginEdit = [hj_delegate respondsToSelector:@selector(hj_textViewShouldBeginEditing:)];
    _delegateFlags.shouldEndEdit = [hj_delegate respondsToSelector:@selector(hj_textViewShouldEndEditing:)];
    _delegateFlags.shouldChangeTextInRange = [hj_delegate respondsToSelector:@selector(hj_textView:shouldChangeTextInRange:replacementText:)];
    _delegateFlags.shouldInteractWithURL = [hj_delegate respondsToSelector:@selector(hj_textView:shouldInteractWithURL:inRange:interaction:)];
    _delegateFlags.shouldInteractWithTextAttachment = [hj_delegate respondsToSelector:@selector(hj_textView:shouldInteractWithTextAttachment:inRange:interaction:)];
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeHolderLab.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    _placeHolderLab.textColor = placeholderColor;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    _placeHolderLab.font = placeholderFont;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    if (!_placeholderFont) _placeHolderLab.font = font;   
}

- (UILabel *)placeHolderLab {
    if (!_placeHolderLab) {
        _placeHolderLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _placeHolderLab.numberOfLines = 0;
        _placeHolderLab.font = self.font;
    }
    return _placeHolderLab;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
