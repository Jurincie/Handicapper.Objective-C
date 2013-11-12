//
//  ECRaceResults.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/9/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECRacePayouts.h"

@interface ECRaceResults : NSObject

@property (assign)				double	winningTime;
@property (nonatomic, strong)	NSArray *postsFinishPositionArray;
@property (nonatomic, strong)	NSArray *postsFinishTimeArray;

- (ECRaceResults*)initWithFinishPositionsArray:(NSArray*)finishPositionsByPost
							andFinishTimeArray:(NSArray*)finishTimesByPost;


@end
