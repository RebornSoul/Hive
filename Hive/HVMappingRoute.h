//
//  HVMappingRoute.h
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HVObjectMapping;

@interface HVMappingRoute : NSObject

@property (nonatomic, assign, readonly) Class targetClass;
@property (nonatomic, strong, readonly) NSString *rootPath;
@property (nonatomic, strong, readonly) NSArray *mappingStack;

+ (instancetype) routeForClass:(Class)aClass rootPath:(NSString *)rootPath;

- (void) addObjectMapping:(HVObjectMapping *)objectMapping;

@end
