//
//  QLRequestFactory.h
//  QLoan
//
//  Created by m.rakhmanov on 16.10.16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperation.h>

#import "ServicesConstants.h"
#import "EntityConstants.h"

@class QLKeychainStorage;

@interface QLRequestFactory : NSObject

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong) QLKeychainStorage *keychainStorage;

- (NSURLRequest *)requestForBorrowerOrdersWithPage:(NSUInteger)page
										sortMethod:(QLSortMethod)sortMethod
										 ascending:(BOOL)ascending;

- (NSURLRequest *)requestForBorrowerOrderWithId:(NSInteger)orderId;

@end