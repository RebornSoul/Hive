//
//  DataManager.h
//  Hive
//
//  Created by Yury Nechaev on 25.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACAccount;

@interface DataManager : NSObject

+ (void) postStatusUpdate:(NSString *)status
                inAccount:(ACAccount *)account
         inReplyToTweetId:(NSString *)tweetId
           withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                  failure:(void(^)(NSError *error))failureBlock;

+ (void) getCurrentUserInAccount:(ACAccount *)account
                  withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                         failure:(void(^)(NSError *error))failureBlock;

+ (void) retrieveAccountFeed:(ACAccount *)account
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock;

+ (void) retrieveAccountFeed:(ACAccount *)account
                     sinceId:(NSString *)sinceId
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock;

+ (void) retrieveAccountFeed:(ACAccount *)account
                       maxId:(NSString *)maxId
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock;

+ (void) postFavoriteId:(NSString *)tweetId
              inAccount:(ACAccount *)account
         withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                failure:(void(^)(NSError *error))failureBlock;

+ (void) destroyFavoriteId:(NSString *)tweetId
                 inAccount:(ACAccount *)account
            withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                   failure:(void(^)(NSError *error))failureBlock;

+ (void) postRetweetForId:(NSString *)tweetId
                inAccount:(ACAccount *)account
           withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                  failure:(void(^)(NSError *error))failureBlock;
@end
