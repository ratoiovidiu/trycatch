//
//  WebServiceManager.h
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import <Foundation/Foundation.h>

@interface WebServiceManager : NSObject

+ (WebServiceManager *)shared;

- (void)getPhotoListWithTag:(NSString *)text forPageNumber:(NSInteger)pageNumber usingCallback:(void (^)(id response, NSError *error))completionBlock;

@end
