//
//  ECPastLineRecord.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/14/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECPastLineRecord : NSObject

@property (nonatomic, strong)	NSDate		*raceDate;
@property (nonatomic, strong)	NSString	*trackName;
@property (nonatomic, strong)	NSString	*raceClass;
@property (nonatomic, strong)	NSString	*trackConditions;

@property (assign)				NSUInteger	numberEntries;
@property (assign)				double		raceDistance;
@property (assign)				double		weight;
@property (assign)				double		winOdds;

@property (assign)				BOOL		foundTrouble;
@property (assign)				BOOL		scratched;
@property (assign)				BOOL		didNotFinish;
@property (assign)				BOOL		matinee;

@property (assign)				double		postPosition;
@property (assign)				double		breakPosition;
@property (assign)				double		firstTurnPosition;
@property (assign)				double		topOfStretchPosition;
@property (assign)				double		finishPosition;

@property (assign)				double		deltaPosition1;
@property (assign)				double		deltaPosition2;
@property (assign)				double		deltaPosition3;
@property (assign)				double		deltaLengths1;
@property (assign)				double		deltaLengths2;

@property (assign)				double		lengthsLeadFirstTurn;
@property (assign)				double		lengthsLeadTopOfStretch;
@property (assign)				double		lengthsLeadFinish;

@property (assign)				double		entryTime;
@property (assign)				double		winningTime;
@property (nonatomic, strong)	NSString	*comments;

@end
