//
//  UIScreen+Additions.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import "UIScreen+Additions.h"

@implementation UIScreen (Additions)

- (CGRect)interfaceOrientationBounds {
    CGRect computedFrame = CGRectZero;
    CGRect originalFrame = self.bounds;
    BOOL originalIsLandscape = CGRectGetWidth(originalFrame) > CGRectGetHeight(originalFrame);
    BOOL interfaceIsLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);

    if (interfaceIsLandscape != originalIsLandscape) {
        computedFrame.origin.x = originalFrame.origin.y;
        computedFrame.origin.y = originalFrame.origin.x;
        computedFrame.size.width = originalFrame.size.height;
        computedFrame.size.height = originalFrame.size.width;
    } else {
        computedFrame = originalFrame;
    }

    return computedFrame;
}

- (CGRect)interfaceOrientationApplicationFrame {
    CGRect computedFrame = CGRectZero;
    CGRect originalFrame = self.applicationFrame;
    BOOL originalIsLandscape = CGRectGetWidth(originalFrame) > CGRectGetHeight(originalFrame);
    BOOL interfaceIsLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);

    if (([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)) {
        CGRect screenBounds = self.bounds;
        if ((YES == originalIsLandscape) && (0 == originalFrame.origin.y)) {
            originalFrame.origin.y = CGRectGetHeight(screenBounds) - CGRectGetHeight(originalFrame);
        } else if ((NO == originalIsLandscape) && (0 == originalFrame.origin.x)) {
            originalFrame.origin.x = CGRectGetWidth(screenBounds) - CGRectGetWidth(originalFrame);
        }
    }

    if (interfaceIsLandscape != originalIsLandscape) {
        computedFrame.origin.x = originalFrame.origin.y;
        computedFrame.origin.y = originalFrame.origin.x;
        computedFrame.size.width = originalFrame.size.height;
        computedFrame.size.height = originalFrame.size.width;
    } else {
        computedFrame = originalFrame;
    }

    return computedFrame;
}

@end
