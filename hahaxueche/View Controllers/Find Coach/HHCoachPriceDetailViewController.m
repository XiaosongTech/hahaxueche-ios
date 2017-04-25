//
//  HHCoachPriceDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 24/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachPriceDetailViewController.h"
#import "HHCoach.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHConstantsStore.h"
#import "HHCityFixedFee.h"
#import "NSNumber+HHNumber.h"
#import <TTTAttributedLabel.h>
#import "HHSupportUtility.h"
#import "HHCityOtherFee.h"
#import "HHOtherFeeItemView.h"
#import "HHPurchaseConfirmViewController.h"
#import "HHStudentStore.h"
#import "HHGradientButton.h"
#import "HHPrepayViewController.h"
#import "HHIntroViewController.h"
#import "HHEventTrackingManager.h"


@interface HHCoachPriceDetailViewController () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) HHCoach *coach;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TTTAttributedLabel *supportLabel;
@property (nonatomic) CoachProductType type;

@property (nonatomic, strong) UILabel *serviceTitleLabel;
@property (nonatomic, strong) UILabel *priceTitleLabel;
@property (nonatomic, strong) UILabel *otherFeeTitleLabel;

@property (nonatomic, strong) UIView *lastView;

@property (nonatomic, strong) HHGradientButton *purchaseButton;
@property (nonatomic, strong) HHGradientButton *depositButton;


@end


@implementation HHCoachPriceDetailViewController

- (instancetype)initWithCoach:(HHCoach *)coach productType:(CoachProductType)type {
    self = [super init];
    if (self) {
        self.coach = coach;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班别介绍";
    self.view.backgroundColor = [UIColor HHOrange];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        if (![[HHStudentStore sharedInstance].currentStudent isPurchased]) {
            make.height.equalTo(self.view.height).offset(-50.0f);
        } else {
            make.height.equalTo(self.view.height);
        }
    }];
    
    if (![[HHStudentStore sharedInstance].currentStudent isPurchased]) {

        self.depositButton = [[HHGradientButton alloc] initWithType:1];
        [self.depositButton setTitle:@"预付100得300" forState:UIControlStateNormal];
        [self.depositButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.depositButton.backgroundColor = [UIColor HHDarkOrange];
        self.depositButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.depositButton addTarget:self action:@selector(depositButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.depositButton];
        [self.depositButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left);
            make.top.equalTo(self.scrollView.bottom);
            make.width.equalTo(self.view.width).multipliedBy(0.5f);
            make.height.mas_equalTo(50.0f);
        }];
        
        self.purchaseButton = [[HHGradientButton alloc] initWithType:0];
        [self.purchaseButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [self.purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.purchaseButton.backgroundColor = [UIColor HHDarkOrange];
        self.purchaseButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.purchaseButton addTarget:self action:@selector(purchaseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.purchaseButton];
        [self.purchaseButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.depositButton.right);
            make.top.equalTo(self.scrollView.bottom);
            make.width.equalTo(self.view.width).multipliedBy(0.5f);
            make.height.mas_equalTo(50.0f);
        }];
    }
    
    self.serviceTitleLabel = [[UILabel alloc] init];
    self.serviceTitleLabel.attributedText = [self generateAttrStringWithText:@"服务内容" image:[UIImage imageNamed:@"pricedetails_ic_service"]];
    [self.scrollView addSubview:self.serviceTitleLabel];
    [self.serviceTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.scrollView.top).offset(20.0f);
    }];
    
    [self buildServiceDetailView];
    
    
    self.priceTitleLabel = [[UILabel alloc] init];
    self.priceTitleLabel.attributedText = [self generateAttrStringWithText:@"费用明细" image:[UIImage imageNamed:@"pricedetails_ic_price"]];
    [self.scrollView addSubview:self.priceTitleLabel];
    [self.priceTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.lastView.bottom).offset(20.0f);
    }];
    self.lastView = self.priceTitleLabel;
    
    [self buildPriceDetailView];
    
    
    self.otherFeeTitleLabel = [[UILabel alloc] init];
    self.otherFeeTitleLabel.attributedText = [self generateAttrStringWithText:@"额外可能产生的费用" image:[UIImage imageNamed:@"pricedetails_ic_attention"]];
    [self.scrollView addSubview:self.otherFeeTitleLabel];
    [self.otherFeeTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.lastView.bottom).offset(20.0f);
    }];
    self.lastView = self.otherFeeTitleLabel;
    
    [self buildOtherFeesView];
    
    self.supportLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.supportLabel.attributedText = [self buildAttributeString];
    self.supportLabel.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.supportLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.supportLabel.delegate = self;
    self.supportLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.supportLabel];
    [self.supportLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lastView.bottom).offset(30.0f);
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.width.equalTo(self.scrollView.width).offset(-30.0f);
    }];
    self.lastView = self.supportLabel;
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.lastView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-20.0f]];

}

