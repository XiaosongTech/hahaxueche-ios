//
//  HHSchoolFieldTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 07/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHSchoolFieldTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHSchoolDetailSingleFieldView.h"

@implementation HHSchoolFieldTableViewCell

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
    self.titleLabel.attributedText = [self generateAttrStringWithText:@"训练场地" image:[UIImage imageNamed:@"ic_coachmsg_localtion"]];
    [self.mainView addSubview:self.titleLabel];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setAttributedTitle:[self generateMoreAttrStringWithText:@"地图查看训练场" image:[UIImage imageNamed:@"ic_morearrow"]] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(showMapVC) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.rightButton];
    
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
    
    [self.rightButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainView.top).offset(25.0f);
        make.right.equalTo(self.contentView.right).offset(-15.0f);
    }];
    
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.bottom.equalTo(self.mainView.top).offset(50.0f);
    }];
}

- (void)setupCellWithSchool:(HHDrivingSchool *)school {
    if (self.school) {
        return;
    }
    self.school = school;
    NSInteger count = school.fields.count;
    if (count >= 3) {
        count = 3;
    }
    for (int i = 0 ; i < count; i++) {
        HHField *field = school.fields[i];
        HHSchoolDetailSingleFieldView *view = [[HHSchoolDetailSingleFieldView alloc] initWithField:field];
        view.checkFieldBlock = ^(HHField *field) {
            if (self.checkFieldBlock) {
                self.checkFieldBlock(field);
            }
        };
        
        view.sendAddressBlock = ^(HHField *field) {
            if (self.sendAddressBlock) {
                self.sendAddressBlock(field);
            }
        };
        view.tag = i;
        [self.mainView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainView.left);
            make.top.equalTo(self.topLine.bottom).offset(100.0f * i);
            make.width.equalTo(self.mainView.width);
            make.height.mas_equalTo(100.0f);
        }];
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fieldTapped:)];
        [view addGestureRecognizer:tapRec];
    }
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setTitle:@"点击查看更多>>" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [moreButton addTarget:self action:@selector(showMapVC) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:moreButton];
    [moreButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.left);
        make.top.equalTo(self.topLine.bottom).offset(100.0f * count);
        make.width.equalTo(self.mainView.width);
        make.height.mas_equalTo(50.0f);
    }];
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

- (NSAttributedString *)generateMoreAttrStringWithText:(NSString *)text image:(UIImage *)image {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(3.0f, -3.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString appendAttributedString:attrStringWithImage];
    return attributedString;
    
}

- (void)showMapVC {
    if (self.fieldBlock) {
        self.fieldBlock(nil);
    }
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_more_fields_tapped attributes:nil];
}

-(void)fieldTapped:(UITapGestureRecognizer *)tapRec {
    HHField *field = self.school.fields[tapRec.view.tag];
    if (self.fieldBlock) {
        self.fieldBlock(field);
    }
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_single_field_tapped attributes:nil];
}

@end
