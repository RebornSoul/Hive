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
#import "Media.h"

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

+ (void) performUserMappingWithData:(NSData *)rawData
                     withCompletion:(void(^)(User *result))completionBlock
                            failure:(void(^)(NSError *error))failureBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *jsonParsingError;
        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:rawData options:0 error:&jsonParsingError];
        
        if (jsonParsingError) {
            if (failureBlock) failureBlock (jsonParsingError);
        } else {
            User *mappedUser = [DumpMapper mapUserNode:userData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) completionBlock (mappedUser);
            });
        }
    });

}

+ (Tweet *) mapTweetNode:(id)node {
    Tweet *tw = [Tweet new];
    NSDateFormatter *tweetDF = [[NSDateFormatter alloc] init];
    [tweetDF setDateFormat:@"eee MMM dd HH:mm:ss ZZ yyyy"];
    [tweetDF setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *dateString = node[@"created_at"];
    tw.createdAt = [tweetDF dateFromString:dateString];
    tw.text = node[@"text"];
    tw.idStr = node[@"id_str"];
    tw.retweetCount = [node[@"retweet_count"] integerValue];
    tw.favoriteCount = [node[@"favorite_count"] integerValue];
    tw.favorited = [node[@"favorited"] boolValue];
    tw.retweeted = [node[@"retweeted"] boolValue];
    User *user = [DumpMapper mapUserNode:node[@"user"]];
    tw.user = user;
    NSDictionary *entities = node[@"entities"];
    NSArray *mediaNodes = entities[@"media"];
    if (mediaNodes) {
        NSMutableArray *temp = [NSMutableArray new];
        for (id mediaNode in mediaNodes) {
            Media *media = [DumpMapper mapMediaNode:mediaNode];
            [temp addObject:media];
        }
        tw.media = [NSArray arrayWithArray:temp];
    }

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

+ (Media *) mapMediaNode:(id)node {
    Media *m = [Media new];
    m.idStr = node[@"id_str"];
    m.type = node[@"type"];
    m.mediaUrl = node[@"media_url"];
    m.displayUrl = node[@"display_url"];
    return m;
}

@end
