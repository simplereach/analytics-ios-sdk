//
//  SRPageView.m
//  SimpleReachPageView
//
//  Created by Zak Niazi on 12/21/14.
//  Copyright (c) 2014 SimpleReach. All rights reserved.
//

#import "SRPageView.h"

NSString *const SIMPLEREACH_URL = @"https://edge.simplereach.com/n";

@implementation SRPageView

+ (void)fetchPageWithPID:(NSString *)pid
                     url:(NSString *)url
                   title:(NSString *)title
                    date:(id)date
                 authors:(NSArray *)authors
                  domain:(NSString *)domain
                 pageURL:(NSString *)pageURL
                channels:(NSArray *)channels
                    tags:(NSArray *)tags
                  iframe:(BOOL)iframe
            ignoreErrors:(BOOL)ignoreErrors
              landingURL:(NSString *)landingURL
                callback:(NSString *)callback {

    NSString *authorsString = [authors componentsJoinedByString:@", "];
    NSString *channelsString = [channels componentsJoinedByString:@", "];
    NSString *tagsString = [tags componentsJoinedByString:@", "];

    date = [date isKindOfClass:[NSDate class]] ? [self UTCDateFromDate:date] : date;

    url = [self sanitizeQueryParameter:url];
    title = [self sanitizeQueryParameter:title];
    date = [self sanitizeQueryParameter:date];
    authorsString = [self sanitizeQueryParameter:authorsString];
    domain = [self sanitizeQueryParameter:domain];
    pageURL = [self sanitizeQueryParameter:pageURL];
    channelsString = [self sanitizeQueryParameter:channelsString];
    tagsString = [self sanitizeQueryParameter:tagsString];
    NSString *userID = [self UDID];
    callback = [self sanitizeQueryParameter:callback];
    landingURL = [self sanitizeQueryParameter:landingURL];
    NSString *iframeQuery;
    NSString *ignoreErrorsQuery;

    if (iframe == nil) {
        iframeQuery = @"true";
    } else {
        iframeQuery = iframe ? @"true" : @"false";
    }

    if (ignoreErrors == nil) {
        ignoreErrorsQuery = @"false";
    } else {
        ignoreErrorsQuery = ignoreErrors ? @"true" : @"false";
    }

    NSString *urlString = [NSString stringWithFormat:@"%@?pid=%@&url=%@&title=%@&date=%@&authors=%@&domain=%@&page_url=%@&channels=%@&tags=%@&iframe=%@&userID=%@&ignore_errors=%@&landing_url=%@&cb=%@]", SIMPLEREACH_URL ,pid, url, title, date, authorsString, domain, pageURL, channelsString, tagsString, iframeQuery, userID, ignoreErrorsQuery, landingURL, callback];
    NSURL *simplereachURL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:simplereachURL];
    [urlRequest setValue:@"application/javascript" forHTTPHeaderField:@"Content-Type"];
    NSError *error = nil;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        NSLog(@"Status Code: %li", statusCode);
        if (data.length > 0 && error == nil) {
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", dataString);
        }
        else if (data.length == 0 && error == nil) {
            NSLog(@"Nothing downloaded.");
        } else if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

+ (NSString *)sanitizeQueryParameter:(NSString *)queryParameter {
    if (queryParameter == nil) {
        return @"";
    }

    // Remove any strange characters from string.
    queryParameter = [self searchAndRemoveText:queryParameter];

    NSString *sanitizedQueryParameter = [self stringIsURLEncoded:queryParameter] ? queryParameter : [self urlEncodeString:queryParameter];

    return sanitizedQueryParameter;
}

+ (NSString *)urlEncodeString:(NSString *)unescapedString {
    NSString *escapedString = [unescapedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    return escapedString;
}

+ (NSString *)unencodeString:(NSString *)escapedString {
    NSString *unescapedString = [escapedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    return unescapedString;
}

+ (BOOL)stringIsURLEncoded:(NSString *)string {
    BOOL isEncoded = ![string isEqualToString:[self unencodeString:string]];
    return isEncoded;
}

+ (NSString *)UTCDateFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)searchAndRemoveText:(NSString *)beforeText
{
    NSRange range = NSMakeRange(0, beforeText.length);

    NSString *pattern = @"[łńøØßŒÆ∂ð]+";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];

    // Call the NSRegularExpression method to do the replacement for us
    NSString *afterText = [regex stringByReplacingMatchesInString:beforeText options:0 range:range withTemplate:@""];

    return afterText;
}

+ (NSString*)UDID {
    NSString *uuidString = nil;
    // get os version
    NSUInteger currentOSVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];

    if(currentOSVersion <= 5) {
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"udid"]) {
            uuidString = [[NSUserDefaults standardUserDefaults] valueForKey:@"udid"];
        } else {
            CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
            uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL,uuidRef));
            CFRelease(uuidRef);
            [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:@"udid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return uuidString;
    } else {
        NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
        return [identifierForVendor UUIDString];
    }
}
@end
