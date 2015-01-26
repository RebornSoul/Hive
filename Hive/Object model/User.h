//
//  User.h
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *profileDescription;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger friendsCount;
@property (nonatomic, assign) NSInteger listedCount;
@property (nonatomic, assign) NSInteger statusesCount;
@property (nonatomic, strong) NSString *profileBackgrouondColor;
@property (nonatomic, strong) NSString *profileBackgroundImageUrl;
@property (nonatomic, strong) NSString *profileBannerUrl;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, assign) BOOL profileBackgroundTile;
@end
