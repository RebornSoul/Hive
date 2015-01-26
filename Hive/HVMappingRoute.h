//
//  HVMappingRoute.h
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HVMappingRoute : NSObject

+ (instancetype) routeForClass:(Class)class withMap:(NSDictionary *)routeMap;

@end
