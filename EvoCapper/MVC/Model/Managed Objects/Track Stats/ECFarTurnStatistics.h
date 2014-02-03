//
//  ECFarTurnStatistics.h
//  EvoCapper
//
//  Created by Ron Jurincie on 1/30/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECRaceDistanceStats;

@interface ECFarTurnStatistics : NSManagedObject

@property (nonatomic, retain) NSNumber * averageFinishPosition;
@property (nonatomic, retain) NSNumber * farTurnPosition;
@property (nonatomic, retain) ECRaceDistanceStats *raceDistanceStats;

@end
