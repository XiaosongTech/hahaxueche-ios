//
//  HHCoachPriceTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 08/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHCoachPriceTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHCoachPriceInfoView.h"

@implementation HHCoachPriceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15.0f);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.equalTo(self.contentView.height).offset(-30.0f);
    }];
    
    self.topView = [[UIView alloc] init];
    [self.mainView addSubview:self.topView];
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.top);
        make.left.equalTo(self.mainView.left);
        make.width.equalTo(self.mainView.width);
        make.height.mas_equalTo(56.0f);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [UIColor HHLightLineGray];
    [self.topView addSubview:self.topLine];
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.bottom);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    self.licenseView = [[UIView alloc] init];
    self.licenseView.backgroundColor = [UIColor whiteColor];
    [self.mainView addSubview:self.licenseView];
    [self.licenseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.mainView.left);
        make.width.equalTo(self.mainView.width);
        make.height.mas_equalTo(50.0f);
    }];
    
}

- (void)setupCellWithCoach:(HHCoach *)coach selectedType:(NSInteger)type {
    self.selectedType = type;
    self.titleLabel.attributedText = [self generateAttrStringWithText:@"拿证价格" image:[UIImage imageNamed:@"ic_coachmsg_charge"]];
    [self buildLicenseTypesViewWithCoach:coach];
    [self buildClassViewWithCoach:coach];
}

- (void)buildClassViewWithCoach:(HHCoach *)coach {
    if (self.c1ContainerView && self.c2ContainerView) {
        if (self.selectedType == 1) {
            self.c1ContainerView.hidden = NO;
            self.c2ContainerView.hidden = YES;
        } else {
            self.c1ContainerView.hidden = YES;
            self.c2ContainerView.hidden = NO;
        }
        return;
    }
    
    if (self.selectedType == 1) {
        if (self.c1ContainerView) {
            [self.c1ContainerView removeFromSuperview];
        }
        NSInteger count = 0;
        self.c1ContainerView = [[UIView alloc] init];
        self.c1ContainerView.backgroundColor = [UIColor whiteColor];
        [self.mainView addSubview:self.c1ContainerView];
        if ([coach.price floatValue] > 0) {
            if (![coach.isCheyouWuyou boolValue]) {
                [self buildSingleClassViewWithType:CoachProductTypeStandard coach:coach index:count containerView:self.c1ContainerView];
                count++;
            }
            
        }
        
        if ([coach.VIPPrice floatValue] > 0) {
            if (![coach.isCheyouWuyou boolValue]) {
                [self buildSingleClassViewWithType:CoachProductTypeVIP coach:coach index:count containerView:self.c1ContainerView];
                count++;
            }
        }
        
        if ([coach.price floatValue] > 0) {
            [self buildSingleClassViewWithType:CoachProductTypeC1Wuyou coach:coach index:count containerView:self.c1ContainerView];
            count++;
        }
        
        [self.c1ContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.licenseView.bottom);
            make.left.equalTo(self.mainView.left);
            make.width.equalTo(self.mainView.width);
            make.height.mas_equalTo(count * 85.0f);
        }];
        
    } else {
        if (self.c2ContainerView) {
            [self.c2ContainerView removeFromSuperview];
        }
        NSInteger count = 0;
        self.c2ContainerView = [[UIView alloc] init];
        self.c2ContainerView.backgroundColor = [UIColor whiteColor];
        [self.mainView addSubview:self.c2ContainerView];
        if ([coach.c2Price floatValue] > 0) {
            [self buildSingleClassViewWithType:CoachProductTypeC2Standard coach:coach index:count containerView:self.c2ContainerView];
            count++;
        }
        
        if ([coach.c2VIPPrice floatValue] > 0) {
            [self buildSingleClassViewWithType:CoachProductTypeC2VIP coach:coach index:count containerView:self.c2ContainerView];
            count++;
        }
        
        if ([coach.c2Price floatValue] > 0) {
            [self buildSingleClassViewWithType:CoachProductTypeC2Wuyou coach:coach index:count containerView:self.c2ContainerView];
            count++;
        }
        [self.c2ContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.licenseView.bottom);
            make.left.equalTo(self.mainView.left);
            make.width.equalTo(self.mainView.width);
            make.height.mas_equalTo(count * 85.0f);
        }];
        
    }
}

