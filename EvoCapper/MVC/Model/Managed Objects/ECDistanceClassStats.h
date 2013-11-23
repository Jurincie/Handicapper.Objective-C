//
//  ECDistanceClassStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/22/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECFirstTurnStats, ECPostStatistics, ECSecondTurnStats, ECTopOfStretchStats, ECTrack;

@interface ECDistanceClassStats : NSManagedObject

@property (nonatomic, retain) NSString * raceClass;
@property (nonatomic, retain) NSNumber * raceDistance;
@property (nonatomic, retain) NSOrderedSet *firstTurnStatistics;
@property (nonatomic, retain) NSOrderedSet *postStatistics;
@property (nonatomic, retain) NSOrderedSet *secondTurnStatistics;
@property (nonatomic, retain) NSOrderedSet *topOfStretchStatistics;
@property (nonatomic, retain) ECTrack *track;
@end

@interface ECDistanceClassStats (CoreDataGeneratedAccessors)

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
- (void)insertObject:(ECPostStatistics *)value inPostStatisticsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPostStatisticsAtIndex:(NSUInteger)idx;
- (void)insertPostStatistics:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePostStatisticsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPostStatisticsAtIndex:(NSUInteger)idx withObject:(ECPostStatistics *)value;
- (void)replacePostStatisticsAtIndexes:(NSIndexSet *)indexes withPostStatistics:(NSArray *)values;
- (void)addPostStatisticsObject:(ECPostStatistics *)value;
- (void)removePostStatisticsObject:(ECPostStatistics *)value;
- (void)addPostStatistics:(NSOrderedSet *)values;
- (void)removePostStatistics:(NSOrderedSet *)values;
- (void)insertObject:(ECSecondTurnStats *)value inSecondTurnStatisticsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSecondTurnStatisticsAtIndex:(NSUInteger)idx;
- (void)insertSecondTurnStatistics:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSecondTurnStatisticsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSecondTurnStatisticsAtIndex:(NSUInteger)idx withObject:(ECSecondTurnStats *)value;
- (void)replaceSecondTurnStatisticsAtIndexes:(NSIndexSet *)indexes withSecondTurnStatistics:(NSArray *)values;
- (void)addSecondTurnStatisticsObject:(ECSecondTurnStats *)value;
- (void)removeSecondTurnStatisticsObject:(ECSecondTurnStats *)value;
- (void)addSecondTurnStatistics:(NSOrderedSet *)values;
- (void)removeSecondTurnStatistics:(NSOrderedSet *)values;
- (void)insertObject:(ECTopOfStretchStats *)value inTopOfStretchStatisticsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTopOfStretchStatisticsAtIndex:(NSUInteger)idx;
- (void)insertTopOfStretchStatistics:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTopOfStretchStatisticsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTopOfStretchStatisticsAtIndex:(NSUInteger)idx withObject:(ECTopOfStretchStats *)value;
- (void)replaceTopOfStretchStatisticsAtIndexes:(NSIndexSet *)indexes withTopOfStretchStatistics:(NSArray *)values;
- (void)addTopOfStretchStatisticsObject:(ECTopOfStretchStats *)value;
- (void)removeTopOfStretchStatisticsObject:(ECTopOfStretchStats *)value;
- (void)addTopOfStretchStatistics:(NSOrderedSet *)values;
- (void)removeTopOfStretchStatistics:(NSOrderedSet *)values;
@end
