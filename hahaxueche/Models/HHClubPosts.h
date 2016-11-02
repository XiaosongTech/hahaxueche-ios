//
//  HHClubPosts.h
//  hahaxueche
//
//  Created by Zixiao Wang on 02/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHClubPosts : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *posts;
@property (nonatomic, copy) NSString *nextPage;
@property (nonatomic, copy) NSString *prePage;

@end
