//
//  PhotoInfo.h
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 12/06/15.
//
//

#import <Foundation/Foundation.h>

@interface PhotoInfo : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *thumbUrlString;
@property (nonatomic, strong) NSString *smallUrlString;
@property (nonatomic, strong) NSString *largeUrlString;
@property (nonatomic, strong) NSString *defaultUrlString;

- (instancetype)initWithFlickrDescription:(NSDictionary *)description;

@end
