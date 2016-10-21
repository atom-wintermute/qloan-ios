//
//  QLServicesAssembly.m
//  QLoan
//
//  Created by m.rakhmanov on 17.10.16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import "QLServicesAssembly.h"
#import "QLCoreComponentsAssembly.h"
#import "QLBorrowerOrderService.h"
#import "QLBankAuthServiceImplementation.h"
#import "QLBankCardServiceImplementation.h"

@interface QLServicesAssembly()

@property (nonatomic, strong) QLCoreComponentsAssembly *coreAssembly;

@end

@implementation QLServicesAssembly

- (QLBorrowerOrderService *)borrowerOrderService {
	return [TyphoonDefinition withClass:[QLBorrowerOrderService class]
						  configuration:^(TyphoonDefinition *definition)
			{
				[definition injectProperty:@selector(serializer)
									  with:[self.coreAssembly jsonSerializer]];
				[definition injectProperty:@selector(networkClient)
									  with:[self.coreAssembly networkClient]];
				[definition injectProperty:@selector(mapper)
									  with:[self.coreAssembly mapper]];
				[definition injectProperty:@selector(requestFactory)
									  with:[self.coreAssembly requestFactory]];
			}];
}

- (id<QLBankAuthService>)bankAuthService {
    return [TyphoonDefinition withClass:[QLBankAuthServiceImplementation class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(networkClient)
                                                    with:[self.coreAssembly networkClient]];
                              [definition injectProperty:@selector(requestFactory)
                                                    with:[self.coreAssembly bankAuthRequestFactory]];
                              [definition injectProperty:@selector(storage)
                                                    with:[self.coreAssembly inMemoryStorage]];
                              [definition injectProperty:@selector(mapper)
                                                    with:[self.coreAssembly bankAuthMapper]];
                          }];
}

- (id<QLBankCardService>)bankCardService {
    return [TyphoonDefinition withClass:[QLBankCardServiceImplementation class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(networkClient)
                                                    with:[self.coreAssembly networkClient]];
                              [definition injectProperty:@selector(requestFactory)
                                                    with:[self.coreAssembly bankCardRequestFactory]];
                              [definition injectProperty:@selector(storage)
                                                    with:[self.coreAssembly inMemoryStorage]];
                              [definition injectProperty:@selector(mapper)
                                                    with:[self.coreAssembly bankCardMapper]];
                          }];
}

@end