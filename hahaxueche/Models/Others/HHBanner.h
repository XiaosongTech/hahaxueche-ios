//
//  HHHomepageBanner.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHBanner : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *targetURL;

@end
