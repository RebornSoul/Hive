//
//  ImageZoomView.m
//  Hive
//
//  Created by Yury Nechaev on 15.05.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "ImageZoomView.h"
#import "ImageViewerController.h"

@interface ImageZoomView ()

@property (nonatomic, weak) ImageViewerController *imageController;

@end

@implementation ImageZoomView

- (id) initWithImageController:(ImageViewerController *)controller {
	self = [super init];
	if (self) {
		self.imageController = controller;
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
