//
//  HVObjectMapping.h
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HVObjectMapping : NSObject

@property (nonatomic, strong) NSString *identificationAttribute;

- (id) initWithTargetClass:(Class)aClass;

- (void) addAttributedMappingFromDictionary:(NSDictionary *)dictionary;
- (void) addAttributedMappingFromKey:(NSString *)sourceKey
                               toKey:(NSString *)destinationKey;

@end
