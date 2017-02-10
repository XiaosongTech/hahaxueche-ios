//
//  HHClubPostService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 02/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHAPIClient.h"
#import "APIPaths.h"
#import "HHStudent.h"
#import "HHConstants.h"
#import "HHClubPosts.h"
#import "HHClubPost.h"


typedef void (^HHPostsCompletion)(HHClubPosts *posts, NSError *error);
typedef void (^HHPostCompletion)(HHClubPost *post, NSError *error);

@interface HHClubPostService : NSObject

+ (instancetype)sharedInstance;

/**
 Get posts
 @param completion The completion block to execute on completion
 */
- (void)fetchPostsWithCategor:(NSNumber *)category popular:(NSNumber *)popular completion:(HHPostsCompletion)completion;

/**
 Get more posts with url
 @param url The next page URL
 @param completion The completion block to execute on completion
 */
- (void)fetchMorePostsWithURL:(NSString *)url completion:(HHPostsCompletion)completion;

/**
 Like/unlike a post
 @param like
 @param completion The completion block to execute on completion
 */
- (void)likeOrUnlikePostWithId:(NSString *)postId like:(NSNumber *)like completion:(HHPostCompletion)completion;

/**
 Make a comment
 @param postId The article id
 @param content Comment content
 @param completion The completion block to execute on completion
 */
- (void)commentPostWithId:(NSString *)postId content:(NSString *)content completion:(HHPostCompletion)completion;


/**
 Fetch head line
 @param completion The completion block to execute on completion
 */
- (void)fetchHeadlineWithCompletion:(HHPostCompletion)completion;

/**
 Get a single post
 @param postId The id of the post
 @param completion The completion block to execute on completion
 */
- (void)getPostWithId:(NSString *)postId completion:(HHPostCompletion)completion;


@end