- (void)buildSingleClassViewWithType:(CoachProductType)type coach:(HHCoach *)coach index:(NSInteger)index containerView:(UIView *)containerView {
    HHCoachPriceInfoView *view = [[HHCoachPriceInfoView alloc] initWithClassType:type coach:coach];
    [view.callSchoolButton setTitle:@"联系教练" forState:UIControlStateNormal];
    view.callBlock = ^(CoachProductType type) {
        if (self.callBlock) {
            self.callBlock();
        }
    };
    
    view.notifPriceBlock = ^{
        if (self.notifPriceBlock) {
            self.notifPriceBlock();
        }
    };
    [containerView addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.top).offset(index * 85.0f);
        make.left.equalTo(containerView.left);
        make.width.equalTo(containerView.width);
        make.height.mas_equalTo(85.0f);
    }];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showClassDetail:)];
    [view addGestureRecognizer:tapRec];
}

- (void)buildLicenseTypesViewWithCoach:(HHCoach *)coach {
    if (self.c1View) {
        return;
    }
    
    if ([coach.isCheyouWuyou boolValue]) {
        self.c1View = [self buildLicenseTypeViewWithType:1 selected:YES alignLeft:YES];
        [self.licenseView addSubview:self.c1View];
        [self.c1View makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.licenseView.left);
            make.top.equalTo(self.licenseView.top);
            make.width.equalTo(self.licenseView.width).multipliedBy(0.5f);
            make.height.equalTo(self.licenseView.height);
        }];
        return;
    }
    
    if ([coach.c2Price integerValue] > 0 || [coach.c2VIPPrice integerValue] > 0) {
        self.c1View = [self buildLicenseTypeViewWithType:1 selected:YES alignLeft:NO];
        [self.licenseView addSubview:self.c1View];
        
        self.c2View = [self buildLicenseTypeViewWithType:2 selected:NO alignLeft:NO];
        [self.licenseView addSubview:self.c2View];
        
        [self.c1View makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.licenseView.left);
            make.top.equalTo(self.licenseView.top);
            make.width.equalTo(self.licenseView.width).multipliedBy(0.5f);
            make.height.equalTo(self.licenseView.height);
        }];
        
        [self.c2View makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.c1View.right);
            make.top.equalTo(self.licenseView.top);
            make.width.equalTo(self.licenseView.width).multipliedBy(0.5f);
            make.height.equalTo(self.licenseView.height);
        }];
        
        
        self.licenseMidLine = [[UIView alloc] init];
        self.licenseMidLine.backgroundColor = [UIColor HHLightLineGray];
        [self.licenseView addSubview:self.licenseMidLine];
        [self.licenseMidLine makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.licenseView);
            make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
            make.height.equalTo(self.licenseView.height).offset(-20.0f);
        }];
        
        
    } else {
        self.c1View = [self buildLicenseTypeViewWithType:1 selected:YES alignLeft:YES];
        [self.licenseView addSubview:self.c1View];
        [self.c1View makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.licenseView.left);
            make.top.equalTo(self.licenseView.top);
            make.width.equalTo(self.licenseView.width).multipliedBy(0.5f);
            make.height.equalTo(self.licenseView.height);
        }];
        
    }
}

- (NSAttributedString *)generateAttrStringWithText:(NSString *)text image:(UIImage *)image {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", text] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(0, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    return attributedString;
}

- (HHLicenseTypeView *)buildLicenseTypeViewWithType:(NSInteger)type selected:(BOOL)selected alignLeft:(BOOL)alignLeft {
    HHLicenseTypeView *view = [[HHLicenseTypeView alloc] initWithType:type selected:selected alignLeft:alignLeft];
    view.selectedBlock = ^(){
        if (self.selectedBlock) {
            self.selectedBlock(type);
        }
    };
    view.questionMarkBlock = ^() {
        if (self.questionMarkBlock) {
            self.questionMarkBlock(type);
        }
    };
    return view;
}

- (void)setSelectedType:(NSInteger)selectedType {
    _selectedType = selectedType;
    if (self.selectedType == 1) {
        self.c1View.titleLabel.textColor = [UIColor HHDarkOrange];
        self.c2View.titleLabel.textColor = [UIColor HHLightestTextGray];
        self.c1ContainerView.hidden = NO;
        self.c2ContainerView.hidden = YES;
    } else {
        self.c1View.titleLabel.textColor = [UIColor HHLightestTextGray];
        self.c2View.titleLabel.textColor = [UIColor HHDarkOrange];
        self.c1ContainerView.hidden = YES;
        self.c2ContainerView.hidden = NO;
    }
}

- (void)showClassDetail:(UITapGestureRecognizer *)recognizer {
    HHCoachPriceInfoView *view = (HHCoachPriceInfoView *)recognizer.view;
    if (self.priceDetailBlock) {
        self.priceDetailBlock(view.type);
    }
}

@end
