//
//  HHNotification.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHNotification : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *avaURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *highlights;


@end
