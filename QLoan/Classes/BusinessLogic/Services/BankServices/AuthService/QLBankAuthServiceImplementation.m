//
//  QLBankAuthServiceImplementation.m
//  QLoan
//
//  Created by Nikulin Maksim on 20/10/16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import "QLBankAuthServiceImplementation.h"

#import "QLBankAuthRequestFactory.h"
#import "QLStorage.h"
#import "QLBankAuthMapper.h"

#import "QLNetworkClient.h"
#import "QLJSONSerializer.h"

#import "QLServerResponse.h"
#import "QLBankUserInfo.h"

@implementation QLBankAuthServiceImplementation

- (void)loginWithLogin:(NSString *)login
              password:(NSString *)password
            completion:(QLBankAuthLoginCompletion)completion {
    NSURLRequest *URLRequest = [self.requestFactory requestForLoginWithLogin:login
                                                                    password:password];
    [self.networkClient sendRequest:URLRequest
                         completion:^(QLServerResponse *response, NSError *error) {
                             if (!response.data) {
                                 run_block_on_main(completion, NO, nil);
                             }
                             id responseData = [NSJSONSerialization JSONObjectWithData:response.data
                                                                               options:kNilOptions
                                                                                 error:nil];
                             if (![responseData[QLBankErrorCode] integerValue]) {
                                 NSString *sessionId = responseData[QLBankSessionId];
                                 if (sessionId.length) {
                                     [self.storage storeObject:sessionId
                                                        forKey:QLBankSessionIdKey];
                                 }
                                 run_block_on_main(completion, YES, nil);
                             } else {
                                 run_block_on_main(completion, NO, nil);
                             }
                         }];
}

- (void)updateCurrentUserDataWithCompletion:(QLBankAuthUserDataCompletion)completion {
    NSString *sessionId = [self.storage loadObjectForKey:QLBankSessionIdKey];
    if (!sessionId.length) {
        run_block_on_main(completion, nil, [NSError new]);
    } else {
        NSURLRequest *URLRequest = [self.requestFactory requestForCurrentUserDataWithSessionId:sessionId];
        [self.networkClient sendRequest:URLRequest
                             completion:^(QLServerResponse *response, NSError *error) {
                                 if (!response.data) {
                                     run_block_on_main(completion, nil, [NSError new]);
                                 }
                                 id responseData = [NSJSONSerialization JSONObjectWithData:response.data
                                                                                   options:kNilOptions
                                                                                     error:nil];
                                 QLBankUserInfo *bankUserInfo = [self.mapper mapBankUserInfoFromResponseObject:responseData];
                                 [self.storage storeObject:bankUserInfo
                                                    forKey:QLBankUserInfoKey];
                                 run_block_on_main(completion, bankUserInfo, nil);
                             }];
    }
}

- (QLBankUserInfo *)obtainCurrentUserData {
    return [self.storage loadObjectForKey:QLBankUserInfoKey];
}

@end