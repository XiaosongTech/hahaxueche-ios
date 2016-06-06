//
//  HHCoachPriceCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachPriceCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCoachPriceCell

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
    
    self.titleLabel = [[UILabel alloc] init];
    [self.mainView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.top).offset(20.0f);
        make.left.equalTo(self.mainView.left).offset(20.0f);
    }];
    
    self.standartPriceItemView = [[HHPriceItemView alloc] init];
    [self.mainView addSubview:self.standartPriceItemView];
    [self.standartPriceItemView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.top).offset(56.0f);
        make.left.equalTo(self.mainView.left);
        make.width.equalTo(self.mainView.width);
        make.height.mas_equalTo(70.0f);
    }];
    
    self.VIPPriceItemView = [[HHPriceItemView alloc] init];
    [self.mainView addSubview:self.VIPPriceItemView];
    [self.VIPPriceItemView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.standartPriceItemView.bottom);
        make.left.equalTo(self.mainView.left);
        make.width.equalTo(self.mainView.width);
        make.height.mas_equalTo(70.0f);
    }];
    
}

- (void)setupCellWithCoach:(HHCoach *)coach {
    self.titleLabel.attributedText = [self generateAttrStringWithText:@"拿证价格" image:[UIImage imageNamed:@"ic_coachmsg_charge"]];
    [self.standartPriceItemView setupWithPrice:coach.price iconImage:[UIImage imageNamed:@"ic_chaozhi"] marketPrice:coach.marketPrice detailText:@"四人一车, 高性价比"];
    
    if ([coach.VIPPrice floatValue] > 0) {
        self.VIPPriceItemView.hidden = NO;
        [self.VIPPriceItemView setupWithPrice:coach.VIPPrice iconImage:[UIImage imageNamed:@"ic_VIP_details"] marketPrice:coach.VIPMarketPrice detailText:@"一人一车, 极速拿证"];
    } else {
        self.VIPPriceItemView.hidden = YES;
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

@end
