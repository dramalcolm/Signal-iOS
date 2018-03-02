//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#import "OWS103EnableVideoCalling.h"
#import <SignalServiceKit/OWSRequestFactory.h>
#import <SignalServiceKit/TSAccountManager.h>
#import <SignalServiceKit/TSNetworkManager.h>

// Increment a similar constant for every future DBMigration
static NSString *const OWS103EnableVideoCallingMigrationId = @"103";

@implementation OWS103EnableVideoCalling

+ (NSString *)migrationId
{
    return OWS103EnableVideoCallingMigrationId;
}

// Override parent migration
- (void)runUpWithCompletion:(OWSDatabaseMigrationCompletion)completion
{
    OWSAssert(completion);

    DDLogWarn(@"%@ running migration...", self.logTag);
    if ([TSAccountManager isRegistered]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TSRequest *request = [OWSRequestFactory updateAttributesRequestWithManualMessageFetching:NO];
            [[TSNetworkManager sharedManager] makeRequest:request
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    DDLogInfo(@"%@ successfully ran", self.logTag);
                    [self save];

                    completion();
                }
                failure:^(NSURLSessionDataTask *task, NSError *error) {
                    if (!IsNSErrorNetworkFailure(error)) {
                        OWSProdError([OWSAnalyticsEvents errorEnableVideoCallingRequestFailed]);
                    }
                    DDLogError(@"%@ failed with error: %@", self.logTag, error);

                    completion();
                }];
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            DDLogInfo(@"%@ skipping; not registered", self.logTag);
            [self save];

            completion();
        });
    }
}

@end
