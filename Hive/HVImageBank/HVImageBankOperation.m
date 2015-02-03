//
//  HVImageBankOperation.m
//  Hive
//
//  Created by Yury Nechaev on 03.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "HVImageBankOperation.h"

static NSString * const HVImageBankErrorDomain = @"com.HVImageBank.Error";

@interface HVImageBankOperation () <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation HVImageBankOperation

+ (instancetype) operationWithImageURL:(NSURL *)url {
    HVImageBankOperation *operation = [[HVImageBankOperation alloc] init];
    operation.imageUrl = url;
    return operation;
}

- (void) start {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.imageUrl];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger httpStatusCode = httpResponse.statusCode;
        switch (httpStatusCode) {
            case 200: {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *image = nil;
                    if(data.length) {
                        @try {
                            image = [[UIImage alloc] initWithData:data];
                        }
                        @catch(NSException *exception) {
                            NSLog(@"%s [Line %d] %@", __PRETTY_FUNCTION__, __LINE__, exception);
                        }
                    }
                    
                    if(_imageCompletionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _imageCompletionBlock(image, error);
                        });
                    }
                });
            } break;
                
            default: {
                if(httpStatusCode >= 400 && httpStatusCode <= 499) {
                    //out of retries or got a 400 level error so don't retry
                    if(_imageCompletionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSError *imageLoadError = [NSError errorWithDomain:HVImageBankErrorDomain
                                                                          code:httpStatusCode
                                                                      userInfo:@{NSLocalizedDescriptionKey:@"Error occured while loading image"}];
                            _imageCompletionBlock(nil, imageLoadError);
                        });
                    }
                }
            }
        }
    }];
    [task resume];
}

@end
