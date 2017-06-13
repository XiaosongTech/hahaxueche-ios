//
//  HHSchoolPriceTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 05/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHSchoolPriceTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"
#import "HHCoachPriceInfoView.h"



@implementation HHSchoolPriceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor HHLightBackgroudGray];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.viewArray = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.mainView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.attributedText = [self generateAttrStringWithText:@"班别费用" image:[UIImage imageNamed:@"ic_coachmsg_charge"]];
    [self.mainView addSubview:self.titleLabel];
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [UIColor HHLightLineGray];
    [self.mainView addSubview:self.topLine];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.top.equalTo(self.contentView.top).offset(10.0f);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainView.top).offset(25.0f);
        make.left.equalTo(self.contentView.left).offset(15.0f);
    }];
    
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.bottom.equalTo(self.mainView.top).offset(50.0f);
    }];
}

- (void)setupCellWithSchool:(HHDrivingSchool *)school {
    if (self.viewArray.count > 0) {
        return;
    }
    HHCoach *coach = [[HHCoach alloc] init];
    coach.price = school.lowestPrice;
    coach.VIPPrice = school.lowestVIPPrice;
    
    HHCoachPriceInfoView *view1 = [[HHCoachPriceInfoView alloc] initWithClassType:CoachProductTypeStandard coach:coach showLine:NO];
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceTapped:)];
    [view1 addGestureRecognizer:rec];
    view1.notifPriceBlock = ^{
        if (self.notifPriceBlock) {
            self.notifPriceBlock();
        }
    };
    view1.callBlock = ^{
        if (self.callBlock) {
            self.callBlock();
        }
    };
    
    [self.viewArray addObject:view1];
    [self.contentView addSubview:view1];
    [view1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.width);
        make.top.equalTo(self.topLine.bottom);
        make.height.mas_equalTo(85.0f);
        make.left.equalTo(self.contentView.left);
    }];
    
    if (school.lowestVIPPrice.floatValue > 0) {
        HHCoachPriceInfoView *view2 = [[HHCoachPriceInfoView alloc] initWithClassType:CoachProductTypeVIP coach:coach];
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceTapped:)];
        [view2 addGestureRecognizer:rec];
        view2.notifPriceBlock = ^{
            if (self.notifPriceBlock) {
                self.notifPriceBlock();
            }
        };
        view2.callBlock = ^{
            if (self.callBlock) {
                self.callBlock();
            }
        };
        [self.contentView addSubview:view2];
        [view2 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView.width);
            make.top.equalTo(self.topLine.bottom).offset(85.0f);
            make.height.mas_equalTo(85.0f);
            make.left.equalTo(self.contentView.left);
        }];
        [self.viewArray addObject:view2];
        
        
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


- (NSAttributedString *)generatePriceStringWithPrice:(NSString *)price {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor HHDarkOrange]}];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:@"起" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
   
    [attributedString appendAttributedString:attributedString2];
    return attributedString;
}

- (void)priceTapped:(UITapGestureRecognizer *)rec {
    HHCoachPriceInfoView *view = (HHCoachPriceInfoView *)rec.view;
    if (self.priceBlock) {
        self.priceBlock(view.type);
    }
}

@end
