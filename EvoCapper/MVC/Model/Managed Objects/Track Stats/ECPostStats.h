//
//  ECPostStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 5/3/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECMarathonRaceStats, ECSprintRaceStats, ECThreeTurnRaceStats, ECTwoTurnRaceStats;

@interface ECPostStats : NSManagedObject

@property (nonatomic, retain) NSNumber * boxNumber;
@property (nonatomic, retain) NSNumber * breakPositionAverage;
@property (nonatomic, retain) NSNumber * finalPositionAverage;
@property (nonatomic, retain) NSNumber * firstTurnPositionAverage;
@property (nonatomic, retain) ECMarathonRaceStats *marathonRaceStats;
@property (nonatomic, retain) ECSprintRaceStats *sprintRaceStats;
@property (nonatomic, retain) ECThreeTurnRaceStats *threeTurnRaceStats;
@property (nonatomic, retain) ECTwoTurnRaceStats *twoTurnRaceStats;

@end
