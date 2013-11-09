//
//  ECRaceResults.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/9/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECRaceResults : NSObject

@property (assign)				double	winningTime;
@property (nonatomic, strong)	NSArray *postsFinalPositionArray;
@property (nonatomic, strong)	NSArray *postsFinalTimeArray;
@property (assign)				double	winPayout;
@property (assign)				double	placePayout;
@property (assign)				double	showPayout;
@property (assign)				double	quinellaPayout;
@property (assign)				double	perfectaPayout;
@property (assign)				double	trifectaPayout;
@property (assign)				double	superfectaPayout;
@property (assign)				double	dailyDoublePayout;

@end
