//
//  HVObjectMapping.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "HVObjectMapping.h"

@interface HVObjectMapping ()
@property (nonatomic, assign) Class targetClass;
@property (nonatomic, strong) NSDictionary *mappingAttributes;
@end

@implementation HVObjectMapping

- (id) initWithTargetClass:(Class)aClass {
    self = [super init];
    if (self) {
        self.targetClass = aClass;
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
}

@end
