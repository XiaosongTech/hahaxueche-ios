//
//  HHCoachFieldCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachFieldCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCoachFieldCell

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
        make.height.equalTo(self.contentView.height);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.attributedText = [self generateAttrStringWithText:@"训练场地址" image:[UIImage imageNamed:@"ic_coachmsg_localtion"]];
    [self.mainView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.top).offset(21.0f);
        make.left.equalTo(self.mainView).offset(20.0f);
    }];
    
    self.sendAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendAddressButton setAttributedTitle:[self generateSendAddressButtonString] forState:UIControlStateNormal];
    [self.sendAddressButton addTarget:self action:@selector(sendAddressButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendAddressButton];
    [self.sendAddressButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.lessThanOrEqualTo(self.contentView.right).offset(-15.0f);
    }];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor HHLightLineGray];
    [self.mainView addSubview:self.line];
    [self.line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.top).offset(55.0f);
        make.left.equalTo(self.mainView.left);
        make.width.equalTo(self.mainView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    self.botView = [[UIView alloc] init];
    UITapGestureRecognizer *recgonizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMapView)];
    [self.botView addGestureRecognizer:recgonizer];
    [self.mainView addSubview:self.botView];
    [self.botView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.bottom);
        make.left.equalTo(self.mainView.left);
        make.width.equalTo(self.mainView.width);
        make.bottom.equalTo(self.mainView.bottom);

    }];
    
    self.fieldLabel = [[UILabel alloc] init];
    self.fieldLabel.textColor = [UIColor HHLightTextGray];
    self.fieldLabel.font = [UIFont systemFontOfSize:15.0f];
    self.fieldLabel.adjustsFontSizeToFitWidth = YES;
    self.fieldLabel.textAlignment = NSTextAlignmentCenter;
    self.fieldLabel.minimumScaleFactor = .1f;
    self.fieldLabel.numberOfLines = 1;
    [self.botView addSubview:self.fieldLabel];
    [self.fieldLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.centerY);
        make.left.equalTo(self.mainView.left).offset(20.0f);
        make.right.equalTo(self.mainView.right).offset(-28.0f);
    }];
    
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
    [self.botView addSubview:self.arrowView];
    [self.arrowView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fieldLabel.centerY);
        make.right.equalTo(self.mainView.right).offset(-18.0f);
    }];
    
}

- (void)setupCellWithField:(HHField *)field {
    self.fieldLabel.text = field.displayAddress;
    self.field = field;
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

- (NSMutableAttributedString *)generateSendAddressButtonString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"发我定位" attributes:@{NSForegroundColorAttributeName:[UIColor HHLinkBlue], NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSUnderlineStyleAttributeName:[NSNumber numberWithInt:1]}];
    
    return attrString;
}

- (void)showMapView {
    if (self.fieldBlock) {
        self.fieldBlock(self.field);
    }
}

- (void)sendAddressButtonTapped {
    if (self.sendAddressBlock) {
        self.sendAddressBlock(self.field);
    }
}

@end
