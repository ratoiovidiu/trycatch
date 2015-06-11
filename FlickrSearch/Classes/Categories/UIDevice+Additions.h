//
//  UIDevice+Additions.h
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import <UIKit/UIKit.h>

#define IS_IPAD ([UIDevice isIPad])
#define IS_IPHONE ([UIDevice isIPhone])

#define IS_PORTRAIT ([UIDevice isPortrait])
#define IS_LANDSCAPE ([UIDevice isLandscape])

@interface UIDevice (Additions)

+ (BOOL)isIPad;

+ (BOOL)isIPhone;

+ (BOOL)isPortrait;

+ (BOOL)isLandscape;

@end
