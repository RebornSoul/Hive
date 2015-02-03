//
//  DataManager.m
//  Hive
//
//  Created by Yury Nechaev on 25.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "DataManager.h"
#import <Social/Social.h>

static NSString * const HVDataManagerErrorDomain = @"com.DataManager.Error";

#define TWITTER_PATH @"https://api.twitter.com/1.1/statuses/home_timeline.json"

@implementation DataManager

+ (void) retrieveAccountFeed:(ACAccount *)account
                     sinceId:(NSString *)sinceId
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"true" forKey:@"stall_warnings"];
    [params setObject:sinceId forKey:@"since_id"];
    
    [[self class] retrieveAccountFeed:account
                               params:params
                       withCompletion:completionBlock failure:failureBlock];
}

+ (void) retrieveAccountFeed:(ACAccount *)account
                       maxId:(NSString *)maxId
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"true" forKey:@"stall_warnings"];
    [params setObject:maxId forKey:@"max_id"];
    
    [[self class] retrieveAccountFeed:account
                               params:params
                       withCompletion:completionBlock failure:failureBlock];
}

+ (void) retrieveAccountFeed:(ACAccount *)account
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"true" forKey:@"stall_warnings"];
    
    [[self class] retrieveAccountFeed:account
                               params:params
                       withCompletion:completionBlock failure:failureBlock];
}

+ (void) retrieveAccountFeed:(ACAccount *)account
                      params:(NSDictionary *)params
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock {
    
    //  The endpoint that we wish to call
    NSURL *url = [NSURL URLWithString:TWITTER_PATH];
    
    //  Build the request with our parameter
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    
    
    // Attach the account object to this request
    [request setAccount:account];
    
    // make the connection, ensuring that it is made on the main runloop
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (urlResponse.statusCode >= 400 && urlResponse.statusCode <= 499) {
             NSString *errorText = [NSString stringWithFormat:@"Received code %li", (long)urlResponse.statusCode];
             NSError *statusError = [NSError errorWithDomain:HVDataManagerErrorDomain
                                                        code:urlResponse.statusCode
                                                    userInfo:@{NSLocalizedDescriptionKey:errorText}];
             if (failureBlock) failureBlock (statusError);
         } else {
             if (error) {
                 if (failureBlock) failureBlock (error);
             } else {
                 if (completionBlock) completionBlock (responseData, urlResponse);
             }

         }
     }];
}

@end
