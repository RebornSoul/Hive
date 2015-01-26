//
//  HVRelationshipMapping.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "HVRelationshipMapping.h"
#import "HVObjectMapping.h"

@interface HVRelationshipMapping ()

@property (nonatomic, strong) NSString *sourcePath;
@property (nonatomic, strong) HVObjectMapping *mapping;

@end

@implementation HVRelationshipMapping

+ (instancetype) relationshipFromPath:(NSString *)sourcePath
                          withMapping:(HVObjectMapping *)mapping {
    HVRelationshipMapping *instance = [HVRelationshipMapping new];
    instance.sourcePath = sourcePath;
    instance.mapping = mapping;
    return instance;
}

- (NSDictionary *) dictionaryRepresentation {
    return [NSDictionary dictionaryWithObject:self.mapping forKey:self.sourcePath];
}

@end
