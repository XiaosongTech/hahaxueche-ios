//
//  HHCarouselView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 14/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHCarouselView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHHomePageDrivingSchoolView.h"
#import "HHHomePageCoachView.h"
#import "HHCoachService.h"
#import "HHStudentStore.h"

static const NSInteger count = 8;

@implementation HHCarouselView

- (instancetype)initWithType:(CarouselType)type data:(NSArray *)data {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.coachViewsArray = [NSMutableArray array];
        self.schoolViewsArray = [NSMutableArray array];
        
        UIView *titleView = [self buildTitleViewWithType:type];
        [self addSubview:titleView];
        [titleView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.top.equalTo(self.top);
            make.height.mas_equalTo(40.0f);
        }];
        
        self.scrollView = [self buildScrollViewWithType:type data:data];
        [self addSubview:self.scrollView];
        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.top.equalTo(titleView.bottom);
            make.bottom.equalTo(self.bottom).offset(-10.0f);
        }];
        
        [self updateData:data type:type];

    }
    return self;
}

- (UIView *)buildTitleViewWithType:(CarouselType)type {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *stickView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stick"]];
    [view addSubview:stickView];
    [stickView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(view.left).offset(10.0f);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor HHTextDarkGray];
    label.font = [UIFont boldSystemFontOfSize:17.0f];
    switch (type) {
        case CarouselTypeCoach: {
            label.text = @"附近教练";
        } break;
            
        case CarouselTypeDrivingSchool: {
            label.text = @"热门驾校";
        } break;
            
        default:
            break;
    }
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(stickView.right).offset(5.0f);
    }];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setAttributedTitle:[self generateAttrStringWithText:@"更多" image:[UIImage imageNamed:@"ic_morearrow"]] forState:UIControlStateNormal];
    [view addSubview:moreButton];
    [moreButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.right.equalTo(view.right).offset(-15.0f);
    }];
    
    return view;
}

- (NSAttributedString *)generateAttrStringWithText:(NSString *)text image:(UIImage *)image {
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

- (UIScrollView *)buildScrollViewWithType:(CarouselType)type data:(NSArray *)data {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.scrollEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    return scrollView;
}

- (void)updateData:(NSArray *)data type:(CarouselType)type {
    if (type == CarouselTypeCoach) {
        for(HHHomePageCoachView *view in self.coachViewsArray) {
            [view removeFromSuperview];
        }
    } else {
        for(HHHomePageDrivingSchoolView *view in self.schoolViewsArray) {
            [view removeFromSuperview];
        }
    }
    [self buildItemViewInView:self.scrollView data:data type:type];

}

- (void)buildItemViewInView:(UIScrollView *)scrollView data:(NSArray *)data type:(CarouselType)type {
    __block int i = 0;
    if (data.count <= 0) {
        if (type == CarouselTypeDrivingSchool) {
            for (int i = 0; i < count; i++) {
                [self buildSchoolItemWithIndex:i school:nil];
            }
        } else {
            for (int i = 0; i < count; i++) {
                [self buildCoachItemWithIndex:i coach:nil];
            }
        }
        
    } else {
        if (type == CarouselTypeDrivingSchool) {
            for (HHDrivingSchool *school in data) {
                if (i >= count ) {
                    break;
                }
                [self buildSchoolItemWithIndex:i school:school];
                i++;
            }
        } else {
            for (HHCoach *coach in data) {
                if (i >= count ) {
                    break;
                }
                [self buildCoachItemWithIndex:i coach:coach];
                i++;
            }
        }
        NSInteger sizeX = count * 85.0f + 10.0f;
        if (data.count < count) {
            sizeX = data.count * 85.0f + 10.0f;
        }
        scrollView.contentSize = CGSizeMake(sizeX, 90.0f);

    }
    
}

- (void)buildCoachItemWithIndex:(NSInteger)index coach:(HHCoach *)coach {
    HHHomePageCoachView *view = [[HHHomePageCoachView alloc] initWithCoach:coach];
    view.tag = index;
    [self.scrollView addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(10.0f + 85.0f*index);
        make.height.equalTo(self.scrollView.height);
        make.width.mas_equalTo(75.0f);
        make.top.equalTo(self.scrollView.top);
    }];
    [self.coachViewsArray addObject:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
    [view addGestureRecognizer:tap];
    
}

- (void)buildSchoolItemWithIndex:(NSInteger)index school:(HHDrivingSchool *)school {
    HHHomePageDrivingSchoolView *view = [[HHHomePageDrivingSchoolView alloc] initWithDrivingSchool:school];
    view.tag = index;
    [self.scrollView addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(10.0f + 85.0f*index);
        make.height.equalTo(self.scrollView.height);
        make.width.mas_equalTo(75.0f);
        make.top.equalTo(self.scrollView.top);
    }];
    [self.schoolViewsArray addObject:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
    [view addGestureRecognizer:tap];
}

- (void)moreButtonTapped {
    if (self.buttonAction) {
        self.buttonAction();
    }
}

- (void)itemTapped:(UITapGestureRecognizer *)rec {
    UIView *view = rec.view;
    if (self.itemAction) {
        self.itemAction(view.tag);
    }
}



@end
