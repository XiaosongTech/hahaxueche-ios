//
//  HHClubPost.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHClubPost : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, copy) NSNumber *isPopular;
@property (nonatomic, copy) NSString *coverImg;
@property (nonatomic, copy) NSNumber *category;
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) NSNumber *viewCount;
@property (nonatomic, copy) NSNumber *likeCount;
@property (nonatomic, copy) NSNumber *liked;
@property (nonatomic, copy) NSArray *comments;

- (NSString *)getCategoryName;


@end
