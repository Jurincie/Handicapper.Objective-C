//
//  ECFarTurnStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 5/3/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECMarathonRaceStats, ECThreeTurnRaceStats, ECTwoTurnRaceStats;

@interface ECFarTurnStats : NSManagedObject

@property (nonatomic, retain) NSNumber * averageFinalPosition;
@property (nonatomic, retain) NSNumber * farTurnPosition;
@property (nonatomic, retain) ECMarathonRaceStats *marathonRaceStats;
@property (nonatomic, retain) ECThreeTurnRaceStats *threeTurnRaceStats;
@property (nonatomic, retain) ECTwoTurnRaceStats *twoTurnRaceStats;

@end
