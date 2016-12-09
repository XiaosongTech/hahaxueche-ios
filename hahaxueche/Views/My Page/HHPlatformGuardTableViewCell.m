//
//  HHPlatformGuardTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 09/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPlatformGuardTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHPlatformGuardTableViewCell

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
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.attributedText = [self generateAttrStringWithText:@"平台保障" image:[UIImage imageNamed:@"ic_pingtaibaozhang"]];
    [self.mainView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.top).offset(21.0f);
        make.left.equalTo(self.mainView).offset(20.0f);
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
    UITapGestureRecognizer *recgonizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.botView addGestureRecognizer:recgonizer];
    [self.mainView addSubview:self.botView];
    [self.botView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.bottom);
        make.left.equalTo(self.mainView.left);
        make.width.equalTo(self.mainView.width);
        make.bottom.equalTo(self.mainView.bottom);
        
    }];
    
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
    [self.botView addSubview:self.arrowView];
    [self.arrowView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.centerY);
        make.right.equalTo(self.mainView.right).offset(-18.0f);
    }];

    
    self.botLeftView = [[UIView alloc] init];
    [self.botView addSubview:self.botLeftView];
    [self.botLeftView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView.left).offset(20.0f);
        make.top.equalTo(self.botView.top);
        make.right.equalTo(self.arrowView.left);
        make.height.equalTo(self.botView.height);
    }];
    
    
    
}

- (void)setupCellWithCoach:(HHCoach *)coach {
    for (int i = 0; i < 5; i++) {
        NSString *title;
        UIImage *image;
        UIView *view;
        switch (i) {
            case 0: {
                title = @"教练认证";
                image = [UIImage imageNamed:@"ic_jiaolianrenzheng"];
                if ([coach isGoldenCoach]) {
                    title = @"金牌教练";
                    image = [UIImage imageNamed:@"ic_jinpaijiaolian"];
                }
                view = [self guardItemViewWithTitle:title image:image];
                [self.botLeftView addSubview:view];
            } break;
                
            case 1: {
                title = @"车辆保险";
                image = [UIImage imageNamed:@"ic_cheliangbaoxian"];
                view = [self guardItemViewWithTitle:title image:image];
                [self.botLeftView addSubview:view];
                
            } break;
                
            case 2: {
                title = @"免费试学";
                image = [UIImage imageNamed:@"ic_mianfeishixue"];
                if ([coach.hasDeposit boolValue]) {
                    title = @"先行赔付";
                    image = [UIImage imageNamed:@"ic_xianxiangpeifu"];
                }
                view = [self guardItemViewWithTitle:title image:image];
                [self.botLeftView addSubview:view];
                
            } break;
                
            case 3: {
                title = @"分段打款";
                image = [UIImage imageNamed:@"ic_fenduandakuan"];
                view = [self guardItemViewWithTitle:title image:image];
                [self.botLeftView addSubview:view];
                
            } break;
                
            case 4: {
                title = @"分期付款";
                image = [UIImage imageNamed:@"ic_fenqidakuan"];
                view = [self guardItemViewWithTitle:title image:image];
                [self.botLeftView addSubview:view];
            } break;
            default:
                break;
        }
        
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.botLeftView.centerX).multipliedBy((i*2 + 1)/5.0f);
            make.centerY.equalTo(self.botLeftView.centerY);
            make.width.equalTo(self.botLeftView).multipliedBy(1.0f/5.0f);
            make.height.equalTo(self.botLeftView.height);
        }];
        
    }
    
}

- (UIView *)guardItemViewWithTitle:(NSString *)title image:(UIImage *)image {
    UIView *view = [[UIView alloc] init];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    [view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.centerY).offset(3.0f);
        make.centerX.equalTo(view.centerX);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor HHLightTextGray];
    label.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.bottom).offset(5.0f);
        make.centerX.equalTo(view.centerX);
    }];
    return view;
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

- (void)viewTapped {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
