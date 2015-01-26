//
//  UserSurveyCell.h
//  Hive
//
//  Created by Yury Nechaev on 25.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSurveyCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *surveyLabel;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;
@end
