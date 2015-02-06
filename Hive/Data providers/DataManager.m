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
#define CURRENT_USER_PATH @"https://api.twitter.com/1.1/account/verify_credentials.json"

@implementation DataManager

+ (void) retrieveAccountFeed:(ACAccount *)account
                     sinceId:(NSString *)sinceId
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"true" forKey:@"stall_warnings"];
    [params setObject:sinceId forKey:@"since_id"];
    [params setObject:@"3" forKey:@"count"];

    
    [[self class] retrieveAccountFeed:account
                               params:params
                       withCompletion:completionBlock failure:failureBlock];
}

+ (void) retrieveAccountFeed:(ACAccount *)account
                       maxId:(NSString *)maxId
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock {
    
    NSInteger maxIdInt = [maxId integerValue];
    maxIdInt -= 1; // We need to decrement it in order to avoid from including last tweet in response.
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"true" forKey:@"stall_warnings"];
    [params setObject:[NSString stringWithFormat:@"%li", (long)maxIdInt] forKey:@"max_id"];
    [params setObject:@"3" forKey:@"count"];
    
    [[self class] retrieveAccountFeed:account
                               params:params
                       withCompletion:completionBlock failure:failureBlock];
}

+ (void) retrieveAccountFeed:(ACAccount *)account
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"true" forKey:@"stall_warnings"];
    [params setObject:@"3" forKey:@"count"];

    
    [[self class] retrieveAccountFeed:account
                               params:params
                       withCompletion:completionBlock failure:failureBlock];
}

+ (void) retrieveAccountFeed:(ACAccount *)account
                      params:(NSDictionary *)params
              withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                     failure:(void(^)(NSError *error))failureBlock {
    
    NSURL *url = [NSURL URLWithString:TWITTER_PATH];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    
    [request setAccount:account];
    [DataManager performRequest:request withURL:url withCompletion:completionBlock failure:failureBlock];
}


+ (void) getCurrentUserInAccount:(ACAccount *)account
                  withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                         failure:(void(^)(NSError *error))failureBlock {
    NSURL *url = [NSURL URLWithString:CURRENT_USER_PATH];
    NSDictionary *params = @{@"skip_status": @"true"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    
    [request setAccount:account];
    [DataManager performRequest:request withURL:url withCompletion:completionBlock failure:failureBlock];
}

+ (void) performRequest:(SLRequest *)request
                withURL:(NSURL *)url
         withCompletion:(void(^)(NSData *responseData, NSHTTPURLResponse *urlResponse))completionBlock
                failure:(void(^)(NSError *error))failureBlock {
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (urlResponse.statusCode >= 400 && urlResponse.statusCode <= 499) {
             NSError *jsonError;
             NSDictionary *errorSerialization = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
             NSArray *errors = errorSerialization[@"errors"];
             NSString *errorText = [NSString stringWithFormat:@"Http code %li: %@", (long)urlResponse.statusCode, [DataManager compoundStrongFromTwitterErrors:errors]];
             NSError *statusError = [NSError errorWithDomain:HVDataManagerErrorDomain
                                                        code:urlResponse.statusCode
                                                    userInfo:@{NSLocalizedDescriptionKey:errorText}];
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (failureBlock) failureBlock (statusError);
             });
         } else {
             if (error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (failureBlock) failureBlock (error);
                 });
             } else {
                 if (completionBlock) completionBlock (responseData, urlResponse);
             }
             
         }
     }];
}

+ (NSString *) compoundStrongFromTwitterErrors:(NSArray *)twitterErrors {
    NSMutableString *returnedValue = [NSMutableString new];
    for (NSDictionary *error in twitterErrors) {
        NSString *errorString = [NSString stringWithFormat:@"\n%i - %@", [error[@"code"] intValue], error[@"message"]];
        [returnedValue appendString:errorString];
    }
    return [NSString stringWithString:returnedValue];
}


@end
