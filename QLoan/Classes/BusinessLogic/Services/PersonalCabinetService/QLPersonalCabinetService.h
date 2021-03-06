//
//  QLPersonalCabinetService.h
//  QLoan
//
//  Created by m.rakhmanov on 16.10.16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServicesConstants.h"
#import "EntityConstants.h"

@class QLLenderOrder;
@class QLRequestFactory;
@class QLNetworkClient;
@class QLJSONSerializer;
@class QLMapper;
@class QLSerializer;

@interface QLPersonalCabinetService : NSObject

@property (nonatomic, strong) QLNetworkClient *networkClient;
@property (nonatomic, strong) QLJSONSerializer *jsonSerializer;
@property (nonatomic, strong) QLSerializer *serializer;
@property (nonatomic, strong) QLMapper *mapper;
@property (nonatomic, strong) QLRequestFactory *requestFactory;

/**
 Метод getMyLendersOrders
 */
- (void)myLenderOrdersWithPage:(NSInteger)page
					sortMethod:(QLSortMethod)sortMethod
					 ascending:(BOOL)ascending
					completion:(QLBorrowersOrderCompletion)completion;

/**
 Метод getMyBorrowersOrders
 */
- (void)myBorrowerOrdersWithPage:(NSInteger)page
					  sortMethod:(QLSortMethod)sortMethod
					   ascending:(BOOL)ascending
					  completion:(QLBorrowersOrderCompletion)completion;

/**
 Метод getMyNotifications
 */
- (void)myNotificationsWithPage:(NSInteger)page
					 completion:(QLNotificationsCompletion)completion;

/**
 Метод getMyNotification
 */
- (void)myNotificationWithId:(NSInteger)notificationId
				  completion:(QLNotificationCompletion)completion;

/**
 Метод getMyPayments
 */
- (void)myPaymentsWithOrderId:(NSInteger)orderId
				   completion:(QLPaymentScheduleCompletion)completion;

/**
 Метод deactivateOrder
 */
- (void)deactivateMyOrder:(NSInteger)orderId
			   completion:(QLBooleanCompletion)completion;


@end
