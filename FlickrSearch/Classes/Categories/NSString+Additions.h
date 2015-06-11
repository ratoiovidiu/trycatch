//
//  NSString+Additions.h
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (Additions)

+ (NSString *)uuid;

+ (NSString *)emptyIfNil:(NSString *)value;

- (CGSize)textSizeWithFont:(UIFont*)font;

- (CGSize)textSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)constrainedSize;

@end
