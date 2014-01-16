//
//  ImgurUploader.m
//

#import "ImgurUploader.h"

@implementation ImgurUploader
+ (BOOL)uploadImage:(UIImage*)image
               type:(NSString*)type /* @"png" or @"jpg" */
           clientID:(NSString*)clientID
           delegate:(id<NSURLConnectionDelegate, NSURLConnectionDataDelegate>)delegate
              error:(NSError**)error {
    NSURL* url = [NSURL URLWithString:@"https://api.imgur.com/3/image"];
    NSData* imageData = nil;
    BOOL result = YES;
    
    if ([type compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        imageData = UIImagePNGRepresentation(image);
    } else if ([type compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        imageData = UIImageJPEGRepresentation(image, 0.75);
    }
    
    if (!imageData) {
        if (error) {
            NSDictionary* userInfo = [NSDictionary dictionaryWithObject:@"Invalid file format" forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:-100 userInfo:userInfo];
        }
        result = NO;
    }
    
    if (result) {
        NSString* imageDateBase64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString* urlEncodedImageData = (__bridge_transfer NSString*) CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                              (CFStringRef) imageDateBase64,
                                                                                                              NULL,
                                                                                                              (CFStringRef) @"!*'\"();:@&=+$,/?%#[]% ",
                                                                                                              kCFStringEncodingUTF8);
        NSString* postData = [NSString stringWithFormat:@"image=%@", urlEncodedImageData];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:[NSString stringWithFormat:@"Client-ID %@", clientID] forHTTPHeaderField:@"Authorization"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        
        if (connection == nil) {
            if (error) {
                NSDictionary* userInfo = [NSDictionary dictionaryWithObject:@"NSURLConnection Error" forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:-101 userInfo:userInfo];
            }
            result = NO;
        }
    }
    
    return result;
}
@end
