//
//  HVMapperManager.h
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HVObjectMapping.h"
#import "HVMappingRoute.h"
#import "HVRelationshipMapping.h"

@class HVMappingResult;

@interface HVMapperManager : NSObject

+ (HVMapperManager *)  sharedInstance;

- (void) performMappingWithRoute:(HVMappingRoute *)route forData:(NSData *)rawData
                  withCompletion:(void(^)(HVMappingResult *result))completionBlock
                         failure:(void(^)(NSError *error))failureBlock;

@end
