//
//  ECFirstTurnStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/21/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECDistanceClassStats;

@interface ECFirstTurnStats : NSManagedObject

@property (nonatomic, retain) NSNumber				*position;
@property (nonatomic, retain) NSNumber				*averagePositionSecondTurn;
@property (nonatomic, retain) ECDistanceClassStats	*distanceClassStats;

@end
