//
//  HHSession.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHSession : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *accessToken;

@end
