//
//  ECEntryStrengthFields.m
//  EvoCapper
//
//  Created by Ron Jurincie on 11/15/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "ECEntryStrengthFields.h"

@implementation ECEntryStrengthFields

@synthesize breakPositionStrength		= _breakPositionStrength;
@synthesize breakSpeedStrength			= _breakSpeedStrength;
@synthesize earlySpeedStrength			= _earlySpeedStrength;
@synthesize topSpeedStrength			= _topSpeedStrength;
@synthesize lateSpeedStrength			= _lateSpeedStrength;
@synthesize recentClassStrength			= _recentClassStrength;
@synthesize earlySpeedRelevanceFactor	= _earlySpeedRelevanceFactor;
@synthesize otherRelevanceFactor		= _otherRelevanceFactor;
@synthesize numberOfCollisions			= _numberOfCollisions;
@synthesize numberPastLines				= _numberPastLines;
@synthesize insideOutsideTendancy		= _insideOutsideTendancy;

- (ECEntryStrengthFields*)init
{
	self = [super init];
	
	if(self)
	{
		self.breakPositionStrength		= 0.0;
		self.breakSpeedStrength			= 0.0;
		self.earlySpeedStrength			= 0.0;
		self.topSpeedStrength			= 0.0;
		self.lateSpeedStrength			= 0.0;
		self.recentClassStrength		= 0.0;
		self.earlySpeedRelevanceFactor	= 0.0;
		self.otherRelevanceFactor		= 0.0;
		self.numberOfCollisions			= 0;
		self.numberPastLines			= 0;
		self.insideOutsideTendancy		= 0.0;
	}
	
	return self;
}

@end
