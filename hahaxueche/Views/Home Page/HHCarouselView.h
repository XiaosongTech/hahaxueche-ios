//
//  HHCarouselView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 14/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MoreButtonCompletion)();
typedef void (^ItemCompletion)(NSInteger index);

typedef NS_ENUM(NSInteger, CarouselType) {
    CarouselTypeCoach, // 教练
    CarouselTypeDrivingSchool, //驾校
};

@interface HHCarouselView : UIView

- (instancetype)initWithType:(CarouselType)type data:(NSArray *)data;
- (void)updateData:(NSArray *)data type:(CarouselType)type;


@property (nonatomic, strong) NSMutableArray *schoolViewsArray;
@property (nonatomic, strong) NSMutableArray *coachViewsArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MoreButtonCompletion buttonAction;
@property (nonatomic, strong) ItemCompletion itemAction;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *loadingLabel;

@end
