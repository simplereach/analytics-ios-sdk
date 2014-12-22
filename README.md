analytics-ios-sdk
=================

## Usage

See files labelled SRPageView.h and SRPageView.m

To create a URL link and fetch response from link, enter the following command in your iOS program: 

```objective-c
[SRPageView fetchPageWithPID:@"000000000000000000000000"
                             url:@"http://www.example.com/simplereach-examples"
                           title:@"Test Title"
                            date:[NSDate date]
                         authors:@[@"Alexis Krantz", @"Joe Smith", @"Kent Brockman"]
                          domain:@"thecoolist.com"
                         pageURL:@"http://www.example.com/simplereach-examples"
                        channels:@[@"health", @"beauty"]
                            tags:@[@"5344|example tag"]
                          iframe:nil
                    ignoreErrors:nil
                      landingURL:nil
                        callback:@"SPR.API.callbacks.cb3582146"];
    
    return YES;
```

In your console, you should see the following statement logged:

2014-12-22 01:01:45.664 SimpleReachSDK[14903:561489] Status Code: 200
2014-12-22 01:01:45.775 SimpleReachSDK[14903:561489] SPRAPIcallbackscb3582146]({"id":"dbcc0fa50ff9772d6b4d8ce5867c32d4","pid":"000000000000000000000000","sid":"029c9f81-89a0-11e4-8925-22000b2b045c","uid":"029c9f97-89a0-11e4-8925-22000b2b045c","url":"http://wwwexamplecom/simplereachexamples","fb":false,"tw":false,"rd":false,"pi":false,"li":false,"de":false});
