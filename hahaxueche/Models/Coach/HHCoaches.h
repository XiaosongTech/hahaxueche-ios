//
//  HHCoaches.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCoaches : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *coaches;
@property (nonatomic, copy) NSString *nextPage;
@property (nonatomic, copy) NSString *prePage;

@end
