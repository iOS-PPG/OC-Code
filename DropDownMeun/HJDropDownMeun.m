HJDropDownMeun//
//  HJFilterTopMeunView.m
//  Test
//
//  Created by GiaJiang on 2019/6/14.
//  Copyright © 2019 PPG. All rights reserved.
//

#import "HJDropDownMeun.h"

@interface NSString (Sise)

- (CGFloat)widthWithHeight:(CGFloat)height font:(UIFont *)font;

@end

@implementation NSString (Size)

- (CGFloat)widthWithHeight:(CGFloat)height font:(UIFont *)font {
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : font} context:nil].size.width;
}

- (CGFloat)heightWithWidth:(CGFloat)width font:(UIFont *)font {
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, width) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : font} context:nil].size.height;
}

@end

@implementation HJIndexPath

+ (instancetype)invalidIndexPath {
    HJIndexPath *indexPath = [HJIndexPath new];
    [indexPath invalid];
    return indexPath;
}

- (instancetype)initWithColumn:(NSInteger)column section:(NSInteger)section row:(NSInteger)row {
    if ([super init]) {
        _column = column;
        _section = section;
        _row = row;
    }
    return self;
}

- (void)invalid {
    _column =
    _section =
    _row = NSNotFound;
}

- (BOOL)isInvalid {
    return _column == NSNotFound && _section == NSNotFound && _row == NSNotFound;
}

@end

@interface HJCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CATextLayer *textLayer;
@property (nonatomic, strong) CAShapeLayer *arrowLayer;

@end

@implementation HJCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self.contentView.layer addSublayer:self.textLayer];
        [self.contentView.layer addSublayer:self.arrowLayer];

        [self setFont:[UIFont systemFontOfSize:17]];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSString *fontName = (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(((CGFontRef)_textLayer.font)));
    UIFont *font = [UIFont fontWithName:fontName size:_textLayer.fontSize];

    CGFloat width = [self.textLayer.string widthWithHeight:self.frame.size.height font:font];
    CGFloat height = [self.textLayer.string heightWithWidth:MAXFLOAT font:font];
    CGFloat maxWidth = self.frame.size.width - 10 - 7 - 8;
    width = MIN(width, maxWidth);

    CGFloat left = (self.frame.size.width -  (width + 7 + 8)) / 2;
    _textLayer.frame = CGRectMake(left,
                                  (self.frame.size.height - height) / 2,
                                  width,
                                  height);

    _arrowLayer.frame = CGRectMake(
                                   CGRectGetMaxX(_textLayer.frame) + 4,
                                   (self.frame.size.height - 5) / 2,
                                   8, 5);
}

- (void)setFont:(UIFont *)font {
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.textLayer.font = fontRef;
    self.textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTextString:(NSString *)textString {

    self.textLayer.string = textString;

    [self setNeedsLayout];
    [self layoutIfNeeded];

}

- (void)setContentColor:(UIColor *)color {
    _textLayer.foregroundColor =
    _arrowLayer.fillColor = color.CGColor;
}

#pragma mark - setter and getter
- (CAShapeLayer *)arrowLayer {
    if (!_arrowLayer) {
        _arrowLayer = [CAShapeLayer new];

        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(8, 0)];
        [path addLineToPoint:CGPointMake(4, 5)];
        [path closePath];

        _arrowLayer.path = path.CGPath;
        _arrowLayer.lineWidth = 1;

    }
    return _arrowLayer;
}

- (CATextLayer *)textLayer {
    if (!_textLayer) {
        _textLayer = [[CATextLayer alloc]init];
        _textLayer.alignmentMode = kCAAlignmentCenter;
        _textLayer.truncationMode = kCATruncationEnd;
        _textLayer.contentsScale = 2;
    }
    return _textLayer;
}

@end

