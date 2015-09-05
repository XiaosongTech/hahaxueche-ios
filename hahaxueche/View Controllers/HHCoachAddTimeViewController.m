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
#import "ActionSheetPicker.h"

#define kCellId  @"AddTimeCellId"

@interface HHCoachAddTimeViewController ()

@property (nonatomic, strong) HHScheduleCellView *dateView;
@property (nonatomic, strong) HHScheduleCellView *startTimeView;
@property (nonatomic, strong) HHScheduleCellView *endTimeView;
@property (nonatomic, strong) HHScheduleCellView *courseView;
@property (nonatomic, strong) HHCoachSchedule *schedule;
@property (nonatomic, strong) ActionSheetDatePicker *datePicker;
@property (nonatomic, strong) ActionSheetStringPicker *coursePicker;
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
    if (!self.date || !self.startTime || !self.endTime || !self.course) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请务必填写所有4项信息", nil) isError:YES];
        return;
    }
    
    if ([self.endTime hoursFrom:self.startTime] < 1.0f) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"开始时间必须小于结束时间，训练时候不得小于1小时！", nil) timeInterval:@(5) isError:YES];
        return;
    }

}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer {
    __weak HHCoachAddTimeViewController *weakSelf = self;
    NSDate *prefillDate;
    UIView *view = tapRecognizer.view;
    if ([view isEqual:self.dateView]) {
        if (self.date) {
            prefillDate = self.date;
        } else {
            prefillDate = [NSDate date];
        }
      [self showDatePickerWithDoneButtonAction:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        weakSelf.dateView.subTitleLabel.textColor = [UIColor blackColor];
          weakSelf.dateView.subTitleLabel.text = [[HHFormatUtility dateFormatter] stringFromDate:selectedDate];
          weakSelf.date = selectedDate;
      }
                                   prefillDate:prefillDate
                                        origin:self.dateView
                                          mode:UIDatePickerModeDate];
        
    } else if ([view isEqual:self.startTimeView]) {
        if (self.startTime) {
            prefillDate = self.startTime;
        } else {
            prefillDate = [NSDate date];
        }
        [self showDatePickerWithDoneButtonAction:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            weakSelf.startTimeView.subTitleLabel.textColor = [UIColor blackColor];
            weakSelf.startTimeView.subTitleLabel.text = [[HHFormatUtility timeFormatter] stringFromDate:selectedDate];
            weakSelf.startTime = selectedDate;
        }
                                     prefillDate:prefillDate
                                          origin:self.startTimeView
                                            mode:UIDatePickerModeTime];
        
    } else if ([view isEqual:self.endTimeView]) {
        if (self.endTime) {
            prefillDate = self.endTime;
        } else {
            prefillDate = [NSDate date];
        }
        [self showDatePickerWithDoneButtonAction:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            weakSelf.endTimeView.subTitleLabel.textColor = [UIColor blackColor];
            weakSelf.endTimeView.subTitleLabel.text = [[HHFormatUtility timeFormatter] stringFromDate:selectedDate];
            weakSelf.endTime = selectedDate;
        }
                                     prefillDate:prefillDate
                                          origin:self.endTimeView
                                            mode:UIDatePickerModeTime];

        
    } else if ([view isEqual:self.courseView]) {
        NSInteger prefillIndex = 0;
        if ([self.course isEqualToString:NSLocalizedString(@"科目二", nil)] || !self.course) {
            prefillIndex = 0;
        } else {
            prefillIndex = 1;
        }
        [self showCoursePickerWithDoneButtonAction:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            weakSelf.courseView.subTitleLabel.textColor = [UIColor blackColor];
            weakSelf.courseView.subTitleLabel.text = selectedValue;
            weakSelf.course = selectedValue;

        }
                                           options:@[NSLocalizedString(@"科目二", nil), NSLocalizedString(@"科目三", nil)]
                                            origin:self.courseView
                             initialSelectionIndex:prefillIndex];
    }
    
}

- (void)showDatePickerWithDoneButtonAction:(ActionDateDoneBlock)action prefillDate:(NSDate *)prefillDate origin:(UIView *)origin mode:(UIDatePickerMode)mode {
    self.datePicker = [[ActionSheetDatePicker alloc] initWithTitle:NSLocalizedString(@"选择时间", nil)
                                                    datePickerMode:mode
                                                      selectedDate:prefillDate
                                                         doneBlock:action
                                                       cancelBlock:nil
                                                            origin:origin];
    self.datePicker.tapDismissAction = TapActionCancel;
    self.datePicker.minimumDate = [NSDate date];
    
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"取消", nil)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor HHGrayTextColor] range:NSMakeRange(0, 2)];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    [cancelButton sizeToFit];
    [self.datePicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *attrDoneString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"确认", nil)];
    [attrDoneString addAttribute:NSForegroundColorAttributeName value:[UIColor HHOrange] range:NSMakeRange(0, 2)];
    [doneButton setAttributedTitle:attrDoneString forState:UIControlStateNormal];
    [doneButton sizeToFit];
    [self.datePicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [self.datePicker showActionSheetPicker];
}

- (void)showCoursePickerWithDoneButtonAction:(ActionStringDoneBlock)action options:(NSArray *)options origin:(UIView *)origin initialSelectionIndex:(NSInteger)initialSelectionIndex {
    self.coursePicker = [[ActionSheetStringPicker alloc] initWithTitle:NSLocalizedString(@"选择科目", nil)
                                                                  rows:options
                                                      initialSelection:initialSelectionIndex
                                                             doneBlock:action
                                                           cancelBlock:nil
                                                                origin:origin];
    self.coursePicker.tapDismissAction = TapActionCancel;
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"取消", nil)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor HHGrayTextColor] range:NSMakeRange(0, 2)];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    [cancelButton sizeToFit];
    [self.coursePicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *attrDoneString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"确认", nil)];
    [attrDoneString addAttribute:NSForegroundColorAttributeName value:[UIColor HHOrange] range:NSMakeRange(0, 2)];
    [doneButton setAttributedTitle:attrDoneString forState:UIControlStateNormal];
    [doneButton sizeToFit];
    [self.coursePicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [self.coursePicker showActionSheetPicker];
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
