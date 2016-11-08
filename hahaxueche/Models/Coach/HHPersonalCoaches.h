//
//  HHPersonalCoaches.h
//  hahaxueche
//
//  Created by Zixiao Wang on 25/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHPersonalCoaches : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *coaches;
@property (nonatomic, copy) NSString *nextPage;
@property (nonatomic, copy) NSString *prePage;

@end
