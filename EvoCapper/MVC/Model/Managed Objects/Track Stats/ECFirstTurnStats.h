//
//  ECFirstTurnStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 4/25/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECMarathonRaceStats, ECThreeTurnRaceStats, ECTwoTurnRaceStats;

@interface ECFirstTurnStats : NSManagedObject

@property (nonatomic, retain) NSNumber * averagePositionFarTurn;
@property (nonatomic, retain) NSNumber * firstTurnPosition;
@property (nonatomic, retain) ECTwoTurnRaceStats *twoTurnRaceStats;
@property (nonatomic, retain) ECThreeTurnRaceStats *threeTurnRaceStats;
@property (nonatomic, retain) ECMarathonRaceStats *marathonRaceStats;

@end
