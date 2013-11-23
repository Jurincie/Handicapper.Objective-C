//
//  ECEntry.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/9/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ECEntry : NSObject

@property (nonatomic, retain) NSDate	*dateOfBirth;
@property (nonatomic, retain) NSString	*name;
@property (nonatomic, retain) NSString	*pastLines;
@property (nonatomic, retain) NSNumber	*breakPositionStrength;
@property (nonatomic, retain) NSNumber	*breakSpeedStrength;
@property (nonatomic, retain) NSNumber	*earlySpeedStrength;
@property (nonatomic, retain) NSNumber	*topSpeedStrength;
@property (nonatomic, retain) NSNumber	*lateSpeedStrength;
@property (nonatomic, retain) NSNumber	*collisionPropensity;
@property (nonatomic, retain) NSNumber	*insideOutsideTendency;
@property (nonatomic, retain) NSNumber	*recentClassStrength;

@end
