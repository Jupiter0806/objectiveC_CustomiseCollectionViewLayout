//
//  FLCollectionSeparator.m
//  CustomiseCollectionViewLayout
//
//  Created by jupyter on 21/6/17.
//  Copyright © 2017 jupyter. All rights reserved.
//

#import "FLCollectionSeparator.h"

@implementation FLCollectionSeparator
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.frame = layoutAttributes.frame;
}
@end
