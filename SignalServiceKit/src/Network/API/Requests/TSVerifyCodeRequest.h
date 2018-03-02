//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#import "TSRequest.h"

@interface TSVerifyCodeRequest : TSRequest

@property (nonatomic, readonly) NSString *numberToValidate;

- (instancetype)init NS_UNAVAILABLE;

- (TSRequest *)initWithVerificationCode:(NSString *)verificationCode
                              forNumber:(NSString *)phoneNumber
                           signalingKey:(NSString *)signalingKey
                                authKey:(NSString *)authKey;

@end
