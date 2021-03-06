//
//  QLGetCellFactory.h
//  QLoan
//
//  Created by Nikulin Maksim on 21/10/16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

/**
 Протокол фабрики ячеек для экрана получения займа
 */
@class QLOrderInfo;

@protocol QLGetCellFactory <NSObject>

- (NSArray *)cellObjects;

- (NSArray *)cellObjectsFromOrderInfos:(NSArray *)orderInfos;

@end
