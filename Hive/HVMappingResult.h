//
//  HVMappingResult.h
//  Hive
//
//  Created by Yury Nechaev on 27.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HVMappingResult : NSObject

- (id) initWithCollection:(NSArray *)collection;

- (id) firstObject;
- (id) anyObject;
- (NSArray *)array;
- (NSInteger)count;

@end
