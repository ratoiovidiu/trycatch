//
//  NSString+Additions.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

+ (NSString *)uuid {
    CFUUIDRef uuidObj = CFUUIDCreate(nil); // create a new UUID
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return [NSString emptyIfNil:uuid];
}

+ (NSString *)emptyIfNil:(NSString *)value {
    if (![value isKindOfClass:[NSNull class]] && value) {
        return [NSString stringWithFormat:@"%@", value];
    }
    return @"";
}

- (CGSize)textSizeWithFont:(UIFont*)font {
    CGSize result = CGSizeZero;
    if (([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)) {
        result = [self sizeWithFont:font];
    } else {
        result = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    }

    result.width = round(result.width + 1);
    result.height = round(result.height + 1);

    return result;
}

- (CGSize)textSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)constrainedSize {
    CGSize result = CGSizeZero;
    if (([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)) {
        result = [self sizeWithFont:font
                  constrainedToSize:constrainedSize];
    } else {
        result = [self boundingRectWithSize:constrainedSize
                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                 attributes:@{NSFontAttributeName:font}
                                    context:nil].size;
    }

    result.width = round(result.width + 1);
    result.height = round(result.height + 1);

    return result;
}

@end
