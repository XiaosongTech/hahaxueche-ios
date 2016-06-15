//
//  HHCoachServiceTypeCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachServiceTypeCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCoachServiceTypeCell

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
        make.top.equalTo(self.contentView.top);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.equalTo(self.contentView.height).offset(-15.0f);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.attributedText = [self generateAttrStringWithText:@"课程类型" image:[UIImage imageNamed:@"ic_coachmsg_classtype"]];
    [self.mainView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainView.centerY);
        make.left.equalTo(self.mainView.left).offset(20.0f);
    }];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textColor = [UIColor HHLightTextGray];
    self.valueLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.mainView addSubview:self.valueLabel];
    [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainView.centerY);
        make.right.equalTo(self.mainView.right).offset(-18.0f);
    }];
    
}

- (void)setupCellWithCoach:(HHCoach *)coach {
    self.valueLabel.text = [coach licenseTypesName];
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
