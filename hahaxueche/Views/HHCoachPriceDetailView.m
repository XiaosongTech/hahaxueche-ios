//
//  HHCoachPriceDetailView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/24/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachPriceDetailView.h"
#import "HHPriceItemView.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"

static NSString *const explanationText = @"备注：以下费用根据个人实际需求另外缴纳\n\n补考费（车管所）---- 按车管所公示价格收取\n模拟考试费（考场）---- 按考场公示价格收取";

@interface HHCoachPriceDetailView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHPriceItemView *item1;
@property (nonatomic, strong) HHPriceItemView *item2;
@property (nonatomic, strong) HHPriceItemView *item3;
@property (nonatomic, strong) HHPriceItemView *item4;
@property (nonatomic, strong) HHPriceItemView *item5;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *explanationLabel;



@end

@implementation HHCoachPriceDetailView

- (instancetype)initWithPrice:(NSNumber *)price {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        self.titleLabel = [self createLabelWithText:NSLocalizedString(@"费用明细", nil) font:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.0f] textColor:[UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1]];
        [self addSubview:self.titleLabel];
        
        self.item1 = [[HHPriceItemView alloc] initWithKeyText:NSLocalizedString(@"资料管理费（代办机构）", nil) valueText:NSLocalizedString(@"350元", nil)];
        self.item1.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.item1];
        
        self.item2 = [[HHPriceItemView alloc] initWithKeyText:NSLocalizedString(@"考试费（车管所）", nil) valueText:NSLocalizedString(@"500元", nil)];
        self.item2.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.item2];
        
        self.item3 = [[HHPriceItemView alloc] initWithKeyText:NSLocalizedString(@"考试费（您的教练）", nil) valueText:[NSString stringWithFormat:NSLocalizedString(@"%d元", nil), [price integerValue] - 850]];
        self.item3.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.item3];
        
        self.item4 = [[HHPriceItemView alloc] initWithKeyText:NSLocalizedString(@"居住证", nil) valueText:NSLocalizedString(@"免费赠送", nil)];
        self.item4.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.item4];
        
        self.item5 = [[HHPriceItemView alloc] initWithKeyText:NSLocalizedString(@"体检费", nil) valueText:NSLocalizedString(@"免费赠送", nil)];
        self.item5.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.item5];
        
        self.line = [[UIView alloc] initWithFrame:CGRectZero];
        self.line.translatesAutoresizingMaskIntoConstraints = NO;
        self.line.backgroundColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1];
        [self addSubview:self.line];
        
        self.totalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.totalLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"合计：", nil) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f], NSForegroundColorAttributeName : [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1]}];
        
        NSMutableAttributedString *numberString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"%@元", nil), [price stringValue]] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f], NSForegroundColorAttributeName : [UIColor HHOrange]}];
        
        [totalString appendAttributedString:numberString];
        self.totalLabel.attributedText = totalString;
        [self.totalLabel sizeToFit];
        [self addSubview:self.totalLabel];
        
        
        self.explanationLabel = [self createLabelWithText:explanationText font:[UIFont fontWithName:@"STHeitiSC-Light" size:12.0f] textColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        [self addSubview:self.explanationLabel];
        
        [self autolayoutSubviews];
    }
    return self;
}

- (void)autolayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:15.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.titleLabel constant:15.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.item1 toView:self.titleLabel constant:5.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.item1 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.item1 multiplier:1.0f constant:-30.0f],
                             [HHAutoLayoutUtility setViewHeight:self.item1 multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.item2 toView:self.item1 constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.item2 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.item2 multiplier:1.0f constant:-30.0f],
                             [HHAutoLayoutUtility setViewHeight:self.item2 multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.item3 toView:self.item2 constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.item3 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.item3 multiplier:1.0f constant:-30.0f],
                             [HHAutoLayoutUtility setViewHeight:self.item3 multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.item4 toView:self.item3 constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.item4 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.item4 multiplier:1.0f constant:-30.0f],
                             [HHAutoLayoutUtility setViewHeight:self.item4 multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.item5 toView:self.item4 constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.item5 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.item5 multiplier:1.0f constant:-30.0f],
                             [HHAutoLayoutUtility setViewHeight:self.item5 multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.line toView:self.item5 constant:10],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.line constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:-30.0f],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:1.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.totalLabel toView:self.line constant:15.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.totalLabel constant:-15.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.explanationLabel toView:self.totalLabel constant:20.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.explanationLabel constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.explanationLabel multiplier:1.0f constant:-30.0f],

                             ];
    [self addConstraints:constraints];
}

- (UILabel *)createLabelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    return label;
}

@end