- (void)buildPriceDetailView {
    NSNumber *trainingFee = [self.coach getPriceProductType:self.type];
    HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
    for (HHCityFixedFee *fixedFee in city.cityFixedFees) {
        
        UIView *view = [self buildPriceItemViewWithTitle:fixedFee.feeName valueString:[fixedFee.feeAmount generateMoneyString] type:0];
        trainingFee = @([trainingFee floatValue] - [fixedFee.feeAmount floatValue]);
        [self.scrollView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.bottom).offset(10.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(20.0f);
        }];
        self.lastView = view;
    }
    if (self.type == CoachProductTypeC1Wuyou || self.type == CoachProductTypeC2Wuyou) {
        if ([self.coach.isCheyouWuyou boolValue]) {
            trainingFee = @([trainingFee floatValue] - 50000);
        }
        UIView *view = [self buildPriceItemViewWithTitle:@"培训费" valueString:[trainingFee generateMoneyString] type:0];
        [self.scrollView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.bottom).offset(10.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(20.0f);
        }];
        self.lastView = view;
        
        UIView *insuranceView = [self buildPriceItemViewWithTitle:@"赔付宝" valueString:[[[HHConstantsStore sharedInstance] getInsuranceWithType:0] generateMoneyString] type:0];
        [self.scrollView addSubview:insuranceView];
        [insuranceView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.bottom).offset(10.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(20.0f);
        }];
        self.lastView = insuranceView;
        
        UIView *item1 = [self buildPriceItemViewWithTitle:@"单科挂科补考费" valueString:@"最高赔付限额500元" type:1];
        [self.scrollView addSubview:item1];
        [item1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.bottom).offset(5.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(10.0f);
        }];
        self.lastView = item1;
        
        UIView *item2 = [self buildPriceItemViewWithTitle:@"挂科5次重新学车费用" valueString:@"最高赔付5000元" type:1];
        [self.scrollView addSubview:item2];
        [item2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.bottom).offset(5.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(10.0f);
        }];
        self.lastView = item2;
        
        
        UIView *item3 = [self buildPriceItemViewWithTitle:@"免费赠送学车意外险" valueString:@"价值10000元" type:1];
        [self.scrollView addSubview:item3];
        [item3 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.bottom).offset(5.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(10.0f);
        }];
        self.lastView = item3;
        
        if ([self.coach.isCheyouWuyou boolValue]) {
            UIView *view = [self buildPriceItemViewWithTitle:@"考场模拟费" valueString:[@(50000) generateMoneyString] type:0];
            [self.scrollView addSubview:view];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lastView.bottom).offset(10.0f);
                make.left.equalTo(self.scrollView.left);
                make.width.equalTo(self.scrollView.width);
                make.height.mas_equalTo(20.0f);
            }];
            self.lastView = view;
        }
        
    } else {
        
        UIView *view = [self buildPriceItemViewWithTitle:@"培训费" valueString:[trainingFee generateMoneyString] type:0];
        [self.scrollView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.bottom).offset(10.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(20.0f);
        }];
        self.lastView = view;

    }
    
    UIView *view = [self buildPriceItemViewWithTitle:@"总费用" valueString:[[self.coach getPriceProductType:self.type] generateMoneyString] type:0];
    [self.scrollView addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lastView.bottom).offset(10.0f);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(20.0f);
    }];
    self.lastView = view;
}

