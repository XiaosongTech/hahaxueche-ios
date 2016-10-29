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
#import "HHPersonalCoachPrice.h"

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
    
    self.topView = [[UIView alloc] init];
    [self.mainView addSubview:self.topView];
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.top);
        make.left.equalTo(self.mainView.left);
        make.width.equalTo(self.mainView.width);
        make.height.mas_equalTo(56.0f);
    }];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPriceDetail)];
    [self.topView addGestureRecognizer:tapRec];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];
    
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
    [self.topView addSubview:self.arrowView];
    [self.arrowView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(self.topView.right).offset(-20.0f);
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
    
}

- (void)setupCellWithCoach:(HHCoach *)coach {
    __weak HHCoachPriceCell *weakSelf = self;
    self.titleLabel.attributedText = [self generateAttrStringWithText:@"拿证价格" image:[UIImage imageNamed:@"ic_coachmsg_charge"]];
    
    if (self.c1View) {
        [self.c1View removeFromSuperview];
    }
    self.c1View = [[HHPriceSectionView alloc] initWithTitle:@"C1手动挡" price:coach.price VIPPrice:coach.VIPPrice];
    self.c1View.questionAction = ^() {
        if (weakSelf.licenseTypeAction) {
            weakSelf.licenseTypeAction(1);
        }
    };
    [self.contentView addSubview:self.c1View];
    [self.c1View makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.top.equalTo(self.topView.bottom);
        CGFloat height = 35.0f + 50.0f;
        if ([coach.VIPPrice floatValue] > 0) {
            height = height + 50.0f;
        }
        make.height.mas_equalTo(height);
    }];
    
    if (self.c2View) {
        [self.c2View removeFromSuperview];
    }
    if ([coach.c2Price floatValue] > 0 || [coach.c2VIPPrice floatValue] > 0) {
        self.c2View = [[HHPriceSectionView alloc] initWithTitle:@"C2自动挡" price:coach.c2Price VIPPrice:coach.c2VIPPrice];
        self.c2View.questionAction = ^() {
            if (weakSelf.licenseTypeAction) {
                weakSelf.licenseTypeAction(2);
            }
        };
        [self.contentView addSubview:self.c2View];
        [self.c2View makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left);
            make.width.equalTo(self.contentView.width);
            make.top.equalTo(self.c1View.bottom);
            CGFloat height = 35.0f;
            if ([coach.c2VIPPrice floatValue] > 0 && [coach.c2Price floatValue] > 0) {
                height = height + 50.0f * 2;
            } else if ([coach.c2VIPPrice floatValue] > 0 || [coach.c2Price floatValue] > 0) {
                height = height + 50.0f;
            }
            make.height.mas_equalTo(height);
        }];

    }
    
}

- (void)setupCellWithPersonalCoach:(HHPersonalCoach *)coach {
    __weak HHCoachPriceCell *weakSelf = self;
    self.titleLabel.attributedText = [self generateAttrStringWithText:@"陪练价格" image:[UIImage imageNamed:@"ic_coachmsg_charge"]];
    self.arrowView.hidden = YES;
    
    if (self.c1View) {
        [self.c1View removeFromSuperview];
        self.c1View = nil;
    }
    
    UIView *lastView = self.topView;
    
    NSArray *c1Prices = [coach.prices filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"licenseType == %ld", 1]];
    
    if ([c1Prices count] > 0) {
        self.c1View = [[HHPriceSectionView alloc] initWithTitle:@"C1手动挡" prices:c1Prices];
        self.c1View.questionAction = ^() {
            if (weakSelf.licenseTypeAction) {
                weakSelf.licenseTypeAction(1);
            }
        };
        [self.contentView addSubview:self.c1View];
        [self.c1View makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left);
            make.width.equalTo(self.contentView.width);
            make.top.equalTo(lastView.bottom);
            make.height.mas_equalTo(35.0f + c1Prices.count * 50.0f);
        }];
        lastView = self.c1View;
    }
    
    
    NSArray *c2Prices = [coach.prices filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"licenseType == %ld", 2]];
    if ([c2Prices count] > 0) {
        if (self.c2View) {
            [self.c2View removeFromSuperview];
            self.c2View = nil;
        }
        self.c2View = [[HHPriceSectionView alloc] initWithTitle:@"C2自动挡" prices:c2Prices];
        self.c2View.questionAction = ^() {
            if (weakSelf.licenseTypeAction) {
                weakSelf.licenseTypeAction(2);
            }
        };
        [self.contentView addSubview:self.c2View];
        [self.c2View makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left);
            make.width.equalTo(self.contentView.width);
            make.top.equalTo(lastView.bottom);
            make.height.mas_equalTo(35.0f + c2Prices.count * 50.0f);
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

- (void)showPriceDetail {
    if (self.priceAction) {
        self.priceAction ();
    }
}

@end
