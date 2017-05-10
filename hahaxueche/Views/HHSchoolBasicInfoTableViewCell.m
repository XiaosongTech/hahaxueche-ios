//
//  HHSchoolBasicInfoTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 04/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHSchoolBasicInfoTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"

@implementation HHSchoolBasicInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.firstSecView = [self buildSecViewWithBotLine:YES];
    [self.contentView addSubview:self.firstSecView];
    
    self.secSecView = [self buildSecViewWithBotLine:YES];
    [self.contentView addSubview:self.secSecView];
    
    self.thirdSecView = [self buildSecViewWithBotLine:YES];
    [self.contentView addSubview:self.thirdSecView];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFieldsMap)];
    [self.thirdSecView addGestureRecognizer:tapRec];
    
    self.forthSecView = [self buildSecViewWithBotLine:YES];
    [self.contentView addSubview:self.forthSecView];
    
    self.fifthSecView = [self buildSecViewWithBotLine:NO];
    [self.contentView addSubview:self.fifthSecView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor HHTextDarkGray];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [self.firstSecView addSubview:self.nameLabel];
    
    self.consultNumLabel = [[UILabel alloc] init];
    [self.firstSecView addSubview:self.consultNumLabel];
    
    self.priceLabel = [[UILabel alloc] init];
    [self.secSecView addSubview:self.priceLabel];
    
    self.priceNotiLabel = [[UILabel alloc] init];
    self.priceNotiLabel.textColor = [UIColor redColor];
    self.priceNotiLabel.font = [UIFont systemFontOfSize:12.0f];
    self.priceNotiLabel.text = @"降价通知我";
    self.priceNotiLabel.userInteractionEnabled = YES;
    [self.secSecView addSubview:self.priceNotiLabel];
    UITapGestureRecognizer *tapRec2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGetNumView)];
    [self.priceNotiLabel addGestureRecognizer:tapRec2];
    
    self.bellView = [[FLAnimatedImageView alloc] init];
    self.bellView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imgString = [[NSBundle mainBundle] pathForResource:@"markdown_bell" ofType:@"gif"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgString];
    self.bellView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imgData];
    [self.secSecView addSubview:self.bellView];
    
    self.fieldLabel = [[UILabel alloc] init];
    [self.thirdSecView addSubview:self.fieldLabel];
    
    self.checkFieldLabel = [[UILabel alloc] init];
    self.checkFieldLabel.textColor = [UIColor HHLinkBlue];
    self.checkFieldLabel.font = [UIFont systemFontOfSize:13.0f];
    self.checkFieldLabel.text = @"点击查看最近>>";
    [self.thirdSecView addSubview:self.checkFieldLabel];
    
    self.passRateView = [[HHSchoolGenericView alloc] init];
    [self.forthSecView addSubview:self.passRateView];
    
    self.satisView = [[HHSchoolGenericView alloc] init];
    [self.forthSecView addSubview:self.satisView];
    
    self.coachCountView = [[HHSchoolGenericView alloc] init];
    [self.forthSecView addSubview:self.coachCountView];
    
    self.desTitleLabel = [[UILabel alloc] init];
    self.desTitleLabel.textColor = [UIColor HHTextDarkGray];
    self.desTitleLabel.text = @"驾校简介";
    self.desTitleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.fifthSecView addSubview:self.desTitleLabel];
    
    self.desLabel = [[UILabel alloc] init];
    self.desLabel.numberOfLines = 2;
    [self.fifthSecView addSubview:self.desLabel];
    
    self.showMoreLessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showMoreLessButton setTitle:@"更多" forState:UIControlStateNormal];
    [self.showMoreLessButton setTitleColor:[UIColor HHLinkBlue] forState:UIControlStateNormal];
    self.showMoreLessButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.showMoreLessButton addTarget:self action:@selector(showMoreLessButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.fifthSecView addSubview:self.showMoreLessButton];
    
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.firstSecView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.secSecView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstSecView.bottom);
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.right.equalTo(self.contentView.right);
        make.height.mas_equalTo(35.0f);
    }];
    
    [self.thirdSecView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secSecView.bottom);
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.right.equalTo(self.contentView.right);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.forthSecView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdSecView.bottom);
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.right.equalTo(self.contentView.right);
        make.height.mas_equalTo(35.0f);
    }];
    
    [self.fifthSecView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forthSecView.bottom);
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.height.mas_equalTo(100.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstSecView.left).offset(10.0f);
        make.centerY.equalTo(self.firstSecView.centerY);
    }];
    
    [self.consultNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.firstSecView.right).offset(-15.0f);
        make.bottom.equalTo(self.nameLabel.bottom);
    }];
    
    [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secSecView.left);
        make.centerY.equalTo(self.secSecView.centerY);
    }];
    
    [self.priceNotiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.secSecView.right).offset(-15.0f);
        make.centerY.equalTo(self.secSecView.centerY);
    }];
    
    [self.bellView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceNotiLabel.left).offset(-5.0f);
        make.centerY.equalTo(self.secSecView.centerY);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(20.0f);
    }];
    
    [self.fieldLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thirdSecView.left);
        make.centerY.equalTo(self.thirdSecView.centerY);
    }];
    
    [self.checkFieldLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.thirdSecView.right).offset(-15.0f);
        make.centerY.equalTo(self.thirdSecView.centerY);
    }];
    
    [self.passRateView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.forthSecView.left);
        make.width.equalTo(self.forthSecView.width).multipliedBy(1.0f/3.0f);
        make.height.equalTo(self.forthSecView.height);
        make.top.equalTo(self.forthSecView.top);
    }];
    
    [self.satisView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passRateView.right);
        make.width.equalTo(self.forthSecView.width).multipliedBy(1.0f/3.0f);
        make.height.equalTo(self.forthSecView.height);
        make.top.equalTo(self.forthSecView.top);
    }];
    
    
    [self.coachCountView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.satisView.right);
        make.width.equalTo(self.forthSecView.width).multipliedBy(1.0f/3.0f);
        make.height.equalTo(self.forthSecView.height);
        make.top.equalTo(self.forthSecView.top);
    }];
    
    [self.desTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fifthSecView.left).offset(15.0f);
        make.top.equalTo(self.fifthSecView.top).offset(10.0f);
    }];
    
    [self.desLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desTitleLabel.left);
        make.width.equalTo(self.fifthSecView.width).offset(-30.0f);
        make.top.equalTo(self.desTitleLabel.bottom).offset(10.0f);
        make.bottom.equalTo(self.fifthSecView.bottom).offset(-20.0f);
    }];
    
    [self.showMoreLessButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.desLabel.right);
        make.bottom.equalTo(self.fifthSecView.bottom);
    }];
}

