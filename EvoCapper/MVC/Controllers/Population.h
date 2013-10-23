//
//  Population.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Handicapper;

@interface Population : NSManagedObject

@property (nonatomic, retain) NSString  *comments;
@property (nonatomic, retain) NSNumber  *generationsNumber;
@property (nonatomic, retain) NSDate    *genesisDate;
@property (nonatomic, retain) NSNumber  *initialSize;
@property (nonatomic, retain) NSNumber  *maxTreeDepth;
@property (nonatomic, retain) NSNumber  *minTreeDepth;
@property (nonatomic, retain) NSNumber  *mutationRate;
@property (nonatomic, retain) NSString  *populationName;
@property (nonatomic, retain) NSNumber  *populationSize;
@property (nonatomic, retain) NSSet     *individualHandicapper;
@end

@interface Population (CoreDataGeneratedAccessors)

- (void)addIndividualHandicapperObject:(Handicapper *)value;
- (void)removeIndividualHandicapperObject:(Handicapper *)value;
- (void)addIndividualHandicapper:(NSSet *)values;
- (void)removeIndividualHandicapper:(NSSet *)values;

@end