- (UIView *)buildPriceItemViewWithTitle:(NSString *)title valueString:(NSString *)valueString type:(NSInteger) type{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    if (type == 0) {
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor HHTextDarkGray];

    } else {
        titleLabel.font = [UIFont systemFontOfSize:11.0f];
        titleLabel.textColor = [UIColor HHLightTextGray];
    }
    
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(25.0f);
        make.centerY.equalTo(view.centerY);
    }];

    UILabel *pricelLabel = [[UILabel alloc] init];
    pricelLabel.text = valueString;
    pricelLabel.textColor = [UIColor HHOrange];
    
    if (type == 0) {
        pricelLabel.font = [UIFont systemFontOfSize:14.0f];
        
    } else {
        pricelLabel.font = [UIFont systemFontOfSize:11.0f];
    }
    
    [view addSubview:pricelLabel];
    [pricelLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.right).offset(-25.0f);
        make.centerY.equalTo(view.centerY);
        
        if (type == 0) {
            make.width.mas_equalTo(50.0f);
            
        } else {
            make.width.mas_equalTo(100.0f);
        }
        
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pricelLabel.left).offset(-5.0f);
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(titleLabel.right).offset(5.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    if ([title isEqualToString:@"赔付宝"]) {
        line.hidden = YES;
        pricelLabel.hidden = YES;
    }
    return view;
    
}

- (void)buildServiceDetailView {
    NSMutableArray *array = [NSMutableArray array];
    if (self.type == CoachProductTypeStandard || self.type == CoachProductTypeC2Standard) {
        UIView *itemView;
        for (int i = 0; i < 5; i++) {
            if (i == 0) {
                itemView = [self buildServiceItemViewWithTitle:@"四人一车" subTitle:@"一车最多四人，无需排队等候"];
            } else if (i == 1) {
                itemView = [self buildServiceItemViewWithTitle:@"高性价比" subTitle:@"学车超低价，省钱又省心"];
            } else if (i == 2) {
                itemView = [self buildServiceItemViewWithTitle:@"贴心服务" subTitle:@"1V1学车顾问贴心服务，24小时极速回复"];

            } else if (i == 3) {
                itemView = [self buildServiceItemViewWithTitle:@"灵活预约" subTitle:@"灵活预约时间，随到随学，快速拿证"];

            } else {
                itemView = [self buildServiceItemViewWithTitle:@"绝无隐形收费" subTitle:@"分阶段打款，资金百分百托管，先学车后打款"];

            }
            self.lastView = itemView;
            [array addObject:itemView];
            [self.scrollView addSubview:itemView];
            [itemView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.left);
                make.height.mas_equalTo(35.0f);
                make.width.equalTo(self.scrollView.width);
                if (i == 0) {
                    make.top.equalTo(self.serviceTitleLabel.bottom).offset(10.0f);
                } else {
                    UIView *preView = array[i - 1];
                    make.top.equalTo(preView.bottom).offset(15.0f);
                }
            }];
        }
        
    } else if (self.type == CoachProductTypeVIP || self.type == CoachProductTypeC2VIP) {
        UIView *itemView;
        for (int i = 0; i < 5; i++) {
            if (i == 0) {
                itemView = [self buildServiceItemViewWithTitle:@"一人一车" subTitle:@"一车最多一人，学车至尊体验"];
            } else if (i == 1) {
                itemView = [self buildServiceItemViewWithTitle:@"极速拿证" subTitle:@"练车时长不限，享受极速拿证"];
            } else if (i == 2) {
                itemView = [self buildServiceItemViewWithTitle:@"贴心服务" subTitle:@"1V1学车顾问贴心服务，24小时极速回复"];
                
            } else if (i == 3) {
                itemView = [self buildServiceItemViewWithTitle:@"灵活预约" subTitle:@"灵活预约时间，随到随学，快速拿证"];
                
            } else {
                itemView = [self buildServiceItemViewWithTitle:@"绝无隐形收费" subTitle:@"分阶段打款，资金百分百托管，先学车后打款"];
                
            }
            self.lastView = itemView;
            [array addObject:itemView];
            [self.scrollView addSubview:itemView];
            [itemView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.left);
                make.height.mas_equalTo(35.0f);
                make.width.equalTo(self.scrollView.width);
                if (i == 0) {
                    make.top.equalTo(self.serviceTitleLabel.bottom).offset(10.0f);
                } else {
                    UIView *preView = array[i - 1];
                    make.top.equalTo(preView.bottom).offset(15.0f);
                }
            }];
        }
        
    } else {
        
        UIView *itemView;
        for (int i = 0; i < 5; i++) {
            if (i == 0) {
                itemView = [self buildServiceItemViewWithTitle:@"包补考费" subTitle:@"学车全程挂科免补考费，还赠送人身意外险"];
            } else if (i == 1) {
                itemView = [self buildServiceItemViewWithTitle:@"四人一车" subTitle:@"一车最多四人，无需排队等候"];
            } else if (i == 2) {
                itemView = [self buildServiceItemViewWithTitle:@"贴心服务" subTitle:@"1V1学车顾问贴心服务，24小时极速回复"];
                
            } else if (i == 3) {
                itemView = [self buildServiceItemViewWithTitle:@"灵活预约" subTitle:@"灵活预约时间，随到随学，快速拿证"];
                
            } else {
                itemView = [self buildServiceItemViewWithTitle:@"绝无隐形收费" subTitle:@"分阶段打款，资金百分百托管，先学车后打款"];
                
            }
            self.lastView = itemView;
            [array addObject:itemView];
            [self.scrollView addSubview:itemView];
            [itemView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.left);
                make.height.mas_equalTo(35.0f);
                make.width.equalTo(self.scrollView.width);
                if (i == 0) {
                    make.top.equalTo(self.serviceTitleLabel.bottom).offset(10.0f);
                } else {
                    UIView *preView = array[i - 1];
                    make.top.equalTo(preView.bottom).offset(15.0f);
                }
            }];
        }
        
    }
    
}

