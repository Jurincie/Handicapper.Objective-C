//
//  ECSprintTurnStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 5/3/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECSprintRaceStats;

@interface ECSprintTurnStats : NSManagedObject

@property (nonatomic, retain) NSNumber * averageFinalPosition;
@property (nonatomic, retain) NSNumber * turnPosition;
@property (nonatomic, retain) ECSprintRaceStats *sprintRaceStats;

@end
