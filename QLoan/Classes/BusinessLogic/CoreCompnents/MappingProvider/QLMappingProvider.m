//
//  QLMappingProvider.m
//  QLoan
//
//  Created by m.rakhmanov on 16.10.16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import <EKMapper.h>

#import "QLMappingProvider.h"
#import "QLSessionCredentials.h"

#import "QLBorrowerOrder.h"
#import "QLLenderOrder.h"
#import "QLNotification.h"
#import "QLDateFormatter.h"
#import "QLPayment.h"
#import "QLPaymentSchedule.h"

@implementation QLMappingProvider

- (EKObjectMapping *)borrowerOrderMapping {
	return [EKObjectMapping mappingForClass:[QLBorrowerOrder class] withBlock:^(EKObjectMapping *mapping) {
		
		[mapping mapFieldsFromDictionary:@{
										   @"borrower_id": @"borrowerId",
										   @"lender_id" : @"lenderId",
										   @"loan_maturity_period" : @"loanMaturityPeriod",
										   @"loan_amount" : @"loanAmount",
										   @"perecentage" : @"perecentage",
										   @"penalty" : @"penalty",
										   @"repayment_type" : @"repaymentType",
										   @"status": @"status"
										   }];
	}];
}

- (EKObjectMapping *)lenderOrderMapping {
	return [EKObjectMapping mappingForClass:[QLLenderOrder class] withBlock:^(EKObjectMapping *mapping) {
		
		[mapping mapFieldsFromDictionary:@{
										   @"borrower_id": @"borrowerId",
										   @"lender_id" : @"lenderId",
										   @"loan_maturity_period" : @"loanMaturityPeriod",
										   @"loan_amount" : @"loanAmount",
										   @"perecentage" : @"perecentage",
										   @"penalty" : @"penalty",
										   @"repayment_type" : @"repaymentType",
										   @"status": @"status"
										   }];
	}];
}

- (EKObjectMapping *)authorizationHeaderMapping {
	return [EKObjectMapping mappingForClass:[QLSessionCredentials class] withBlock:^(EKObjectMapping *mapping) {
		
		[mapping mapFieldsFromDictionary:@{
										   @"client": @"client",
										   @"uid" : @"uid",
										   @"access-token" : @"accessToken"
										   }];
	}];
}

- (EKObjectMapping *)notificationMapping {
	return [EKObjectMapping mappingForClass:[QLNotification class] withBlock:^(EKObjectMapping *mapping) {
		[mapping mapFieldsFromDictionary:@{
										   @"notification_id": @"notificationId",
										   @"order_id" : @"orderId",
										   @"borrower_id" : @"borrowerId",
										   @"lender_id" : @"lenderId",
										   @"type" : @"type",
										   @"content" : @"content"
										   }];
		[mapping mapKey:@"date"
				toField:@"date"
		 withValueBlock:^id(NSString *key, NSArray *value) {
			 if ([value isKindOfClass:[NSString class]]) {
				 return nil;
			 }
			 NSDate *date = [self.formatter dateFromString:(NSString *)value];
			 return date;
		 }];
	}];
}

- (EKObjectMapping *)paymentMapping {
	return [EKObjectMapping mappingForClass:[QLPayment class] withBlock:^(EKObjectMapping *mapping) {
		[mapping mapFieldsFromDictionary:@{
										   @"status": @"status",
										   @"amount" : @"amount"
										   }];
		[mapping mapKey:@"date"
				toField:@"date"
		 withValueBlock:^id(NSString *key, NSArray *value) {
			 if ([value isKindOfClass:[NSString class]]) {
				 return nil;
			 }
			 NSDate *date = [self.formatter dateFromString:(NSString *)value];
			 return date;
		 }];
	}];
}

- (EKObjectMapping *)paymentScheduleMapping {
	return [EKObjectMapping mappingForClass:[QLPaymentSchedule class] withBlock:^(EKObjectMapping *mapping) {
		[mapping mapFieldsFromDictionary:@{
										   @"penalty": @"penalty",
										   @"indebtedness" : @"indebtedness"
										   }];
		[mapping mapKey:@"payments"
				toField:@"payments"
		 withValueBlock:^id(NSString *key, NSArray *value) {
			 if ([value isKindOfClass:[NSArray class]]) {
				 return nil;
			 }
			 NSArray *payments =
			 [EKMapper arrayOfObjectsFromExternalRepresentation:(NSArray *)value
													withMapping:[self paymentMapping]];
			 return payments;
		 }];
	}];
}

@end
