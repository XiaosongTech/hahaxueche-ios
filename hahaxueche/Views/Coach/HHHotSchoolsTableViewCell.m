//
//  HHHotSchoolsTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 03/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHHotSchoolsTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHHotSchoolsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor HHLightBackgroudGray];
        [self initSubviews];
    }
    return  self;
}

- (void)initSubviews {
    
    self.titleContainerView = [[UIView alloc] init];
    self.titleContainerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleContainerView];
    
    self.botContainerView = [[UIView alloc] init];
    self.botContainerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.botContainerView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.mas_equalTo(50.0f);
        make.top.equalTo(self.contentView.top).offset(10.0f);
    }];
    
    [self.botContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.bottom.equalTo(self.contentView.bottom).offset(-10.0f);
        make.top.equalTo(self.titleContainerView.bottom);
    }];
}

@end
