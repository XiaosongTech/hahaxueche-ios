//
//  HHCoachTagView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachTagView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCoachTagView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.0f;
        self.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
        self.layer.borderColor = [UIColor HHOrange].CGColor;
        
        self.dot = [[UIView alloc] init];
        self.dot.layer.masksToBounds = YES;
        self.dot.layer.cornerRadius = 2.0f;
        self.dot.backgroundColor = [UIColor HHOrange];
        [self addSubview:self.dot];
        
        [self.dot makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(5.0f);
            make.centerY.equalTo(self.centerY);
            make.width.mas_equalTo(4.0f);
            make.height.mas_equalTo(4.0f);
        }];
        
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dot.right).offset(4.0f);
            make.centerY.equalTo(self.centerY);
        }];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:rec];
        
    }
    return self;
}

- (void)setupWithDrivingSchool:(HHDrivingSchool *)school {
    self.label.attributedText = [self generateAttrString:school.schoolName];
    self.school = school;
}

- (NSMutableAttributedString *)generateAttrString:(NSString *)title {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"arrow_map_school"];
    textAttachment.bounds = CGRectMake(2.0f, -1.5f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString appendAttributedString:attrStringWithImage];
    return attributedString;
    

}

- (void)viewTapped {
    if (self.tapAction) {
        self.tapAction(self.school);
    }
}

@end
