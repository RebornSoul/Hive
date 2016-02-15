//
//  HVDataNode.h
//  Hive
//
//  Created by Yury Nechaev on 15.02.16.
//  Copyright © 2016 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tweet;

typedef NS_ENUM(NSUInteger, kTweetTableCellType) {
    kTweetTableCellTypeNormal = 1,
    kTweetTableCellTypeLoader = 2,
    kTweetTableCellTypeSurvey = 3,
    kTweetTableCellTypeMore   = 4
};

@interface HVDataNode : NSObject
@property (nonatomic, strong) NSDictionary *metaData;
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, assign) kTweetTableCellType nodeType;
@end
