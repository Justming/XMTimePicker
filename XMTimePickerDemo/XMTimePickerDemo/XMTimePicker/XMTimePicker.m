//
//  XMTimePicker.m
//  XMTimePickerDemo
//
//  Created by hxm on 2017/5/2.
//  Copyright © 2017年 Justming. All rights reserved.
//

#import "XMTimePicker.h"
#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface XMTimePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@end
@implementation XMTimePicker
{
    UIPickerView * _pickerView;
    
    NSMutableArray * _dateArray;
    NSMutableArray * _hourArray;
    NSMutableArray * _minuteArray;
    
    NSInteger d;
    NSInteger h;
    NSInteger m;

    //年 月 日
    NSString *_year;
    NSString *_month;
    NSString *_day;
    
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    
}

- (instancetype)initWithFrame:(CGRect)frame andType:(PickerType)type{
    
    if (self = [super initWithFrame:frame]) {
        self.pickerType = type;
    }
    return self;
}

/**
 设置属性后进行初始化
 */
- (void)initTimePicker{
    
    [self addControlButton];
    [self initPicker];
    
}

/**
 添加控制按钮
 */
- (void)addControlButton{
    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    [self addSubview:toolBar];
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    cancelItem.tintColor = self.cancelColor;
    UIBarButtonItem * confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    confirmItem.tintColor = self.confirmColor;
    
    UIBarButtonItem * flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray * itemArray = @[cancelItem, flexItem, confirmItem];
    [toolBar setItems:itemArray];
}

/**
 创建选择器
 */
- (void)initPicker{
    
    _dateArray = [NSMutableArray new];
    _hourArray = [NSMutableArray new];
    _minuteArray = [NSMutableArray new];
    _yearArray = [NSMutableArray new];
    _monthArray = [NSMutableArray new];
    _dayArray = [NSMutableArray new];
    [self getDataSource];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.bounds.size.width, self.bounds.size.height-40)];
    _pickerView.backgroundColor = self.backColor;
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];

}

/**
 获取数据源
 */
- (void)getDataSource{
    //年月日
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate * fromDate = [dateFormat dateFromString:self.startDate];
    NSDate * toDate = [dateFormat dateFromString:self.endDate];
    
    if (self.pickerType == PickerTypeOnlyDate) {
        
        NSArray *fromComponents = [self.startDate componentsSeparatedByString:@"-"];
        NSArray *toComponents = [self.endDate componentsSeparatedByString:@"-"];
        int year = [fromComponents[0] intValue];
        for (int i = year; i <= [toComponents[0] intValue]; i++) {
            [_yearArray addObject:[NSString stringWithFormat:@"%d年", i]];
        }
        
        for (int i = 1; i < 13; i++) {
            [_monthArray addObject:[NSString stringWithFormat:@"%d月", i]];
        }
        NSMutableArray *days30 = [NSMutableArray new];
        NSMutableArray *days31 = [NSMutableArray new];
        for (int i = 1; i < 32; i++) {
            
            [days31 addObject:[NSString stringWithFormat:@"%d日", i]];
            if (i == 31) {
                break;
            }
            [days30 addObject:[NSString stringWithFormat:@"%d日", i]];
        }
        
        
        
        if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
            //闰年
            NSMutableArray *days29 = [NSMutableArray new];
            for (int i = 1; i < 30; i++) {
                
                [days29 addObject:[NSString stringWithFormat:@"%d日", i]];
               
            }
            [_dayArray addObjectsFromArray:@[days31, days29, days31, days30, days31, days30, days31, days31, days30, days31, days30, days31]];
            
            
        }else {
            //平年
            NSMutableArray *days28 = [NSMutableArray new];
            for (int i = 1; i < 29; i++) {
                
                [days28 addObject:[NSString stringWithFormat:@"%d日", i]];
                
            }
            [_dayArray addObjectsFromArray:@[days31, days28, days31, days30, days31, days30, days31, days31, days30, days31, days30, days31]];
            
            
        }
        
        
    }else if (self.pickerType == PickerTypeDateAndTime) {
    
        for (; fromDate != toDate; fromDate = [NSDate dateWithTimeInterval:86400 sinceDate:fromDate]) {
            
            NSString * dateStr = [self formDate:fromDate];
            [_dateArray addObject:dateStr];
        }
        
        //时
        for (int i=0; i<24; i++) {
            NSString * hour = [NSString stringWithFormat:@"%02d", i];
            [_hourArray addObject:hour];
        }
        
        //分
        for (int j=0; j<60; j++) {
            NSString * minute = [NSString stringWithFormat:@"%02d", j];
            [_minuteArray addObject:minute];
        }
    }
}


/**
 格式化日期为字符串

 @param date 需要被格式化的日期 NSDate
 @return 格式化后的日期 yyyy年MM月dd日
 */
- (NSString *)formDate:(NSDate *)date{
    
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy年MM月dd日"];
    
    NSString * dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}


