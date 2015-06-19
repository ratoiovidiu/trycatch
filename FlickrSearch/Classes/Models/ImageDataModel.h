//
//  PhotoInfo.h
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 12/06/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ImageType) {
    IT_Loading = 0,
    IT_Thumb,
    IT_Small,
    IT_Large
};

@interface ImageDataModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *thumbUrlString;
@property (nonatomic, strong) NSString *smallUrlString;
@property (nonatomic, strong) NSString *largeUrlString;

- (instancetype)initWithFlickrDescription:(NSDictionary *)description;

@end
