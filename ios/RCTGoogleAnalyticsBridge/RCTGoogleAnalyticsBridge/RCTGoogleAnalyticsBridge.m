#import "RCTGoogleAnalyticsBridge.h"
#import "GAI.h"
#import "GAIFields.h"
#import "RCTLog.h"
#import "GAIDictionaryBuilder.h"
#import "RCTConvert.h"

@implementation RCTGoogleAnalyticsBridge {

}

- (instancetype)init
{
    if ((self = [super init])) {
        // Optional: automatically send uncaught exceptions to Google Analytics.
        [GAI sharedInstance].trackUncaughtExceptions = YES;

        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 20;

        // Optional: set Logger to VERBOSE for debug information.
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];

        // Initialize tracker. Replace with your tracking ID.
        [[GAI sharedInstance] trackerWithTrackingId:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"GAITrackingId"]];
    }
    return self;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(trackScreenView:(NSString *)screenName)
{
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker set:kGAIScreenName
         value:screenName];
  [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

RCT_EXPORT_METHOD(trackEvent:(NSString *)category action:(NSString *)action optionalValues:(NSDictionary *) optionalValues)
{
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  NSString *label = [RCTConvert NSString:optionalValues[@"label"]];
  NSNumber *value = [RCTConvert NSNumber:optionalValues[@"value"]];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                      action:action
                                                       label:label
                                                         value:value] build]];
}

@end