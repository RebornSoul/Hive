//
//  OutlineButton.m
//  Hive
//
//  Created by Yury Nechaev on 07.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "OutlineButton.h"

@interface OutlineButton ()

@property (nonatomic, assign) BOOL filled;

@end

@implementation OutlineButton

- (void)drawRect:(CGRect)rect {
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.345 green: 0.173 blue: 0.075 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 1 green: 0.714 blue: 0.571 alpha: 1];;
    
    //// Frames
    CGRect frame = rect;
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 1, CGRectGetMinY(frame) + 1, CGRectGetWidth(frame) - 2, CGRectGetHeight(frame) - 2) cornerRadius: 4];
    if (self.filled) {
        [color2 setFill];
        [roundedRectanglePath fill];
    }
    [color setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
}

- (void) setHighlighted:(BOOL)highlighted {
    self.filled = highlighted;
    [self setNeedsDisplay];
}

@end