@interface HJDropDownMeun ()
<
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) HJIndexPath *selectIndexPath;
@property (nonatomic, strong) UICollectionView *topCollectionView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation HJDropDownMeun

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        _selectIndexPath = [HJIndexPath invalidIndexPath];

        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.topCollectionView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self.bgView addGestureRecognizer:tap];

        _leftTableView = [self creatTableView];
        _rightTableView = [self creatTableView];

        [self.layer addSublayer:self.lineLayer];

    }
    return self;
}


#pragma mark -----------------
#pragma mark - Private
- (UITableView *)creatTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.separatorColor = [UIColor lightGrayColor];
    tableView.backgroundColor = [UIColor lightTextColor];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    return tableView;
}

- (void)animateWithTableView:(UITableView *)tableView show:(BOOL)show showHeight:(CGFloat)showHeight {

    if (show) {
        [self.superview addSubview:tableView];

        [UIView animateWithDuration:0.3 animations:^{
           tableView.frame = CGRectMake(
                                        tableView.frame.origin.x,
                                        tableView.frame.origin.y,
                                        tableView.frame.size.width,
                                        showHeight);
        } completion:^(BOOL finished) {
        }];

    }else {

        [UIView animateWithDuration:0.3 animations:^{
            tableView.frame = CGRectMake(
                                         tableView.frame.origin.x,
                                         tableView.frame.origin.y,
                                         tableView.frame.size.width,
                                         0);
        } completion:^(BOOL finished) {
            [tableView removeFromSuperview];
        }];

    }

}

- (void)animateWithBgView:(UIView *)bgView show:(BOOL)show {
    if (show) {
        [self.superview addSubview:bgView];

        bgView.frame = CGRectMake(
                                   0,
                                   CGRectGetMaxY(self.frame),
                                   self.frame.size.width,
                                   self.superview.frame.size.height - CGRectGetMaxY(self.frame));
        bgView.alpha = 0;

        [UIView animateWithDuration:0.3 animations:^{
        } completion:^(BOOL finished) {
            bgView.alpha = 1.0;
        }];

    }else {

        [UIView animateWithDuration:0.3 animations:^{
            bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
             [bgView removeFromSuperview];
        }];

    }
}

- (void)animateDropDownMeunWithShow:(BOOL)show {

    NSInteger numberOfsection = [self numberSectionInColumn:_selectIndexPath.column];

    NSInteger leftRows = [self tableView:_leftTableView numberOfRowsInSection:0];
    CGFloat leftRowHeight = [self tableView:_leftTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndexPath.section inSection:0]];
    CGFloat leftHeight = leftRows * leftRowHeight;

    NSInteger rightRows = [self tableView:_rightTableView numberOfRowsInSection:0];
    CGFloat rightRowHeight = [self tableView:_rightTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndexPath.row inSection:0]];
    CGFloat rightHeight = rightRows * rightRowHeight;

    CGFloat tableViewHeight = MIN(MAX(leftHeight, rightHeight), self.superview.frame.size.height - CGRectGetMaxY(self.frame));

    [self animateWithBgView:_bgView show:show];

    if (numberOfsection > 1) {
        [self animateWithTableView:_leftTableView show:show showHeight:tableViewHeight];
    }

    [self animateWithTableView:_rightTableView show:show showHeight:tableViewHeight];


}

#pragma mark -----------------
#pragma mark - Action
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture {

    [self topMeunCancelSelect];

}

- (void)topMeunCancelSelect {
    HJCollectionViewCell *cell = (HJCollectionViewCell *)[_topCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectIndexPath.column inSection:0]];
    [cell setContentColor:_normalColor];
    [self animateDropDownMeunWithShow:NO];

    [_selectIndexPath invalid];
}

- (void)topMeunRestore {
    [self animateDropDownMeunWithShow:NO];
    NSInteger column = _selectIndexPath.column;
    [_selectIndexPath invalid];
    [_topCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:column inSection:0]]];
}

- (NSInteger)numberSectionInColumn:(NSInteger)column {
    NSInteger sectionNum = 1;
    if (_dataSource && [_dataSource respondsToSelector:@selector(dropDownMeun:numberSectionInColumn:)]) {
        sectionNum = [_dataSource dropDownMeun:self numberSectionInColumn:column];
    }
    return sectionNum;
}


