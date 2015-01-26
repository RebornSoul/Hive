//
//  DataManager.m
//  Hive
//
//  Created by Yury Nechaev on 25.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "DataManager.h"
#import <Social/Social.h>

#define TWITTER_PATH @"https://userstream.twitter.com/1.1/user.json"

@implementation DataManager

+ (void) retrieveAccountFeed:(ACAccount *)account
              withCompletion:(void(^)(NSData *responseData))completionBlock
                     failure:(void(^)(NSError *error))failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"true" forKey:@"stall_warnings"];
    
    //  The endpoint that we wish to call
    NSURL *url = [NSURL URLWithString:TWITTER_PATH];
    
    //  Build the request with our parameter
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                          
    
    // Attach the account object to this request
    [request setAccount:account];
    
    // make the connection, ensuring that it is made on the main runloop
    
    [request performRequestWithHandler:^(NSData *responseData,
                                             NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (error) {
             if (failureBlock) failureBlock (error);
         } else {
             if (completionBlock) completionBlock (responseData);
         }
     }];
}

@end
