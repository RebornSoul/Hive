//
//  DumpMapper.m
//  Hive
//
//  Created by Yury Nechaev on 27.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "DumpMapper.h"
#import "Tweet.h"
#import "User.h"

@implementation DumpMapper

+ (void) performFeedMappingWithData:(NSData *)rawData
                     withCompletion:(void(^)(NSArray *result))completionBlock
                            failure:(void(^)(NSError *error))failureBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *jsonParsingError;
        NSArray *userTimeline = [NSJSONSerialization JSONObjectWithData:rawData options:0 error:&jsonParsingError];
        
        NSMutableArray *returnedArray = [NSMutableArray new];
        
        if (jsonParsingError) {
            if (failureBlock) failureBlock (jsonParsingError);
        } else {
            for (id node in userTimeline) {
                Tweet *mappedTweet = [DumpMapper mapTweetNode:node];
                if (mappedTweet) [returnedArray addObject:mappedTweet];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) completionBlock ([NSArray arrayWithArray:returnedArray]);
            });
        }
    });
}

+ (Tweet *) mapTweetNode:(id)node {
    Tweet *tw = [Tweet new];
    NSDateFormatter *tweetDF = [[NSDateFormatter alloc] init];
    [tweetDF setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    tw.createdAt = [tweetDF dateFromString:node[@"created_at"]];
    tw.text = node[@"text"];
    tw.idStr = node[@"id_str"];
    tw.retweetCount = [node[@"retweet_count"] integerValue];
    tw.favoriteCount = [node[@"favorite_count"] integerValue];
    tw.favorited = [node[@"favorited"] boolValue];
    tw.retweeted = [node[@"retweeted"] boolValue];
    User *user = [DumpMapper mapUserNode:node[@"user"]];
    tw.user = user;
    return tw;
}

+ (User *) mapUserNode:(id)node {
    User *user = [User new];
    user.name = node[@"name"];
    user.idStr = node[@"id_str"];
    user.screenName = node[@"screen_name"];
    user.location = node[@"location"];
    user.profileImageUrl = node[@"profile_image_url"];
    return user;
}

@end
