//
//  Handicapper.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassStats, Population;

@interface Handicapper : NSManagedObject

@property (nonatomic, retain) NSString      *breakPositionTree;
@property (nonatomic, retain) NSString      *breakSpeedTree;
@property (nonatomic, retain) NSString      *earlySpeedTree;
@property (nonatomic, retain) NSString      *lateSpeedTree;
@property (nonatomic, retain) NSString      *recentClassTree;
@property (nonatomic, retain) NSString      *relevanceTree;
@property (nonatomic, retain) NSString      *topSpeedTree;
@property (nonatomic, retain) NSSet         *fitnessStats;
@property (nonatomic, retain) Population    *handicapperPopulation;
@end

@interface Handicapper (CoreDataGeneratedAccessors)

- (void)addFitnessStatsObject:(ClassStats *)value;
- (void)removeFitnessStatsObject:(ClassStats *)value;
- (void)addFitnessStats:(NSSet *)values;
- (void)removeFitnessStats:(NSSet *)values;

@end
