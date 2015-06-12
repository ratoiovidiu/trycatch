//
//  PhotoInfo.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 12/06/15.
//
//

#import "PhotoInfo.h"

#import "NSString+Additions.h"

#define kFLICKR_TITLE_KEY           @"title"

#define kFLICKR_FARM_KEY            @"farm"
#define kFLICKR_SERVER_KEY          @"server"
#define kFLICKR_ID_KEY              @"id"
#define kFLICKR_SECRET_KEY          @"secret"

@implementation PhotoInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = nil;

        self.thumbUrlString = nil;
        self.smallUrlString = nil;
        self.largeUrlString = nil;
        self.defaultUrlString = nil;
    }

    return self;
}

- (instancetype)initWithFlickrDescription:(NSDictionary *)description {
    self = [self init];

    if (self && [description isKindOfClass:[NSDictionary class]]) {
        NSString *farm = [NSString emptyIfNil:[description objectForKey:kFLICKR_FARM_KEY]];
        NSString *serverId = [NSString emptyIfNil:[description objectForKey:kFLICKR_SERVER_KEY]];
        NSString *photoId = [NSString emptyIfNil:[description objectForKey:kFLICKR_ID_KEY]];
        NSString *secret = [NSString emptyIfNil:[description objectForKey:kFLICKR_SERVER_KEY]];

        //    https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
        //    https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        self.title = [NSString emptyIfNil:[description objectForKey:kFLICKR_FARM_KEY]];
        self.thumbUrlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_q.jpg", farm, serverId, photoId, secret];
        self.smallUrlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_n.jpg", farm, serverId, photoId, secret];
        self.largeUrlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_h.jpg", farm, serverId, photoId, secret];
        self.defaultUrlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farm, serverId, photoId, secret];
    }

    return self;
}

@end
