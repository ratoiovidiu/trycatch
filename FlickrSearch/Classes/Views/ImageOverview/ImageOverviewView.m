//
//  ImageOverviewView.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import "ImageOverviewView.h"

@implementation ImageOverviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.bounds;

    NSLog(@"TODO * %@", NSStringFromCGRect(frame));
}

@end
