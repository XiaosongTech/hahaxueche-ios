//
//  HHCoachDetailCommentsCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachDetailCommentsCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHCoachReviewView.h"

@implementation HHCoachDetailCommentsCell

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
    self.topBackgroudView = [[UIView alloc] init];
    self.topBackgroudView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topBackgroudView];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.topBackgroudView addSubview:self.titleLabel];
    
    self.aveRatingView = [[HHStarRatingView alloc] initWithInteraction:NO];
    [self.topBackgroudView addSubview:self.aveRatingView];
    
    self.aveRatingLabel = [[UILabel alloc] init];
    self.aveRatingLabel.textColor = [UIColor HHOrange];
    self.aveRatingLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.topBackgroudView addSubview:self.aveRatingLabel];
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [UIColor HHLightLineGray];
    [self.topBackgroudView addSubview:self.topLine];
    
    self.botBackgroudView = [[UIView alloc] init];
    self.botBackgroudView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.botBackgroudView];
    
    self.botLine = [[UIView alloc] init];
    self.botLine.backgroundColor = [UIColor HHLightLineGray];
    [self.botBackgroudView addSubview:self.botLine];
    
    self.botButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.botButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.botButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
    [self.botButton addTarget:self action:@selector(botButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.botButton];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(botButtonTapped)];
    [self addGestureRecognizer:recognizer];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topBackgroudView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.top.equalTo(self.contentView.top).offset(15.0f);
        make.height.mas_equalTo(50.0f);
        make.width.equalTo(self.contentView.width);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBackgroudView.left).offset(20.0f);
        make.centerY.equalTo(self.topBackgroudView.centerY);
    }];
    
    [self.aveRatingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topBackgroudView.right).offset(-20.0f);
        make.centerY.equalTo(self.topBackgroudView.centerY);

    }];
    
    [self.aveRatingView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.aveRatingLabel.left).offset(-3.0f);
        make.centerY.equalTo(self.topBackgroudView.centerY);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBackgroudView.left);
        make.bottom.equalTo(self.topBackgroudView.bottom);
        make.width.equalTo(self.topBackgroudView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.botBackgroudView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.bottom.equalTo(self.contentView.bottom).offset(-15.0f);
        make.height.mas_equalTo(50.0f);
        make.width.equalTo(self.contentView.width);
    }];
    
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botBackgroudView.left);
        make.top.equalTo(self.botBackgroudView.top);
        make.width.equalTo(self.botBackgroudView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.botButton makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.botBackgroudView);
        make.width.equalTo(self.botBackgroudView.width);
        make.height.equalTo(self.botBackgroudView.height);
    }];
}

- (void)setupCellWithCoach:(HHCoach *)coach reviews:(NSArray *)reviews {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 学员评价 (%@)", [coach.reviewCount stringValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ic_coachmsg_pingjia"];
    textAttachment.bounds = CGRectMake(0, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    self.titleLabel.attributedText = attributedString;
    
    
    self.aveRatingView.value = [coach.averageRating floatValue];
    self.aveRatingLabel.text = [NSString stringWithFormat:@"%.1f分",[coach.averageRating floatValue]];

    
    if (![reviews count]) {
        [self.botButton setTitle:[NSString stringWithFormat:@"%@教练目前还没有评价", coach.name] forState:UIControlStateNormal];
        [self.botButton setTitleColor:[UIColor HHLightTextGray] forState:UIControlStateNormal];
        self.botButton.enabled = NO;
        self.botLine.hidden = YES;
    } else {
        [self.botButton setTitle:@"点击查看全部" forState:UIControlStateNormal];
        [self.botButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        self.botButton.enabled = YES;
        self.botLine.hidden = NO;
        [self addReviewCellsWithReviews:reviews];
    }
}

- (void)addReviewCellsWithReviews:(NSArray *)reviews {
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = MIN(reviews.count, 3);
    for (int i = 0; i < count; i++) {
        HHCoachReviewView *view = [[HHCoachReviewView alloc] init];
        [view setupViewWithReview:reviews[i]];
        [self.contentView addSubview:view];
        [array addObject:view];
        
        if (i == count - 1) {
            view.botLine.hidden = YES;
        }
        
        if (i == 0) {
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topBackgroudView.bottom);
                make.left.equalTo(self.contentView.left);
                make.width.equalTo(self.contentView.width);
                make.height.mas_equalTo(90.0f);
            }];
        } else {
            HHCoachReviewView *preView = array[i - 1];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(preView.bottom);
                make.left.equalTo(self.contentView.left);
                make.width.equalTo(self.contentView.width);
                make.height.mas_equalTo(90.0f);
            }];
        }
    }

}

- (void)botButtonTapped {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end
