//
//  HVListLayout.m
//  Hive
//
//  Created by Yury Nechaev on 04.02.16.
//  Copyright © 2016 Yury Nechaev. All rights reserved.
//

#import "HVListLayout.h"
#import "TweetCell.h"

static CGFloat const kVerticalInset = 8;

@implementation HVListLayout

- (void) prepareLayout {
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesList = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesList) {
        if (attributes.representedElementKind == nil) {
            attributes.frame = [[self layoutAttributesForItemAtIndexPath:attributes.indexPath] frame];
        }
    }
    return attributesList;
}



@end
