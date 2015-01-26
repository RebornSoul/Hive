//
//  HVRelationshipMapping.h
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HVObjectMapping;

@interface HVRelationshipMapping : NSObject

+ (instancetype) relationshipFromPath:(NSString *)sourcePath withMapping:(HVObjectMapping *)mapping;

- (NSDictionary *) dictionaryRepresentation;

@end
