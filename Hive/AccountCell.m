//
//  AccountCell.m
//  Hive
//
//  Created by Yury Nechaev on 20.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "AccountCell.h"

@implementation AccountCell

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.checkImage setHidden:!selected];
}

@end
