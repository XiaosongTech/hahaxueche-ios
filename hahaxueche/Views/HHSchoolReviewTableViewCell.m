//
//  HHSchoolReviewTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 08/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHSchoolReviewTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHCoachReviewView.h"

@implementation HHSchoolReviewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor HHLightBackgroudGray];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.reviewViewArray = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.mainView];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.mainView addSubview:self.titleLabel];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setAttributedTitle:[self generateMoreAttrStringWithText:@"更多" image:[UIImage imageNamed:@"ic_morearrow"]] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(showReviewListVC) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton setTitle:@"点击查看更多>>" forState:UIControlStateNormal];
    [self.moreButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
    self.moreButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.moreButton addTarget:self action:@selector(showReviewListVC) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.moreButton];
    [self.moreButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.left);
        make.bottom.equalTo(self.mainView.bottom);
        make.width.equalTo(self.mainView.width);
        make.height.mas_equalTo(50.0f);
    }];
}

- (void)setupCellWithSchool:(HHDrivingSchool *)school reviews:(HHReviews *)reviews {
    self.school = school;
    self.titleLabel.attributedText = [self generateAttrStringWithText:[NSString stringWithFormat:@"学员点评 (%@)", [school.reviewCount stringValue]] image:[UIImage imageNamed:@"ic_coachmsg_pingjia"]];
    
    if (self.reviewViewArray.count) {
        int i = 0;
        for (HHCoachReviewView *view in self.reviewViewArray) {
            [view setupViewWithReview:reviews.reviews[i]];
            i++;
        }
    } else {
        NSInteger count = MIN(reviews.reviews.count, 3);
        for (int i = 0; i < count; i++) {
            HHReview *review = reviews.reviews[i];
            HHCoachReviewView *view = [[HHCoachReviewView alloc] init];
            [view setupViewWithReview:review];
            [self.mainView addSubview:view];
            [self.reviewViewArray addObject:view];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topLine.bottom).offset(i * 90.0f);
                make.left.equalTo(self.mainView.left);
                make.width.equalTo(self.mainView.width);
                make.height.mas_equalTo(90.0f);
            }];
            UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showReviewListVC)];
            [view addGestureRecognizer:tapRec];
        }

    }
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

- (void)showReviewListVC {
    if (self.reviewsBlock) {
        self.reviewsBlock();
    }
}

@end
