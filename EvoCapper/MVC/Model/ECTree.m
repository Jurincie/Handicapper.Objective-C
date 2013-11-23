//
//  TreeNode.m
//  GreVolution
//
//  Created by Ron Jurincie on 7/1/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "ECTree.h"

@implementation ECTree

@synthesize functionPtr         = _functionPtr;
@synthesize functionName        = _functionName;
@synthesize leftBranch			= _leftBranch;
@synthesize rightBranch			= _rightBranch;
@synthesize functionIndex       = _functionIndex;
@synthesize conditionTest       = _conditionTest;
@synthesize leafVariableIndex   = _leafVariableIndex;
@synthesize leafConstant        = _leafConstant;

- (id) initWithFunctionPointerIndex:(NSUInteger)funcPtrIndex
{
    if(self = [super init])
    {
        self.functionIndex      = funcPtrIndex;
		self.functionName		= @"notAFunction";
        self.functionPtr        = nil;
        self.leftBranch			= nil;
        self.rightBranch		= nil;
        self.leafVariableIndex  = NOT_AN_INDEX;
        self.leafConstant       = NOT_A_CONSTANT;
        
        switch (funcPtrIndex)
        {
            case 0:
                self.functionPtr    = add;
                self.functionName   = @"add";
                break;
                
            case 1:
                self.functionPtr    = subtract;
                self.functionName   = @"subtract";
                break;
                
            case 2:
                self.functionPtr    = multiply;
                self.functionName   = @"multiply";
                break;
                
            case 3:
                self.functionPtr    = divide;
                self.functionName   = @"divide";
                break;
                
            case 4:
                self.functionPtr    = squareRoot;
                self.functionName   = @"squareRoot";
                break;
                
            case 5:
                self.functionPtr    = square;
                self.functionName   = @"square";
                break;
                
            case 6:
                self.functionPtr    = naturalLog;
                self.functionName   = @"naturalLog";
                break;
                
            case 7:
                self.functionPtr    = reciprocal;
                self.functionName   = @"reciprocal";
                break;
                
            default:
                break;
        }
    }
    
    return self;
}

- (id) initWithConstantValue:(long double)c
{
    if(self = [super init])
    {
        self.leafConstant       = c;
        self.leafVariableIndex  = NOT_AN_INDEX;
        self.functionIndex      = NOT_AN_INDEX;
        self.functionPtr        = nil;
        self.functionName       = nil;
        self.leftBranch          = nil;
        self.rightBranch         = nil;
    }
    
    return self;
}

- (id) initWithRaceVariable:(NSUInteger)raceVariableIndex
{
    if(self = [super init])
    {
        self.leafVariableIndex  = raceVariableIndex;
        self.leafConstant       = NOT_A_CONSTANT;
        self.functionIndex      = NOT_AN_INDEX;
        self.functionPtr        = nil;
        self.functionName       = nil;
        self.leftBranch          = nil;
        self.rightBranch         = nil;
    }
    
    return self;
}

/**********************************************************/


/***************/
/* c functions */
/***************/
//
// overflow and underflow are ignored here
// to be trapped in evalTree method

long double add(double a, double b)
{
    return a + b;
}

long double subtract(double a, double b)
{
	return a - b;
}

long double multiply(double a, double b)
{
	return a * b;
}

long double divide(double a, double b)
{
  	long double answer = a / b;
    
	return answer;
}

long double squareRoot(double a)
{
    long double answer = 0.0;
    
	if(a < 0.0)
	{
		a       *= -1;
		answer  = pow(a, .5);
		answer  *= -1;
	}
	else
	{
		answer = pow(a, .5);
	}
    
	return answer;
}

long double square(double a)
{
    return a * a;
}

long double naturalLog(double a)
{
    // to use negative values
    // multiply by -1 => calculate ln => multiply back by -1
	long double answer = 0.0;
    
    if(a < 0)
    {
        a       *= -1;
        answer  = log(a);
        answer  *= -1;
    }
    else
    {
        answer = log(a);
    }
    
	return answer;
}

long double reciprocal(double a)
{
    long double answer = 1.0 / a;
    
    return answer;
}



@end
