//
//  DumpMapper.h
//  Hive
//
//  Created by Yury Nechaev on 27.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface DumpMapper : NSObject

+ (void) performFeedMappingWithData:(NSData *)rawData
                     withCompletion:(void(^)(NSArray *result))completionBlock
                            failure:(void(^)(NSError *error))failureBlock;

+ (void) performUserMappingWithData:(NSData *)rawData
                     withCompletion:(void(^)(User *result))completionBlock
                            failure:(void(^)(NSError *error))failureBlock;

@end
