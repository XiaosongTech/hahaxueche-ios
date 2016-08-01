//
//  HHMyPageReferCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageReferCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHMyPageReferCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor HHOrange];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.text = @"我想为哈哈代言, 免费赚取代言费~";
    [self.contentView addSubview:self.titleLabel];
    
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_xiaoha"]];
    [self.contentView addSubview:self.imgView];
    
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(15.0f);
    }];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom);
        make.right.equalTo(self.contentView.right).offset(-15.0f);
    }];
}

@end