#pragma mark -----------------
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItem = 0;
    numberOfItem = [self.dataSource numberOfColumnsInDropDownMeun:self];
    return numberOfItem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HJCollectionViewCell class]) forIndexPath:indexPath];

    if ([_dataSource respondsToSelector:@selector(dropDownMeun:titleForColumn:)]) {
        [cell setTextString:[_dataSource dropDownMeun:self titleForColumn:indexPath.item]];
    }

    [cell setContentColor:_selectIndexPath.column == indexPath.item ? self.selectColor : self.normalColor];

    if ([_dataSource respondsToSelector:@selector(dropDownMeun:fontForColumn:)]) {
        [cell setFont:[_dataSource dropDownMeun:self fontForColumn:indexPath.item]];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    // has last selected cell
    if (_selectIndexPath.column == indexPath.row) {
        [self topMeunRestore];
        return;
    }

    HJCollectionViewCell *cell = (HJCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    NSInteger sectionNum = [self numberSectionInColumn:indexPath.item];
    NSInteger column = indexPath.item;
    NSString *title = cell.textLayer.string;

    // update topMeun cell text color
    NSInteger lastColumn = _selectIndexPath.column;
    if (lastColumn != NSNotFound) {
        HJCollectionViewCell *lastCell = (HJCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:lastColumn inSection:0]];
        [lastCell setContentColor:self.normalColor];
    }
    [cell setContentColor:self.selectColor];

    // set selectIndexPath
    _selectIndexPath = [[HJIndexPath alloc] initWithColumn:indexPath.row section:0 row:0];
    BOOL hasSearch = NO;
    for (int i = 0; i < sectionNum; i++) {
        for (int j = 0; j < [_dataSource dropDownMeun:self numberRowInSectionAtIndexPath:[[HJIndexPath alloc] initWithColumn:indexPath.item section:i row:NSNotFound]]; j ++) {
            HJIndexPath *indexPath = [[HJIndexPath alloc] initWithColumn:column section:i row:j];
            if ([title isEqualToString:[_dataSource dropDownMeun:self titleForRowAtIndexPath:indexPath]]) {
                _selectIndexPath = indexPath;
                hasSearch = YES;
                break;
            }
        }
        if (hasSearch) break;
    }

    // update tableView frame
    _leftTableView.hidden = sectionNum == 1;
    [_rightTableView reloadData];
    if (sectionNum > 1) {
        _leftTableView.frame = CGRectMake(0,
                                          CGRectGetMaxY(self.frame),
                                          self.frame.size.width / 2,
                                          0);
        _rightTableView.frame = CGRectMake(CGRectGetMaxX(_leftTableView.frame),
                                           CGRectGetMaxY(self.frame),
                                           self.frame.size.width / 2,
                                           0);
        [_leftTableView reloadData];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndexPath.section inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

    }else {
        _rightTableView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.frame),
                                           self.frame.size.width,
                                           0);
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }


    [self animateDropDownMeunWithShow:YES];

}


#pragma mark -----------------
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 100;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownMeun:widthForColumn:)]) {
        width = [self.delegate dropDownMeun:self widthForColumn:indexPath.item];
    }
    return CGSizeMake(width, self.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1;
}

