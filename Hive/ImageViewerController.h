//
//  ImageViewerController.h
//  Hive
//
//  Created by Yury Nechaev on 06.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;

@interface ImageViewerController : UIViewController
@property (nonatomic, weak) UIView *senderViewForAnimation;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) Media *photoMedia;
@property (nonatomic, strong) UIImage *thumbImage;
@end
