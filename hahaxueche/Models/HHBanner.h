//
//  HHBanner.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/23/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface HHBanner : AVObject <AVSubclassing>

@property (nonatomic, copy) NSString *bannerImageURL;
@property (nonatomic, copy) NSString *detailImageURL;

@end
