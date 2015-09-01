//
//  HHCoachDashBoardTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachDashBoardTableViewCell.h"
#import "HHAutoLayoutUtility.h"
#import "HHFormatUtility.h"
#import "UIColor+HHColor.h"

@implementation HHCoachDashBoardTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.layer.cornerRadius = 5.0f;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.containerView];
    
    self.priceView = [self createDashViewValueTextColor:[UIColor blackColor] rightLine:YES];
    self.courseView = [self createDashViewValueTextColor:[UIColor blackColor] rightLine:YES];
    self.yearView = [self createDashViewValueTextColor:[UIColor blackColor] rightLine:NO];
    self.passedStudentAmountView = [self createDashViewValueTextColor:[UIColor blackColor] rightLine:YES];
    self.currentStudentAmountView =[self createDashViewValueTextColor:[UIColor blackColor] rightLine:NO];
    self.phoneNumberView =[self createDashViewValueTextColor:[UIColor HHClickableBlue] rightLine:NO];
    
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumberPressed)];
    [self.phoneNumberView addGestureRecognizer:phoneTap];
    
    self.addressView =[self createDashViewValueTextColor:[UIColor HHClickableBlue] rightLine:NO];
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressPressed)];
    [self.addressView addGestureRecognizer:addressTap];
    
    self.firstHorizontalLine = [self createHorizontalLine];
    self.secondHorizontalLine = [self createHorizontalLine];
    self.thirdHorizontalLine = [self createHorizontalLine];
    
    [self autoLayoutSubviews];
}

- (void)phoneNumberPressed {
    if (self.phoneTappedCompletion) {
        self.phoneTappedCompletion(self.phoneNumberView.valueLabel.text);
    }
}

- (void)addressPressed {
    if (self.addressTappedCompletion) {
        self.addressTappedCompletion(self.addressView.valueLabel.text);
    }
}

- (HHDashView *)createDashViewValueTextColor:(UIColor *)valueTextColor rightLine:(BOOL)rightLine {
    HHDashView *dashView = [[HHDashView alloc] initWithValueTextColor:valueTextColor rightLine:rightLine];
    dashView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:dashView];
    return dashView;
}

- (UIView *)createHorizontalLine {
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor HHGrayLineColor];
    [self.containerView addSubview:line];
    return line;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.containerView constant:8.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.containerView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.containerView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.containerView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.priceView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.priceView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.priceView multiplier:0.25f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.priceView multiplier:0.33f constant:0],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.courseView constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.courseView toView:self.priceView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.courseView multiplier:0.25f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.courseView multiplier:0.33f constant:0],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.yearView constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.yearView toView:self.courseView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.yearView multiplier:0.25f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.yearView multiplier:0.33f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.passedStudentAmountView toView:self.priceView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.passedStudentAmountView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.passedStudentAmountView multiplier:0.25f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.passedStudentAmountView multiplier:0.5f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.currentStudentAmountView toView:self.priceView constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.currentStudentAmountView toView:self.passedStudentAmountView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.currentStudentAmountView multiplier:0.25f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.currentStudentAmountView multiplier:0.5f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.phoneNumberView toView:self.passedStudentAmountView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.phoneNumberView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.phoneNumberView multiplier:0.25f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.phoneNumberView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.addressView toView:self.phoneNumberView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.addressView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.addressView multiplier:0.25f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.addressView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.firstHorizontalLine toView:self.priceView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.firstHorizontalLine constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.firstHorizontalLine multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.firstHorizontalLine multiplier:1.0f constant:-20.0f],

                             
                             [HHAutoLayoutUtility verticalNext:self.secondHorizontalLine toView:self.passedStudentAmountView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.secondHorizontalLine constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.secondHorizontalLine multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.secondHorizontalLine multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.thirdHorizontalLine toView:self.phoneNumberView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.thirdHorizontalLine constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.thirdHorizontalLine multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.thirdHorizontalLine multiplier:1.0f constant:-20.0f],

                             ];
     [self.contentView addConstraints:constraints];

}

- (void)setupViewsWithCoach:(HHCoach *)coach trainingFielf:(HHTrainingField *)field {
    [self.priceView setupViewWithKey:NSLocalizedString(@"包干价格", nil) value:[[HHFormatUtility moneyFormatter] stringFromNumber:coach.actualPrice]];
    [self.courseView setupViewWithKey:NSLocalizedString(@"服务项目", nil) value:coach.course];
    
    [self.yearView setupViewWithKey:NSLocalizedString(@"教龄", nil) value:[NSString stringWithFormat:NSLocalizedString(@"%@年", nil), coach.experienceYear]];
    
    [self.passedStudentAmountView setupViewWithKey:NSLocalizedString(@"通过学员数", nil) value:[coach.passedStudentAmount stringValue]];
    
    [self.currentStudentAmountView setupViewWithKey:NSLocalizedString(@"当前学员数", nil) value:[coach.currentStudentAmount stringValue]];
    
    [self.phoneNumberView setupViewWithKey:NSLocalizedString(@"手机号", nil) value:coach.phoneNumber];
    
    NSString *fullAddress = [NSString stringWithFormat:@"%@%@%@%@", field.province, field.city, field.district, field.address];
    [self.addressView setupViewWithKey:NSLocalizedString(@"训练场地址", nil) value:fullAddress];
}


@end
