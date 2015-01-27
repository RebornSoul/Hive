//
//  HVObjectMapping.h
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HVRelationshipMapping;

@interface HVObjectMapping : NSObject

@property (nonatomic, assign, readonly) Class targetClass;
@property (nonatomic, strong) NSString *identificationAttribute;

- (id) initWithTargetClass:(Class)aClass;

- (void) addAttributedMappingFromDictionary:(NSDictionary *)dictionary;
- (void) addAttributedMappingFromKey:(NSString *)sourceKey
                               toKey:(NSString *)destinationKey;

- (void) addRelationshipMapping:(HVRelationshipMapping *)relationshipMapping;

@end
