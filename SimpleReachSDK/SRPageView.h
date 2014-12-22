//
//  SRPageView.h
//  SimpleReachPageView
//
//  Created by Zak Niazi on 12/21/14.
//  Copyright (c) 2014 SimpleReach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SRPageView : NSObject
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
                callback:(NSString *)callback;
@end
