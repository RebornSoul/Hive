//
//  HVObjectMapping.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "HVObjectMapping.h"
#import "HVRelationshipMapping.h"

@interface HVObjectMapping ()
@property (nonatomic, strong) NSDictionary *mappingAttributes;
@property (nonatomic, strong) NSDictionary *relationshipDictionary; // relationship key ->> object mapping
@end

@implementation HVObjectMapping

- (id) initWithTargetClass:(Class)aClass {
    self = [super init];
    if (self) {
        _targetClass = aClass;
    }
    return self;
}

- (void) addAttributedMappingFromDictionary:(NSDictionary *)dictionary {
    for (NSString *key in dictionary) {
        [self addAttributedMappingFromKey:key toKey:[dictionary objectForKey:key]];
    }
}

- (void) addAttributedMappingFromKey:(NSString *)sourceKey toKey:(NSString *)destinationKey {
    NSAssert([sourceKey isKindOfClass:[NSString class]], @"sourceKey is not kind of NSString class");
    NSAssert([destinationKey isKindOfClass:[NSString class]], @"destinationKey is not kind of NSString class");
    NSAssert(sourceKey || destinationKey, @"sourceKey and destinationKey can not be nil");

    [self commitMappingFromKey:sourceKey toKey:destinationKey];

}

- (void) commitMappingFromKey:(NSString *)sourceKey toKey:(NSString *)destinationKey {
    NSMutableDictionary *mutableCopy = [self.mappingAttributes mutableCopy];
    [mutableCopy setObject:destinationKey forKey:sourceKey];
    self.mappingAttributes = [NSDictionary dictionaryWithDictionary:mutableCopy];
}

- (void) addRelationshipMapping:(HVRelationshipMapping *)relationshipMapping {
    NSMutableDictionary *mutableCopy = [self.relationshipDictionary mutableCopy];
    [mutableCopy addEntriesFromDictionary:[relationshipMapping dictionaryRepresentation]];
    self.relationshipDictionary = [NSDictionary dictionaryWithDictionary:mutableCopy];
}

@end
