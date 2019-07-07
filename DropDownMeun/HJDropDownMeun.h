//
//  HJFilterTopMeunView.h
//  Test
//
//  Created by GiaJiang on 2019/6/14.
//  Copyright © 2019 PPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HJFilterTopButtonItem, HJDropDownMeun;

@interface HJIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;


@end

@protocol HJDropDownMeunDataSource <NSObject>

@required
- (NSString *)dropDownMeun:(HJDropDownMeun *)meun titleForColumn:(NSInteger)column;
- (NSString *)dropDownMeun:(HJDropDownMeun *)meun titleForRowAtIndexPath:(HJIndexPath *)indexPath;

- (NSInteger)numberOfColumnsInDropDownMeun:(HJDropDownMeun *)meun;
- (NSInteger)dropDownMeun:(HJDropDownMeun *)meun numberRowInSectionAtIndexPath:(HJIndexPath *)indexPath;


@optional

- (NSString *)dropDownMeun:(HJDropDownMeun *)meun titleForSectionAtIndexPath:(HJIndexPath *)indexPath;
- (UIFont *)dropDownMeun:(HJDropDownMeun *)meun fontForColumn:(NSInteger)column;
- (UIFont *)dropDownMeun:(HJDropDownMeun *)meun fontForSection:(NSInteger)section;
- (UIFont *)dropDownMeun:(HJDropDownMeun *)meun fontForRow:(NSInteger)row;
- (NSInteger)dropDownMeun:(HJDropDownMeun *)meun numberSectionInColumn:(NSInteger )column;


@end

@protocol HJDropDownMeunDelegate <NSObject>

@optional
- (void)dropDownMeun:(HJDropDownMeun *)meun didSelectRowAtIndexPath:(HJIndexPath *)indexPath;
- (CGFloat)dropDownMeun:(HJDropDownMeun *)meun widthForColumn:(NSInteger)column;
- (CGFloat)heigtForSectionInDropDownMeun:(HJDropDownMeun *)meun;
- (CGFloat)heigtForRowInDropDownMeun:(HJDropDownMeun *)meun;

@end

@interface HJDropDownMeun : UIView

@property (nonatomic, weak) id <HJDropDownMeunDataSource> dataSource;
@property (nonatomic, weak) id <HJDropDownMeunDelegate> delegate;

@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *normalColor;

@end

