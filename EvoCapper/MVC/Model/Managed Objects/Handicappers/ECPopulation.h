//
//  ECPopulation.h
//  EvoCapper
//
//  Created by Ron Jurincie on 2/15/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECHandicapper;

@interface ECPopulation : NSManagedObject

@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSNumber * generationNumber;
@property (nonatomic, retain) NSDate * genesisDate;
@property (nonatomic, retain) NSNumber * initialSize;
@property (nonatomic, retain) NSNumber * maxTreeDepth;
@property (nonatomic, retain) NSNumber * minTreeDepth;
@property (nonatomic, retain) NSNumber * mutationRate;
@property (nonatomic, retain) NSString * populationName;
@property (nonatomic, retain) NSNumber * populationSize;
@property (nonatomic, retain) NSSet *individualHandicappers;
@end

@interface ECPopulation (CoreDataGeneratedAccessors)

- (void)addIndividualHandicappersObject:(ECHandicapper *)value;
- (void)removeIndividualHandicappersObject:(ECHandicapper *)value;
- (void)addIndividualHandicappers:(NSSet *)values;
- (void)removeIndividualHandicappers:(NSSet *)values;

@end
