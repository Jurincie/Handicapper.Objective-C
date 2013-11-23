//
//  ECDistanceClassStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/21/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECFirstTurnStats, ECPostStatistics, ECTopOfStretchStats, ECTrack;

@interface ECDistanceClassStats : NSManagedObject

@property (nonatomic, retain) NSString	*raceClass;
@property (nonatomic, retain) NSNumber	*raceDistance;
@property (nonatomic, retain) NSSet		*postStatistics;
@property (nonatomic, retain) NSSet		*firstTurnStatistics;
@property (nonatomic, retain) NSSet		*secondTurnStatistics;
@property (nonatomic, retain) NSSet		*topOfStretchStatistics;
@property (nonatomic, retain) ECTrack	*track;

@end

@interface ECDistanceClassStats (CoreDataGeneratedAccessors)

- (void)addPostStatisticsObject:(ECPostStatistics *)value;
- (void)removePostStatisticsObject:(ECPostStatistics *)value;
- (void)addPostStatistics:(NSSet *)values;
- (void)removePostStatistics:(NSSet *)values;

- (void)addFirstTurnStatisticsObject:(ECFirstTurnStats *)value;
- (void)removeFirstTurnStatisticsObject:(ECFirstTurnStats *)value;
- (void)addFirstTurnStatistics:(NSSet *)values;
- (void)removeFirstTurnStatistics:(NSSet *)values;

- (void)addSecondTurnStatisticsObject:(NSManagedObject *)value;
- (void)removeSecondTurnStatisticsObject:(NSManagedObject *)value;
- (void)addSecondTurnStatistics:(NSSet *)values;
- (void)removeSecondTurnStatistics:(NSSet *)values;

- (void)addTopOfStretchStatisticsObject:(ECTopOfStretchStats *)value;
- (void)removeTopOfStretchStatisticsObject:(ECTopOfStretchStats *)value;
- (void)addTopOfStretchStatistics:(NSSet *)values;
- (void)removeTopOfStretchStatistics:(NSSet *)values;

@end
