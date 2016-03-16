//
//  HHMyCoachPartnerCoachCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyCoachPartnerCoachCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHMyPageCoachCell.h"

@implementation HHMyCoachPartnerCoachCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor HHBackgroundGary];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.coachListView = [[HHCollaborateCoachesView alloc] init];
    [self.contentView addSubview:self.coachListView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.coachListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(kTopPadding);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}

- (void)setupWithCoachList:(NSArray *)coachList {
     [self.coachListView setupCellWithCoaches:coachList];
}


@end