- (UIView *)buildSecViewWithBotLine:(BOOL)showBotLine {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    if (showBotLine) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor HHLightLineGray];
        [view addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.left);
            make.width.equalTo(view.width);
            make.bottom.equalTo(view.bottom);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    return view;
}

- (void)setupCellWithSchool:(HHDrivingSchool *)school {
    self.school = school;
    self.nameLabel.text = school.schoolName;
    self.consultNumLabel.attributedText = [self generateConsultNumString];
    self.priceLabel.attributedText = [self generatePriceString];
    self.fieldLabel.attributedText = [self generateFieldString];
    
    [self.passRateView setupViewWithLeftText:@"通过率:" rightText:school.passRate];
    [self.satisView setupViewWithLeftText:@"满意度:" rightText:@"100%"];
    [self.coachCountView setupViewWithLeftText:@"教练人数:" rightText:[school.coachCount stringValue]];
    self.desLabel.attributedText = [self buildDesString];
    if ([self isTruncated]) {
        self.showMoreLessButton.hidden = NO;
        if (self.expanded) {
            [self.showMoreLessButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            [self.showMoreLessButton setTitle:@"更多" forState:UIControlStateNormal];
        }
    } else {
        self.showMoreLessButton.hidden = YES;
    }

}

- (NSMutableAttributedString *)generateConsultNumString {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"已有" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray]}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[self.school.consultCount stringValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"人咨询" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray]}];
    
    [string appendAttributedString:string2];
    [string appendAttributedString:string3];
    return string;
}

- (NSMutableAttributedString *)generatePriceString {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"班别费用:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray]}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[self.school.lowestPrice generateMoneyString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHDarkOrange]}];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"起" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    
    [string appendAttributedString:string2];
    [string appendAttributedString:string3];
    return string;
}

- (NSMutableAttributedString *)generateFieldString {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"服务范围: 共有" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray]}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[self.school.fieldCount stringValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHDarkOrange]}];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"个训练场地" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray]}];
    
    [string appendAttributedString:string2];
    [string appendAttributedString:string3];
    return string;
}

- (NSMutableAttributedString *)buildDesString {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentNatural;
    paraStyle.lineSpacing = 7.0;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.school.bio attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSParagraphStyleAttributeName:paraStyle}];
    
    return attrString;
}

- (void)showMoreLessButtonTapped {
    self.expanded = !self.expanded;
    if (self.expanded) {
        [self.fifthSecView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.forthSecView.bottom);
            make.left.equalTo(self.contentView.left);
            make.right.equalTo(self.contentView.right);
            CGRect rect = [self.desLabel.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.bounds)-30.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
            make.height.mas_equalTo(CGRectGetHeight(rect) + 60.0f);
        }];
        
        self.desLabel.numberOfLines = 0;
        self.desLabel.attributedText = [self buildDesString];
    } else {
        [self.fifthSecView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.forthSecView.bottom);
            make.left.equalTo(self.contentView.left);
            make.right.equalTo(self.contentView.right);
            make.height.mas_equalTo(100.0f);
        }];
        
        self.desLabel.numberOfLines = 2;
        self.desLabel.attributedText = [self buildDesString];
    }
   
    if (self.showMoreLessBlock) {
        self.showMoreLessBlock(self.expanded);
    }

}

- (void)showFieldsMap {
    if (self.fieldBlock) {
        self.fieldBlock();
    }
}

- (void)showGetNumView {
    if (self.priceNotifBlock) {
        self.priceNotifBlock();
    }
}

- (BOOL)isTruncated{
    CGRect textRect = [[self buildDesString] boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-30.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    if (CGRectGetHeight(textRect) > 22.0f) {
        return YES;
    }
    return NO;
}



@end
