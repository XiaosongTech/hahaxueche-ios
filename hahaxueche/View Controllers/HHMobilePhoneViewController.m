//
//  HHMobilePhoneViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHMobilePhoneViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import "HHTextFieldView.h"

@interface HHMobilePhoneViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) HHTextFieldView *numberFieldView;


@end

@implementation HHMobilePhoneViewController

- (instancetype)initWithNumber:(NSString *)number {
    self = [super init];
    if (self) {
        self.number = number;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)initSubviews {
    self.titleLabel = [self createLabelWithTitle:@"请输入您的手机号码" font:[UIFont fontWithName:@"SourceHanSansSC-Bold" size:20.0f] textColor:[UIColor HHOrange]];
    self.subTitleLabel = [self createLabelWithTitle:@"我们绝不会贩卖，滥用你的手机号码" font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:12.0f] textColor:[UIColor lightTextColor]];
    UIBarButtonItem *cancelButton = [UIBarButtonItem buttonItemWithTitle:@"取消" action:@selector(cancel) target:self isLeft:YES];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.numberFieldView = [[HHTextFieldView alloc] initWithPlaceholder:@"手机号码"];
    if (self.number) {
        self.numberFieldView.textField.text = self.number;
        self.numberFieldView.textField.userInteractionEnabled = NO;
    }
    self.numberFieldView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.numberFieldView];
    [self autoLayoutSubviews];
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [self.view addSubview:label];
    return label;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:80.0f],
                             [HHAutoLayoutUtility setCenterX:self.titleLabel multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.subTitleLabel toView:self.titleLabel constant:5.0f],
                             [HHAutoLayoutUtility setCenterX:self.subTitleLabel multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.numberFieldView toView:self.subTitleLabel constant:40.0f],
                             [HHAutoLayoutUtility setCenterX:self.numberFieldView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.numberFieldView multiplier:1.0 constant:-120.0f],
                             [HHAutoLayoutUtility setViewHeight:self.numberFieldView multiplier:0 constant:40.0f],
                             
                            ];
    [self.view addConstraints:constraints];
}

- (void)cancel {
    [self dismissViewControllerAnimated:NO completion:nil];
}




@end
