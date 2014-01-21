//
//  ECFirstTurnStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 12/8/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECRaceDistanceStats;

@interface ECFirstTurnStats : NSManagedObject

@property (nonatomic, retain) NSNumber * averagePositionSecondTurn;
@property (nonatomic, retain) NSNumber * firstTurnPosition;
@property (nonatomic, retain) ECRaceDistanceStats *trackRaceDistanceStats;

@end