#pragma mark - 确定/取消
- (void)cancel{
    
    [self removeFromSuperview];
    
}
- (void)confirm{
    
    if (self.pickerType == PickerTypeDateAndTime) {
        
        [self.delegate getDate:_dateArray[d] andHour:_hourArray[h] andMinute:_minuteArray[m]];
    }else if (self.pickerType == PickerTypeOnlyDate) {
        
        [self.delegate getYear:_yearArray[d] month:_monthArray[h] day:_dayArray[h][m]];
    }
    
    [self cancel];
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.pickerType == PickerTypeOnlyDate) {
        return 3;
    }
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (_pickerType == PickerTypeOnlyDate) {
        if (component == 0) {
            return _yearArray.count;
        }else if (component == 1) {
            return _monthArray.count;
        }else if (component == 2) {
            NSInteger selectedMonth = [pickerView selectedRowInComponent:1];
            return [_dayArray[selectedMonth] count];
        }
        
    }else if (_pickerType == PickerTypeDateAndTime) {
        if (component == 0) {
            return _dateArray.count;
        }
        if (component == 1) {
            return _hourArray.count;
        }
        if (component == 2) {
            return 1;
        }
        if (component == 3) {
            return _minuteArray.count;
        }

    }
    
    return 0;
}


#pragma mark -  UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (_pickerType == PickerTypeOnlyDate) {
        return WIDTH / 3.0;
    }else if (_pickerType == PickerTypeDateAndTime) {
        if (component == 0) {
            return WIDTH / 2.0;
        }
        if (component == 1 || component == 3) {
            return (WIDTH / 2 - 10) / 2;
        }
        if (component == 2) {
            return 10;
        }
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel * label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.titleColor;
    label.font = [UIFont systemFontOfSize:self.fontSize];
    
    if (_pickerType == PickerTypeOnlyDate) {
        if (component == 0) {
            label.frame = CGRectMake(0, 0, WIDTH / 3.0, 40);
            label.text = _yearArray[row];
        }
        if (component == 1) {
            label.frame = CGRectMake(WIDTH / 3.0, 0, WIDTH / 3.0, 40);
            label.text = _monthArray[row];
        }
        if (component == 2) {
            label.frame = CGRectMake(WIDTH * 2 / 3, 0, WIDTH / 3.0, 40);
            NSInteger selectedMonth = [pickerView selectedRowInComponent:1];
            
            label.text = _dayArray[selectedMonth][row];
        }
    }else if (_pickerType == PickerTypeDateAndTime) {
        if (component == 0) {
            label.frame = CGRectMake(0, 0, WIDTH / 2.0, 40);
            label.text = _dateArray[row];
        }
        if (component == 1) {
            label.frame = CGRectMake(0, 0, (WIDTH / 2 - 10) / 2, 40);
            label.text = _hourArray[row];
        }
        if (component == 2) {
            label.frame = CGRectMake(0, 0, 10, 40);
            label.text = @":";
        }
        if (component == 3) {
            label.frame = CGRectMake(0, 0, (WIDTH / 2 - 10) / 2, 40);
            label.text = _minuteArray[row];
        }
    }
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (_pickerType == PickerTypeOnlyDate) {
        if (component == 0) {
            d = row;
        }
        if (component == 1) {
            h = row;
            [pickerView reloadComponent:2];
        }
        if (component == 2) {
            m = row;
        }
    }else if (_pickerType == PickerTypeDateAndTime) {
        
        if (component == 0) {
            d = row;
        }
        if (component == 1) {
            h = row;
        }
        if (component == 3) {
            m = row;
        }
    }
    
    
}
#pragma mark - getter
- (UIColor *)backColor {
    if (!_backColor) {
        return [UIColor whiteColor];
    }
    return _backColor;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        return [UIColor blackColor];
    }
    return _titleColor;
}
- (CGFloat)fontSize {
    if (!_fontSize || _fontSize == 0) {
        return 18;
    }
    return _fontSize;
}
- (UIColor *)cancelColor {
    if (!_cancelColor) {
        return [UIColor grayColor];
    }
    return _cancelColor;
}
- (UIColor *)confirmColor {
    if (!_confirmColor) {
        return [UIColor redColor];
    }
    return _confirmColor;
}
- (NSString *)startDate{
    if (!_startDate) {
        NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        return [dateFormat stringFromDate:[NSDate date]];
    }
    return _startDate;
}
- (NSString *)endDate{
    if (!_endDate) {
        NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        if (!_startDate) {
            return [dateFormat stringFromDate:[NSDate dateWithTimeInterval:86400*30 sinceDate:[NSDate date]]];
        }
        NSDate * fromDate = [dateFormat dateFromString:_startDate];
        return [dateFormat stringFromDate:[NSDate dateWithTimeInterval:86400*30 sinceDate:fromDate]];
        
    }
    return _endDate;
}

- (BOOL)isShow{
    if (self.superview) {
        return YES;
    }
    return NO;
}

@end
