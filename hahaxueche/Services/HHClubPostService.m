//
//  HHClubPostService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 02/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubPostService.h"
#import "HHStudentStore.h"

@implementation HHClubPostService

+ (instancetype)sharedInstance {
    static HHClubPostService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHClubPostService alloc] init];
    });
    
    return sharedInstance;
}

- (void)fetchPostsWithCategor:(NSNumber *)category popular:(NSNumber *)popular completion:(HHPostsCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIClubPosts];
    [APIClient getWithParameters:@{@"category":category, @"is_popular":popular} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHClubPosts *posts = [MTLJSONAdapter modelOfClass:[HHClubPosts class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(posts, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)fetchMorePostsWithURL:(NSString *)url completion:(HHPostsCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClient];
    [APIClient getWithURL:url completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHClubPosts *posts = [MTLJSONAdapter modelOfClass:[HHClubPosts class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(posts, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];

}

- (void)likeOrUnlikePostWithId:(NSString *)postId like:(NSNumber *)like completion:(HHPostCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIClubPostLike, [HHStudentStore sharedInstance].currentStudent.studentId, postId]];
    [APIClient postWithParameters:@{@"like":like} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHClubPost *post = [MTLJSONAdapter modelOfClass:[HHClubPost class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(post, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }

    }];
}

- (void)commentPostWithId:(NSString *)postId content:(NSString *)content completion:(HHPostCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIClubPostComment, postId]];
    [APIClient postWithParameters:@{@"student_id":[HHStudentStore sharedInstance].currentStudent.studentId, @"content":content} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHClubPost *post = [MTLJSONAdapter modelOfClass:[HHClubPost class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(post, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }

    }];
}


@end
