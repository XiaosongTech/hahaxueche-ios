//
//  HHCoachAddTimeViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachAddTimeViewController.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHAutoLayoutUtility.h"
#import "HHScheduleCellView.h"
#import "HHCoachSchedule.h"
#import "HHUserAuthenticator.h"
#import "HHToastUtility.h"
#import "HHLoadingView.h"
#import "HHFormatUtility.h"
#import <NSDate+DateTools.h>

#define kCellId  @"AddTimeCellId"

@interface HHCoachAddTimeViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) HHScheduleCellView *dateView;
@property (nonatomic, strong) HHScheduleCellView *startTimeView;
@property (nonatomic, strong) HHScheduleCellView *endTimeView;
@property (nonatomic, strong) HHScheduleCellView *courseView;
@property (nonatomic, strong) HHCoachSchedule *schedule;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *course;

@end

@implementation HHCoachAddTimeViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.schedule = [HHCoachSchedule object];
    
    UIBarButtonItem *backButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"left_arrow"] action:@selector(backButtonPressed) target:self];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8.0f;//
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    
    UIBarButtonItem *bookBarButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"下一步", nil) action:@selector(confirmTime) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = bookBarButton;
    
    [self createScheduleView];
    [self autoLayoutSubviews];
}

- (void)createScheduleView {
    self.dateView = [self createCellWithImage:[UIImage imageNamed:@"addtime_calendar"] title:NSLocalizedString(@"添加日期", nil) subTitle:NSLocalizedString(@"选择日期", nil) showLine:YES];
    
    
    self.startTimeView = [self createCellWithImage:[UIImage imageNamed:@"addtime_starttime"] title:NSLocalizedString(@"开始时间", nil) subTitle:NSLocalizedString(@"选择时间", nil) showLine:YES];
    
    self.endTimeView = [self createCellWithImage:[UIImage imageNamed:@"addtime_endtime"] title:NSLocalizedString(@"结束时间", nil) subTitle:NSLocalizedString(@"选择时间", nil) showLine:YES];
    
    self.courseView = [self createCellWithImage:[UIImage imageNamed:@"addtime_class"] title:NSLocalizedString(@"训练科目", nil) subTitle:NSLocalizedString(@"选择科目", nil) showLine:NO];
}

- (HHScheduleCellView *)createCellWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTilte showLine:(BOOL)showLine {
    HHScheduleCellView *view = [[HHScheduleCellView alloc] initWithFrame:CGRectZero];
    view.userInteractionEnabled = YES;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];
    [view setupViewsWithImage:image title:title subTitle:subTilte showLine:showLine];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.dateView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.dateView constant:10.0f],
                             [HHAutoLayoutUtility setViewWidth:self.dateView multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.dateView multiplier:0 constant:50.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.startTimeView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.startTimeView toView:self.dateView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.startTimeView multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.startTimeView multiplier:0 constant:50.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.endTimeView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.endTimeView toView:self.startTimeView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.endTimeView multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.endTimeView multiplier:0 constant:50.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.courseView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.courseView toView:self.endTimeView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.courseView multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.courseView multiplier:0 constant:50.0f],
                             
                             ];
    [self.view addConstraints:constraints];
}

-(void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmTime {
//    if (!self.date || !self.startTime || !self.endTime || !self.course) {
//        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请务必填写所有4项信息", nil) isError:YES];
//        return;
//    }
//    
//    if ([self.endTime hoursFrom:self.startTime] < 1.0f) {
//        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"开始时间必须小于结束时间，并且训练时候不得小于1小时！", nil) isError:YES];
//        return;
//    }
//    self.schedule.coachId = [HHUserAuthenticator sharedInstance].currentCoach.coachId;
//    self.schedule.startDateTime = [self combineDate:self.date withTime:self.startTime];
//    self.schedule.endDateTime = [self combineDate:self.date withTime:self.endTime];
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer {
    UIView *view = tapRecognizer.view;
    if ([view isEqual:self.dateView]) {
        if (self.datePicker) {
            [self.datePicker removeFromSuperview];
            self.datePicker = nil;
        }
        self.datePicker = [self createDatePickerWithAction:@selector(dateChanged) isDateMode:YES];
        self.datePicker.minimumDate = [NSDate date];
        
        
    } else if ([view isEqual:self.startTimeView]) {
        if (self.datePicker) {
            [self.datePicker removeFromSuperview];
            self.datePicker = nil;
        }
        self.datePicker = [self createDatePickerWithAction:@selector(startTimeChanged) isDateMode:NO];
        
    } else if ([view isEqual:self.endTimeView]) {
        if (self.datePicker) {
            [self.datePicker removeFromSuperview];
            self.datePicker = nil;
        }
        self.datePicker = [self createDatePickerWithAction:@selector(endTimeChanged) isDateMode:NO];
        
    } else if ([view isEqual:self.courseView]) {
        
    }
    
}

- (UIDatePicker *)createDatePickerWithAction:(SEL)action isDateMode:(BOOL)isDateMode {
    
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    picker.translatesAutoresizingMaskIntoConstraints = NO;
    if (isDateMode) {
        picker.datePickerMode = UIDatePickerModeDate;
    } else {
        picker.datePickerMode = UIDatePickerModeTime;
    }
    
    [picker addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    picker.locale = locale;
    [self.view addSubview:picker];
    
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:picker multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:picker constant:0],
                             [HHAutoLayoutUtility setViewHeight:picker multiplier:0 constant:200.0f],
                             
                             ];
    [self.view addConstraints:constraints];
    return picker;

}

- (void)dateChanged {
    self.date = self.datePicker.date;
    self.dateView.subTitleLabel.text = [[HHFormatUtility dateFormatter] stringFromDate:self.date];
}

- (void)startTimeChanged {
    self.startTime = self.datePicker.date;
    self.startTimeView.subTitleLabel.text = [[HHFormatUtility timeFormatter] stringFromDate:self.startTime];
}

- (void)endTimeChanged {
    self.endTime = self.datePicker.date;
    self.endTimeView.subTitleLabel.text = [[HHFormatUtility timeFormatter] stringFromDate:self.endTime];
}

- (NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:
                             NSGregorianCalendar];
    
    unsigned unitFlagsDate = NSYearCalendarUnit | NSMonthCalendarUnit
    |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [gregorian components:unitFlagsDate
                                                    fromDate:date];
    unsigned unitFlagsTime = NSHourCalendarUnit | NSMinuteCalendarUnit
    |  NSSecondCalendarUnit;
    NSDateComponents *timeComponents = [gregorian components:unitFlagsTime
                                                    fromDate:time];
    
    [dateComponents setSecond:[timeComponents second]];
    [dateComponents setHour:[timeComponents hour]];
    [dateComponents setMinute:[timeComponents minute]];
    
    NSDate *combDate = [gregorian dateFromComponents:dateComponents];   
    
    return combDate;
}


@end
