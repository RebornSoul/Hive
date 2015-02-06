//
//  Tweet.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "Tweet.h"
#import "Media.h"

@implementation Tweet

- (BOOL) hasPhotoMedia {
    for (Media *media in self.media) {
        if ([media.type isEqualToString:@"photo"]) {
            return YES;
        }
    }
    return NO;
}

@end
