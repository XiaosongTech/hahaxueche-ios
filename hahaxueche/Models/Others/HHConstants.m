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

@implementation HHConstants

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cities": @"cities",
             @"fields": @"fields",
             @"loginBanners": @"new_login_banners",
             @"homePageBanners": @"new_home_page_banners",
             @"notifications": @"banner_highlights",
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


@end
