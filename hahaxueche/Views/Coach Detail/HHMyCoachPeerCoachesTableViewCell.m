//
//  HHMyCoachPeerCoachesTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 26/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyCoachPeerCoachesTableViewCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHMyPageCoachCell.h"
#import "HHCoachCellView.h"

@implementation HHMyCoachPeerCoachesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor HHBackgroundGary];
        self.viewArray = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"合作教练"];
    [self.contentView addSubview:self.titleView];
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
}

- (void)setupWithCoach:(HHCoach *)coach {
    for (HHCoachCellView *view in self.viewArray) {
        [view removeFromSuperview];
    }
    [self.viewArray removeAllObjects];
    
    int i = 0;
    for (HHCoach *peerCoach in coach.peerCoaches) {
        HHCoachCellView *view = [[HHCoachCellView alloc] initWithCoach:peerCoach];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = i;
        [self addSubview:view];
        
        UITapGestureRecognizer *tapRecognizer =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coachViewTapped:)];
        [view addGestureRecognizer:tapRecognizer];
        if (i == 0) {
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleView.bottom);
                make.width.equalTo(self.width);
                make.left.equalTo(self.left);
                make.height.mas_equalTo(70.0f);
            }];
        } else {
            HHCoachCellView *preView = self.viewArray[i-1];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(preView.bottom);
                make.width.equalTo(self.width);
                make.left.equalTo(self.left);
                make.height.mas_equalTo(70.0f);
            }];
        }
        [self.viewArray addObject:view];
        
        i++;
    }

}

- (void)coachViewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    if (self.coachAction) {
        self.coachAction(view.tag);
    }
}

@end
