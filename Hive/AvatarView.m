//
//  AvatarView.m
//  Hive
//
//  Created by Yury Nechaev on 05.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "AvatarView.h"

@implementation AvatarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
}

@end
