//
//  ECTrackStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 12/22/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECFarTurnStatistics, ECFirstTurnStats, ECPostStats, ECTrack;

@interface ECTrackStats : NSManagedObject

@property (nonatomic, retain) NSNumber * raceDistance;
@property (nonatomic, retain) NSNumber * averageTime;
@property (nonatomic, retain) NSNumber * trackRecord;
@property (nonatomic, retain) NSOrderedSet *firstTurnStatistics;
@property (nonatomic, retain) NSOrderedSet *postStatistics;
@property (nonatomic, retain) NSOrderedSet *farTurnStatistics;
@property (nonatomic, retain) ECTrack *track;
@end

@interface ECTrackStats (CoreDataGeneratedAccessors)

- (void)insertObject:(ECFirstTurnStats *)value inFirstTurnStatisticsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFirstTurnStatisticsAtIndex:(NSUInteger)idx;
- (void)insertFirstTurnStatistics:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFirstTurnStatisticsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFirstTurnStatisticsAtIndex:(NSUInteger)idx withObject:(ECFirstTurnStats *)value;
- (void)replaceFirstTurnStatisticsAtIndexes:(NSIndexSet *)indexes withFirstTurnStatistics:(NSArray *)values;
- (void)addFirstTurnStatisticsObject:(ECFirstTurnStats *)value;
- (void)removeFirstTurnStatisticsObject:(ECFirstTurnStats *)value;
- (void)addFirstTurnStatistics:(NSOrderedSet *)values;
- (void)removeFirstTurnStatistics:(NSOrderedSet *)values;
- (void)insertObject:(ECPostStats *)value inPostStatisticsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPostStatisticsAtIndex:(NSUInteger)idx;
- (void)insertPostStatistics:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePostStatisticsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPostStatisticsAtIndex:(NSUInteger)idx withObject:(ECPostStats *)value;
- (void)replacePostStatisticsAtIndexes:(NSIndexSet *)indexes withPostStatistics:(NSArray *)values;
- (void)addPostStatisticsObject:(ECPostStats *)value;
- (void)removePostStatisticsObject:(ECPostStats *)value;
- (void)addPostStatistics:(NSOrderedSet *)values;
- (void)removePostStatistics:(NSOrderedSet *)values;
- (void)insertObject:(ECFarTurnStatistics *)value inFarTurnStatsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFarTurnStatsAtIndex:(NSUInteger)idx;
- (void)insertFarTurnStats:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFarTurnStatsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFarTurnStatsAtIndex:(NSUInteger)idx withObject:(ECFarTurnStatistics *)value;
- (void)replaceFarTurnStatsAtIndexes:(NSIndexSet *)indexes withFarTurnStats:(NSArray *)values;
- (void)addFarTurnStatsObject:(ECFarTurnStatistics *)value;
- (void)removeFarTurnStatsObject:(ECFarTurnStatistics *)value;
- (void)addFarTurnStats:(NSOrderedSet *)values;
- (void)removeFarTurnStats:(NSOrderedSet *)values;
@end
