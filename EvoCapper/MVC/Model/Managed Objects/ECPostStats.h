//
//  ECPostStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 12/8/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECRaceDistanceStats;

@interface ECPostStats : NSManagedObject

@property (nonatomic, retain) NSNumber * breakPositionAverage;
@property (nonatomic, retain) NSNumber * finishPositionAverage;
@property (nonatomic, retain) NSNumber * firstTurnPositionAverage;
@property (nonatomic, retain) NSNumber * postNumber;
@property (nonatomic, retain) NSNumber * raceTimeAverage;
@property (nonatomic, retain) ECRaceDistanceStats *trackRaceDistanceStats;

@end
