//
//  HHConstants.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHConstants.h"
#import "HHCity.h"
#import "HHField.h"
#import "HHNotification.h"
#import "HHBanner.h"
#import "HHBank.h"
#import "HHPostCategory.h"

@implementation HHConstants

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cities": @"cities",
             @"fields": @"fields",
             @"loginBanners": @"new_login_banners",
             @"homePageBanners": @"new_home_page_banners",
             @"notifications": @"banner_highlights",
             @"banks": @"banks",
             @"drivingSchoolCount": @"statistics.driving_school_count",
             @"paidStudentCount": @"statistics.paid_student_count",
             @"coachCount": @"statistics.coach_count",
             @"postCategory": @"article_categories",
             };
}

+ (NSValueTransformer *)citiesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCity class]];
}

+ (NSValueTransformer *)fieldsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHField class]];
}

+ (NSValueTransformer *)notificationsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHNotification class]];
}

+ (NSValueTransformer *)homePageBannersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHBanner class]];
}

+ (NSValueTransformer *)loginBannersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHBanner class]];
}

+ (NSValueTransformer *)banksJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHBank class]];
}

+ (NSValueTransformer *)postCategoryJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHPostCategory class]];
}

@end
