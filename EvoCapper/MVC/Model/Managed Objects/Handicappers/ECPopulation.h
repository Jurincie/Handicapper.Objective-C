//
//  ECPopulation.h
//  EvoCapper
//
//  Created by Ron Jurincie on 4/25/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECHandicapper;

@interface ECPopulation : NSManagedObject

@property (nonatomic, retain) NSString *comments;
@property (nonatomic, retain) NSNumber *generationNumber;
@property (nonatomic, retain) NSDate *genesisDate;
@property (nonatomic, retain) NSNumber *initialSize;
@property (nonatomic, retain) NSNumber *maxTreeDepth;
@property (nonatomic, retain) NSNumber *minTreeDepth;
@property (nonatomic, retain) NSNumber *mutationRate;
@property (nonatomic, retain) NSString *populationName;
@property (nonatomic, retain) NSNumber *populationSize;
@property (nonatomic, retain) NSSet *handicappers;
@end

@interface ECPopulation (CoreDataGeneratedAccessors)

- (void)addHandicappersObject:(ECHandicapper *)value;
- (void)removeHandicappersObject:(ECHandicapper *)value;
- (void)addHandicappers:(NSSet *)values;
- (void)removeHandicappers:(NSSet *)values;

@end
