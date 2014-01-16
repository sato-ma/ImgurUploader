//
//  ImgurUploader.h
//

#import <Foundation/Foundation.h>

@interface ImgurUploader : NSObject
+ (BOOL)uploadImage:(UIImage*)image
               type:(NSString*)type /* @"png" or @"jpg" */
           clientID:(NSString*)clientID
           delegate:(id<NSURLConnectionDelegate, NSURLConnectionDataDelegate>)delegate
              error:(NSError**)error;
@end
