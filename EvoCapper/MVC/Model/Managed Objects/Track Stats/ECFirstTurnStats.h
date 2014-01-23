//
//  ECFirstTurnStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 1/23/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECRaceDistanceStats;

@interface ECFirstTurnStats : NSManagedObject

@property (nonatomic, retain) NSNumber * averagePositionSecondTurn;
@property (nonatomic, retain) NSNumber * firstTurnPosition;
@property (nonatomic, retain) ECRaceDistanceStats *raceDistanceStats;

@end
