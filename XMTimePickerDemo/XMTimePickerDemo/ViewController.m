//
//  ViewController.m
//  XMTimePickerDemo
//
//  Created by hxm on 2017/5/2.
//  Copyright © 2017年 Justming. All rights reserved.
//

#import "ViewController.h"
#import "XMTimePicker.h"


#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height


@interface ViewController ()<XMTimePickerDelegate>

@end

@implementation ViewController
{
    
    XMTimePicker * _timePicker;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTimePicker];
    
}

- (void)addTimePicker{
    _timePicker = [[XMTimePicker alloc] initWithFrame:CGRectMake(0, HEIGHT-200, WIDTH, 200) andType:PickerTypeOnlyDate];
    _timePicker.delegate = self;
//    _timePicker.startDate = @"2017-05-15"; //开始日期
//    _timePicker.endDate = @"2017-08-15";   //截止日期
    [_timePicker initTimePicker];
    [self.view addSubview:_timePicker];
}


#pragma mark - XMTimePickerDelegate
- (void)getDate:(NSString *)date andHour:(NSString *)hour andMinute:(NSString *)minute{
    
    
    NSLog(@"%@%@时%@分", date, hour, minute);
    
}

- (void)getYear:(NSString *)year month:(NSString *)month day:(NSString *)day {
    
    NSLog(@"%@%@%@", year, month, day);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!_timePicker.isShow) {
        [self addTimePicker];
    }
}

@end
