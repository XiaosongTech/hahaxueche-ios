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


@implementation HHSchoolPriceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor HHLightBackgroudGray];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    UIView *view1 = [self buildSinglePriceViewWithTitle:@"超值班" subTitle:@"四人一车, 高性价比" price:school.lowestPrice tag:0 showLine:YES];
    [self.contentView addSubview:view1];
    [view1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.width);
        make.top.equalTo(self.topLine.bottom);
        make.height.mas_equalTo(70.0f);
        make.left.equalTo(self.contentView.left);
    }];
    
    if (school.lowestVIPPrice.floatValue > 0) {
        UIView *view2 = [self buildSinglePriceViewWithTitle:@"VIP班" subTitle:@"一人一车, 极速拿证" price:school.lowestVIPPrice tag:1 showLine:YES];
        [self.contentView addSubview:view2];
        [view2 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView.width);
            make.top.equalTo(self.topLine.bottom).offset(70.0f);
            make.height.mas_equalTo(70.0f);
            make.left.equalTo(self.contentView.left);
        }];
        
        UIView *view3 = [self buildSinglePriceViewWithTitle:@"无忧班" subTitle:@"包补考费, 不过包赔" price:@([school.lowestPrice floatValue] + 20000) tag:2 showLine:NO];
        [self.contentView addSubview:view3];
        [view3 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView.width);
            make.top.equalTo(self.topLine.bottom).offset(140.0f);
            make.height.mas_equalTo(70.0f);
            make.left.equalTo(self.contentView.left);
        }];
    } else {
        UIView *view2 = [self buildSinglePriceViewWithTitle:@"无忧班" subTitle:@"包补考费, 不过包赔" price:@([school.lowestPrice floatValue] + 20000) tag:1 showLine:NO];
        [self.contentView addSubview:view2];
        [view2 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView.width);
            make.top.equalTo(self.topLine.bottom).offset(70.0f);
            make.height.mas_equalTo(70.0f);
            make.left.equalTo(self.contentView.left);
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

- (UIView *)buildSinglePriceViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle price:(NSNumber *)price tag:(NSInteger)tag showLine:(BOOL)showLine {
    UIView *view = [[UIView alloc] init];
    view.tag = tag;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 3.0f;
    titleLabel.layer.borderWidth = 1.0f;
    titleLabel.layer.borderColor = [UIColor HHOrange].CGColor;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.textColor = [UIColor HHOrange];
    titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(15.0f);
        make.centerY.equalTo(view.centerY);
        make.height.mas_equalTo(16.0f);
        make.width.mas_equalTo(35.0f);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = subTitle;
    [subTitleLabel sizeToFit];
    subTitleLabel.textColor = [UIColor HHLightTextGray];
    subTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    [view addSubview:subTitleLabel];
    [subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(60.0f);
        make.centerY.equalTo(view.centerY);
    }];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
    [view addSubview:arrowView];
    [arrowView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.right).offset(-15.0f);
        make.centerY.equalTo(view.centerY);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.attributedText = [self generatePriceStringWithPrice:[price generateMoneyString]];
    [view addSubview:priceLabel];
    [priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowView.left).offset(-5.0f);
        make.centerY.equalTo(view.centerY);
    }];
    
    if (showLine) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor HHLightLineGray];
        [view addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.left).offset(15.0f);
            make.right.equalTo(view.right);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
            make.bottom.equalTo(view.bottom);
        }];
    }
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceTapped:)];
    [view addGestureRecognizer:tapRec];
    
    return view;
}

- (NSAttributedString *)generatePriceStringWithPrice:(NSString *)price {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor HHDarkOrange]}];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:@"起" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
   
    [attributedString appendAttributedString:attributedString2];
    return attributedString;
}

- (void)priceTapped:(UITapGestureRecognizer *)rec {
    if (self.priceBlock) {
        self.priceBlock(rec.view.tag);
    }
}

@end
