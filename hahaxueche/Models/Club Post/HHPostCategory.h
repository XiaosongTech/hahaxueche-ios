//
//  HHPostCategory.h
//  hahaxueche
//
//  Created by Zixiao Wang on 02/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHPostCategory : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, copy) NSString *name;

@end