- (UIView *)buildServiceItemViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *bar = [[UIView alloc] init];
    bar.backgroundColor = [UIColor HHOrange];
    [view addSubview:bar];
    [bar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(25.0f);
        make.top.equalTo(view.top);
        make.width.mas_equalTo(3.0f);
        make.height.mas_equalTo(15.0f);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor HHTextDarkGray];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bar.right).offset(5.0f);
        make.centerY.equalTo(bar.centerY);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = subTitle;
    subTitleLabel.textColor = [UIColor HHLightTextGray];
    subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:subTitleLabel];
    [subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bar.left);
        make.bottom.equalTo(view.bottom);
    }];
    
    return view;
}

- (NSAttributedString *)generateAttrStringWithText:(NSString *)text image:(UIImage *)image {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", text] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(0, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    return attributedString;
}


- (UILabel *)buildLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor darkTextColor];
    label.font = [UIFont systemFontOfSize:18.0f];
    return label;
}


- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSMutableAttributedString *)buildAttributeString {
    NSString *baseString = @"对班别有任何疑问可致电客服热线400-001-6006 或 点击联系:在线客服";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:[UIColor HHOrange]} range:[baseString rangeOfString:@"400-001-6006"]];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:[UIColor HHOrange]} range:[baseString rangeOfString:@"在线客服"]];
    
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[baseString rangeOfString:@"400-001-6006"]];
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[baseString rangeOfString:@"在线客服"]];
    
    return attrString;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"callSupport"]) {
        [[HHSupportUtility sharedManager] callSupport];
    } else {
        [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
    }
}

- (void)buildOtherFeesView {
    HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
    int i = 0;
    for (HHCityOtherFee *otherFee in city.cityOtherFees) {
        if (self.type == CoachProductTypeC1Wuyou || self.type == CoachProductTypeC2Wuyou) {
            if ([otherFee.feeName isEqualToString:@"补考费（车管所收取）"]) {
                continue;
            }
            if ([self.coach.isCheyouWuyou boolValue] && [otherFee.feeName isEqualToString:@"考场模拟费（考场收取）"]) {
                continue;
            }
        }
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        para.lineSpacing = 3.0f;
        para.lineBreakMode = NSLineBreakByWordWrapping;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[otherFee.feeDes stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:para}];
        HHOtherFeeItemView *item = [[HHOtherFeeItemView alloc] initWithTitle:otherFee.feeName text:text];
        [self.scrollView addSubview:item];
        [item makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.left).offset(20.0f);
            make.width.equalTo(self.scrollView.width).offset(-40.0f);
            make.top.equalTo(self.lastView.bottom).offset(20.0f);
            make.height.mas_equalTo(20.0f + CGRectGetHeight([self getDescriptionTextSizeWithText:text]));
        }];
        
        i++;
        self.lastView = item;
    }

}

- (CGRect)getDescriptionTextSizeWithText:(NSAttributedString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-30.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                     context:nil];
    return rect;
}

- (void)purchaseButtonTapped {
    HHPurchaseConfirmViewController *vc = [[HHPurchaseConfirmViewController alloc] initWithCoach:self.coach selectedType:self.type];
    [self.navigationController pushViewController:vc animated:YES];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:price_detail_page_purchase_tapped attributes:nil];
}

- (void)depositButtonTapped {
    HHPrepayViewController *vc = [[HHPrepayViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:price_detail_page_deposit_tapped attributes:nil];
}


@end
