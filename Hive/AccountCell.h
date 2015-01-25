//
//  AccountCell.h
//  Hive
//
//  Created by Yury Nechaev on 20.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *checkImage;
@property (nonatomic, weak) IBOutlet UILabel *accountNameLabel;
@end
