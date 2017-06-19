//
//  XMTimePicker.h
//  XMTimePickerDemo
//
//  Created by hxm on 2017/5/2.
//  Copyright © 2017年 Justming. All rights reserved.
//


/*
 
 使用介绍：
 1.导入头文件
 #import "XMTimePicker.h"
 
 2.创建对象并指定类型  (1)PickerTypeOnlyDate  年月日   (2)PickerTypeDateAndTime 年 月 日 时 分 秒
 XMTimePicker * picker; = [[XMTimePicker alloc] initWithFrame:CGRectMake(0, HEIGHT-200, WIDTH, 200) andType:PickerTypeOnlyDate];
 
 3.设置参数
 开始日期，截止日期，背景颜色、字体颜色、字体大小、取消和确定按钮颜色

 4.应用参数设置
 [_picker initTimePicker];
 
 5.设置代理
 picker.delegate = self;

 
 6.实现代理方法
 - (void)getDate:(NSString *)date andHour:(NSString *)hour andMinute:(NSString *)minute;
 
 
 GitHub地址：https://github.com/Justming/XMTimePicker.git
 
 
 */



#import <UIKit/UIKit.h>

@protocol XMTimePickerDelegate <NSObject>

@optional
/**
 获取时间

 @param date 日期  yyyy年MM月dd日
 @param hour 时 hh
 @param minute 分 mm
 */
- (void)getDate:(NSString *)date andHour:(NSString *)hour andMinute:(NSString *)minute;

/**
 获取年月日

 @param year 年
 @param month 月
 @param day 日
 */
- (void)getYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

@end

@interface XMTimePicker : UIView


typedef NS_ENUM(NSUInteger, PickerType) {
    PickerTypeOnlyDate,     //年 月 日
    PickerTypeDateAndTime,  //年 月 日 时 分 秒
};

@property (nonatomic, assign) PickerType pickerType;

/**
 是否添加到父视图上
 */
@property (nonatomic, assign, readonly) BOOL isShow;

/**
 背景颜色，默认 whiteColor
 */
@property (nonatomic, strong) UIColor * backColor;

/**
 字体颜色，默认 blackColor
 */
@property (nonatomic, strong) UIColor * titleColor;

/**
 字体大小，默认 18
 */
@property (nonatomic, assign) CGFloat  fontSize;

/**
 取消按钮颜色，默认 grayColor
 */
@property (nonatomic, strong) UIColor * cancelColor;

/**
 确定按钮颜色，默认 redColor
 */
@property (nonatomic, strong) UIColor * confirmColor;

/**
 开始日期 yyyy-MM-dd  默认为今天(包括)
 */
@property (nonatomic, copy) NSString * startDate;

/**
 截止日期 yyyy-MM-dd  默认为startDate后的30天(不包括)
 */
@property (nonatomic, copy) NSString * endDate;


/**
 代理
 */
@property (nonatomic, weak) id<XMTimePickerDelegate> delegate;


/**
 设置属性后初始化时间选择器
 */
- (void)initTimePicker;


- (instancetype)initWithFrame:(CGRect)frame andType:(PickerType)type;

@end
