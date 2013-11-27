//
//  Constants.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/25/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

// define reprocuction type AND fitness selection method

#define kLinearFitnessSelection 0
#define kSuaredFitnessSelection 1

#define kMonogomousPairsMethod 0
#define kAlphasMalesDominateMethod 1
#define kOrgyMethod 1

#define kSelectionMethod kSuaredFitnessSelection
#define kReproductionType kMonogomousPairsMethod

///////////////////////////

#ifndef EvoCapper_Constants_h
#define EvoCapper_Constants_h

#define kNumberRaceDataPoints 4 // post position, 1st turn position, , 2nd turn position, top of stretch position

#define kMaximumNumberEntries 8
#define kRandomRange 2.0
#define kRandomGranularity 8
#define kLowestTolerableValue 1.0 / pow(10,kRandomGranularity)


#define kMaximumNumberEntries 8
#define kNumberDnaStrands 8
#define kNumberFunctions 8
#define kNumberTwoArgFuncs 4

#define kBreakPositionStrand 0
#define kBreakSpeedStrand 1
#define kEarlySpeedStrand 2
#define kTopSpeedStrand 3
#define kLateSpeedStrand 4
#define kRecentClassStrand 5
#define kEarlySpeedRelevanceStrand 6
#define kOtherRelevanceStrand 7

#define kTreeRoot 0

#define kAdditionIndex 0
#define kSubtractionIndex 1
#define kMultiplicationIndex 2
#define kDivisionIndex 3
#define kSquareRootIndex 4
#define kSquareIndex 5
#define kNaturalLogIndex 6
#define kReciprocalIndex 7

// tree helpers
#define kFunctionNode 0
#define kVariableNode 1
#define kConstantNode 2
#define kUndefinedNode 999

// Rrlevance Tree vals
#define kMinLevelForRelevanceTrees 3
#define kMaxLevelForRelevanceTrees 4

#define NOT_AN_INDEX 999999
#define NOT_A_CONSTANT 0.0

//const NSString *kPastLinesFoldlerPath = @"/Users/ronjurincie/Desktop/Greyhound Central/Modified Dog Histories";

#endif
