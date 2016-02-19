//
//  HHMyPageLogoutCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageLogoutCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHMyPageCoachCell.h"

@implementation HHMyPageLogoutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor HHBackgroundGary];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"退出账号" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor HHCancelRed] forState:UIControlStateNormal];;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.height.equalTo(self.contentView.height).offset(-2.0 * kTopPadding);
            make.width.equalTo(self.contentView.width);
        }];
    }
    return self;
}

- (void)buttonTapped {
    
}

@end