#pragma mark -----------------
#pragma mark -     UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        NSInteger numberSection = [self numberSectionInColumn:_selectIndexPath.column];
        tableView.hidden = numberSection == 1;
        return numberSection;
    }
    return [_dataSource dropDownMeun:self numberRowInSectionAtIndexPath:_selectIndexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (tableView == _leftTableView) {
        if ([_dataSource respondsToSelector:@selector(dropDownMeun:titleForSectionAtIndexPath:)]) {
            HJIndexPath *hj_indexPath = [[HJIndexPath alloc]initWithColumn:_selectIndexPath.column section:indexPath.row row:NSNotFound];
            cell.textLabel.text = [_dataSource dropDownMeun:self titleForSectionAtIndexPath:hj_indexPath];
        }
        if ([_dataSource respondsToSelector:@selector(dropDownMeun:fontForSection:)]) {
            cell.textLabel.font = [_dataSource dropDownMeun:self fontForSection:indexPath.row];
        }
        cell.tintColor = _selectColor;
        cell.textLabel.textColor = _selectIndexPath.section == indexPath.row ? _selectColor : _normalColor;
        cell.backgroundColor = [UIColor whiteColor];

    }else {
        if ([_dataSource respondsToSelector:@selector(dropDownMeun:titleForRowAtIndexPath:)]) {
            HJIndexPath *hj_indexPath = [[HJIndexPath alloc]initWithColumn:_selectIndexPath.column section:_selectIndexPath.section row:indexPath.row];
            cell.textLabel.text = [_dataSource dropDownMeun:self titleForRowAtIndexPath:hj_indexPath];
        }
        if ([_dataSource respondsToSelector:@selector(dropDownMeun:fontForRow:)]) {
            cell.textLabel.font = [_dataSource dropDownMeun:self fontForRow:indexPath.row];
        }

        cell.accessoryType =_selectIndexPath.row == indexPath.row && [self numberSectionInColumn:_selectIndexPath.column] == 1 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        cell.tintColor = _selectColor;
        cell.textLabel.textColor = _selectIndexPath.row == indexPath.row ? _selectColor : _normalColor;
        cell.backgroundColor = [self numberSectionInColumn:_selectIndexPath.column] == 1 ? [UIColor whiteColor] : [UIColor groupTableViewBackgroundColor];
    }

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height = 0;

    if (tableView == _leftTableView) {
        if ([_delegate respondsToSelector:@selector(heigtForSectionInDropDownMeun:)]) {
            height = [_delegate heigtForSectionInDropDownMeun:self];
        }
    }else {
        if ([_delegate respondsToSelector:@selector(heigtForRowInDropDownMeun:)]) {
             height = [_delegate heigtForRowInDropDownMeun:self];
        }
    }
    return height == 0 ? 44 : height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == _rightTableView) {

        _selectIndexPath.row = indexPath.row;

        if ([_delegate respondsToSelector:@selector(dropDownMeun:didSelectRowAtIndexPath:)]) {
            [_delegate dropDownMeun:self didSelectRowAtIndexPath:_selectIndexPath];
        }

        HJCollectionViewCell *cell = (HJCollectionViewCell *)[_topCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectIndexPath.column inSection:0]];

        if ([_dataSource respondsToSelector:@selector(dropDownMeun:titleForRowAtIndexPath:)]) {
            [cell setTextString:[_dataSource dropDownMeun:self titleForRowAtIndexPath:_selectIndexPath]];
        }

        [self topMeunCancelSelect];


    }else {

        _selectIndexPath.section = indexPath.row;
        _selectIndexPath.row = 0;

        [_rightTableView reloadData];
        [_leftTableView reloadData];

    }

}

#pragma mark - setter/getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _bgView;
}

- (CAShapeLayer *)lineLayer {
    if (nil == _lineLayer) {
        _lineLayer = [CAShapeLayer new];
        _lineLayer.frame = CGRectMake(0, self.frame.size.height - 0.5f, self.frame.size.width, 0.5);
        _lineLayer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
    }
    return _lineLayer;
}

- (UICollectionView *)topCollectionView {
    if (!_topCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _topCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        [_topCollectionView registerClass:[HJCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HJCollectionViewCell class])];
        _topCollectionView.backgroundColor = [UIColor whiteColor];
        _topCollectionView.showsHorizontalScrollIndicator = NO;
        _topCollectionView.bounces = NO;
        _topCollectionView.dataSource = self;
        _topCollectionView.delegate = self;
    }
    return _topCollectionView;
}

- (UIColor *)selectColor {
    if (!_selectColor) {
        _selectColor = [UIColor redColor];
    }
    return _selectColor;
}

- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [UIColor grayColor];
    }
    return _normalColor;
}

@end
