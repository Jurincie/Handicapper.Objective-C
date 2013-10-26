//
//  ECEvolutionManager.m
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

// Since we only want (1) EvolutionManager Ever to be created
// We have made this class a singleton

#import "ECEvolutionManager.h"
#import "Population.h"

@implementation ECEvolutionManager

@synthesize population                      = _population;
@synthesize generationsAlreadyEvolved       = _generationsAlreadyEvolved;
@synthesize trainingGenerationsThisCycle    = _trainingGenerationsThisCycle;


- (void)createNewPopoulationWithName:(NSString*)name
                                initialSize:(NSUInteger)initialSize
                               maxTreeDepth:(NSUInteger)maxTreeDepth
                               minTreeDepth:(NSUInteger)mintreeDepth
                        mutationRate:(float)mutationRate
                            comments:(NSString*)comments

{
    NSLog(@"createNewPopulation called in ECEvolutionManager");
    
    self.population = [NSEntityDescription insertNewObjectForEntityForName:@"HandicapperPopulation"
                                                    inManagedObjectContext: [[NSApp delegate] managedObjectContext]];
    
    if(self.population)
    {
        self.population.populationName  = @"NewPopulationTest 1.0.0.0";
        self.population.initialSize     = [NSNumber numberWithInteger:initialSize];
        self.population.minTreeDepth    = [NSNumber numberWithInteger:mintreeDepth];
        self.population.maxTreeDepth    = [NSNumber numberWithInteger:maxTreeDepth];
        self.population.genesisDate     = [NSDate date];
        self.population.mutationRate    = [NSNumber numberWithFloat:mutationRate];
        
        self.population.individualHandicappers = [self createNewHandicappers:initialSize];
    }
}

- (NSSet*)createNewHandicappers:(NSUInteger)initialPopSize
{
    NSMutableSet *handicappers = [NSMutableSet new];
    
    // create initial population
    for(int i = 0; i < initialPopSize; i++)
    {
        // iterate through dnaStrands
        for(int j = 0; j < kNumberDnaStrands; j++)
        {
            // iterate through dnaStrands
            NSString *tempDnaStrand = [self createRandomDnaStrandForStrand:j];
            
            [handicappers addObject:tempDnaStrand];
        }
        
        NSLog(@"Population member %i added %i strands", i, kNumberDnaStrands);
    }
    
    // note: returning makes immutable copy to fit return parameter type
    return handicappers;
}

- (NSString*)createRandomDnaStrandForStrand:(NSUInteger)strandNumber
{
    TreeNode *tempNode = [self createTreeForStrand:strandNumber
                                           atLevel:0];
    
    return [self saveTreeToString:tempNode];
}

- (NSString*)saveTreeToString:(TreeNode*)tree
{
    NSMutableString *treeString = [NSMutableString new];
    
    if(tree.functionPtr)
	{
		// append funcs name followed by the '('character
		[treeString appendString:tree.functionName];
		[treeString appendString:@"("];
		
		[self saveTreeToString:tree.leftChild];
		
		if(tree.rightChild != nil)
		{
			[treeString appendString:@","];
			[self saveTreeToString:tree.rightChild];
		}
		
		[treeString appendString:@")"];
		
	}
	else if(tree.leafVariableIndex != -1)
	{
		// append index in brackets[]
		[treeString appendString:[NSString stringWithFormat:@"%ld", (unsigned long)tree.leafVariableIndex]];
	}
	else
	{
		if(tree.leafConstant == 0.0)
		{
			NSLog(@"save tree error");
		}
		
		// append constant value
		[treeString appendString:[NSString stringWithFormat:@"%Lf", tree.leafConstant]];
	}
    
    
    return treeString;
}

- (TreeNode*) recoverTreeFromString:(NSString*)inString
{
    TreeNode *newTree           = nil;
	NSString *newString         = nil;
    NSString *newString2        = nil;
    NSString *token             = nil;
    NSString *arg1String        = nil;
    NSString *arg2String        = nil;
	NSUInteger numOpenParens    = 0;
    NSUInteger numClosedParens  = 0;
	NSUInteger commaIndex       = 0;
    NSUInteger parenIndex       = 0;
    NSUInteger numArgs          = 0;
    NSUInteger i                = 0;
    char letter                 = '$';
	BOOL gotFunction            = FALSE;
    NSUInteger myLength         = [inString length];
	
	// first errorcheck string: equalnumber open and closed parens
	while(i < myLength)
	{
		letter = [inString characterAtIndex:i++];
		
		if(letter == '(')
		{
			numOpenParens++;
		}
		else if(letter == ')')
		{
			numClosedParens++;
		}
	}
	
	i = 0;
	while(i < myLength)
	{
		letter = [inString characterAtIndex:i++];
		
		if(letter == '(')
		{
			gotFunction = TRUE;
			token = [inString substringToIndex:i-1];
			break;
		}
	}
	
	if(gotFunction)
	{
        newTree.functionName = token;
        
		if([token isEqualToString:@"add"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kAdditionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"subtract"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kSubtractionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"multiply"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kMultiplicationIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"divide"])
		{
			newTree =[[TreeNode alloc] initWithFunctionPointerIndex:kDivisionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"sqrt"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kSquareRootIndex];
			numArgs = 1;
		}
        else if([token isEqualToString:@"square"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kSquareIndex];
			numArgs = 1;
		}
		else if([token isEqualToString:@"naturalLog"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kNaturalLogIndex];;
			numArgs = 1;
		}
		else if([token isEqualToString:@"reciprocal"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kReciprocalIndex];
			numArgs = 1;
		}
		else
		{
			NSLog(@"bad function name in recoverTreeFromString");
			exit(1);
		}
		
		switch(numArgs)
		{
			case 1:
				parenIndex          = [self getIndexOfClosedParen:inString];
				newString           = [inString substringToIndex:parenIndex-1];
				arg1String          = [newString substringFromIndex:i];
				newTree.leftChild   = [self recoverTreeFromString:arg1String];
				
				break;
                
			case 2:
				parenIndex = [self getIndexOfClosedParen:inString];
				commaIndex = [self getIndexOfComma:inString];
				
				if(commaIndex == 0 || parenIndex <= commaIndex)
				{
					NSLog(@"xxx");
					exit(1);
				}
				
				newString = [inString substringToIndex:parenIndex-1];
				arg2String = [newString substringFromIndex:commaIndex];
				
				newString2 = [newString substringToIndex:commaIndex-1];
				arg1String = [newString2 substringFromIndex:i];
                
				newTree.leftChild   = [self recoverTreeFromString:arg1String];
				newTree.rightChild  = [self recoverTreeFromString:arg2String];
                
				break;
                
			default:
				NSLog(@"numArgs error in recoverTreeFromString");
				exit(1);
		}
	}
	else
	{
		// this token must either be an int between 1 - NUM_PAST_LINE_VARIABLES
		// or a doulbe
		if(inString.length <= 2)
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:[inString intValue]];
		}
		else
		{
			newTree = [[TreeNode alloc] initWithConstantValue:[inString doubleValue]];
		}
	}
	
	if(newTree.functionIndex >= 0 && newTree.functionIndex < 4)
	{
		if(newTree.leftChild == nil || newTree.rightChild == nil)
		{
			NSLog(@"recover error 1");
			exit(1);
		}
	}
	else if(newTree.functionIndex >= 4 && newTree.functionIndex < 9)
	{
		if(nil == newTree.leftChild || newTree.rightChild)
		{
			NSLog(@"recover error 2");
			exit(1);
		}
	}
	else if(newTree.leafConstant == 0.0 &&
            newTree.functionIndex == -1 &&
            newTree.leafVariableIndex == -1)
	{
		NSLog(@"recover error 3");
		exit(1);
	}
	else if((nil == newTree.functionPtr || newTree.functionIndex == -1) &&
            (newTree.leftChild || newTree.rightChild))
	{
		
		NSLog(@"recover error 4");
		exit(1);
	}
    
    return newTree;
}

- (NSUInteger)getIndexOfComma:(NSString*)inString
{
	NSUInteger commaIndex   = 0;
    NSUInteger level        = 0;
    NSUInteger  myLength    = [inString length];
	char letter             = '$';
	
	while(commaIndex < myLength)
	{
		letter = [inString characterAtIndex:commaIndex++];
        
		if(letter == '(')
		{
			level++;
		}
		else if(letter == ')')
		{
			level--;
		}
		else if(letter == ',' && level == 1)
		{
            break;
		}
	}
	
	return commaIndex;
}

- (NSUInteger) getIndexOfClosedParen:(NSString*)inString
{
    NSUInteger closedParenIndex = 0;
    NSInteger level             = 0;
    NSInteger myLength          = [inString length];
    char letter                 = '$';
    
	while(closedParenIndex < myLength)
	{
		letter = [inString characterAtIndex:closedParenIndex++];
        
		if(letter == '(')
		{
			level++;
		}
		else if(letter == ')')
		{
			level--;
			
			if(level == 0)
			{
				break;
			}
			
			if(level < 0)
			{
				NSLog(@"unbalanced parenthesis in tree error 1");
				break;
			}
		}
	}
    
    return closedParenIndex;
}


- (TreeNode*)createTreeForStrand:(NSUInteger)dnaStrand
                         atLevel:(NSUInteger)level
{
	// tree is made of TreeNodes
	// as we get deeper into the tree increase probability of leaf node
	
    TreeNode *newTreeNode       = nil;
	double val                  = 0.0;
	double probabilityOfFunc    = 0.0;
	NSInteger numArgs           = 0;
	double randVal              = 0.0;
	NSUInteger funcIndex        = 0;
	NSUInteger minTreeDepth     = [self.population.minTreeDepth intValue];
	NSUInteger maxTreeDepth     = [self.population.maxTreeDepth intValue];
    int quadraticProbability    = .075;
    
	val = rand() % 100;
	
	level++;
    
	if(level < minTreeDepth)
	{
		probabilityOfFunc = 100.0;
	}
	else if(level >= maxTreeDepth)
	{
		probabilityOfFunc = 0.0;
    }
	else
	{
		probabilityOfFunc = 100.0 * (1.0 - ((double)(level - minTreeDepth) /
                                            (maxTreeDepth - minTreeDepth)));
	}
	
	if(val < probabilityOfFunc)	// get a random function node
	{
		if(getRand(1, kRandomGranularity) < quadraticProbability)
		{
			newTreeNode = [self getQuadraticNodeAtLevel:level
                                              forStrand:dnaStrand];
		}
		else
		{
			if(level < minTreeDepth)
			{
				funcIndex = rand() % kNumberFunctions;
                
                if(funcIndex < kNumberTwoArgFuncs) // 2 arg funcs at front of array
                {
                    numArgs = 2;
                }
                else
                {
                    numArgs = 1;
                }
			}
            
			newTreeNode = [[TreeNode alloc] initWithRaceVariable:funcIndex];
			
			switch(numArgs)
			{
				case 1:
                    newTreeNode.rightChild  = nil;
                    newTreeNode.leftChild   = [self createTreeForStrand:dnaStrand
                                                                atLevel:level];
                    break;
                    
				case 2:
                    newTreeNode.leftChild   = [self createTreeForStrand:dnaStrand
                                                                atLevel:level];
                    newTreeNode.rightChild  = [self createTreeForStrand:dnaStrand
                                                                atLevel:level];
			}
		}
	}
	else if(val < .66667) // get coresponding variable node aprox 2/3 of the time
	{
		// get Positive int value above kLTV
		while((randVal = getRand(kRandomRange, kRandomGranularity)) < kLowestTolerableValue)
            
            // comment out next 4 lines to keep all constants positive
            //        if(rand()%2)
            //        {
            //            randVal *= -1;
            //        }
            
            // assign as double value
            newTreeNode = [[TreeNode alloc] initWithConstantValue:randVal];
	}
	else
	{
        // in this situation, insert a pastLine variable into leaf node
		NSUInteger variableIndex    = [self getPastLineVariableForDnaStrand:dnaStrand];
		newTreeNode                 = [[TreeNode alloc] initWithRaceVariable:variableIndex];
	}
    
	return newTreeNode;
}

- (NSUInteger)getPastLineVariableForDnaStrand:(NSUInteger)dnaStrand
{
    // since each dnaStrand uses a subset of all raceLine variables
    // we carefully assign appropriate indices for later dereferencing the PastLineArray
    // Here is the map of the PastLine
    
    // 0:  weight
    // 1:  race distance
    // 2:  race class
    // 3:  track name
    // 4:  track conditions
    // 5:  past race date
    // 6:  number of entries
    // 7:  post number
    // 8:  position at break
    // 9:  position turn 1
    // 10: position turn 2
    // 11: position at finish
    // 12: entry time
    // 13: lead by lengths 1
    // 14: lead by lengths 2
    // 15: lead by lengths final
    // 16: delat 1
    // 17: delta 2
    // 18: delta 3
    // 19: winning time
    // 20: comments
    
    // dna variables by strand
    //
    // 0: break speed strength
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    //      6:  number of entrys
    //      8:  position at break
    //      9:  winning time
    
    
    // 1: early speed
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    //      8:  position at break
    //      9:  winning time
    //      13: lead by lengths 1
    //      16: delta 1
    
    // 2: top speed
    //      5:  raceDate (used to calculate "days ago")
    //      9:  winning time
    //      12: entry time
    //      16: delta 1
    //      17: delta 2
    //      18: delta 3
    
    
    // 3: late speed
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    //      8:  position at break
    //      9:  winning time
    //      13: lead by lengths 1
    //      16: delta 3
    
    // 4: inside or outside preference
    //      20: comments
    
    
    // 5: class
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    //      6:  number of entries
    //      9:  winning time
    //      11: position at finish
    //      12: entry time
    
    NSUInteger pastLineVariableIndex = 0;
    
    switch (dnaStrand)
    {
        case 0:
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 3;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 5;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 9;
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
            
        case 1:
        {
            NSUInteger varIndex = rand() % 6;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 5;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 13;
                    break;
                    
                case 5:
                    pastLineVariableIndex = 16;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 2:
        {
            NSUInteger varIndex = rand() % 6;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 5;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 12;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 16;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 17;
                    break;
                    
                case 5:
                    pastLineVariableIndex = 18;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 3:
        {
            NSUInteger varIndex = rand() % 6;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 5;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 13;
                    break;
                    
                case 5:
                    pastLineVariableIndex = 16;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 4:
            pastLineVariableIndex = 20;
            break;
            
        case 5:
        {
            NSUInteger varIndex = rand() % 6;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 5;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 6;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 11;
                    break;
                    
                case 5:
                    pastLineVariableIndex = 12;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        default:
            break;
    }
    
    return pastLineVariableIndex;
}


- (TreeNode*)getQuadraticNodeAtLevel:(NSUInteger)level
                           forStrand:(NSUInteger)dnaStrand
{
    // creates the form:  a(x^2) + bx + c
	//  where a, b and c are derived from independent tree branches
	//  and X is a random pastLine variable
	
	double x = getRand(kRandomRange, kRandomGranularity);
    level++;
    
	TreeNode *quadTree                          = [[TreeNode alloc] initWithFunctionPointerIndex:kAdditionIndex];       // add
    
	quadTree.leftChild.leftChild                = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level+1];                                   // 'a' branch
	quadTree.leftChild                          = [[TreeNode alloc] initWithFunctionPointerIndex:kMultiplicationIndex]; // mult
    quadTree.leftChild.rightChild               = [[TreeNode alloc] initWithConstantValue:x];                           // 'x'
	quadTree.leftChild.rightChild.leftChild     = [[TreeNode alloc] initWithFunctionPointerIndex:kSquareIndex];         // square
    
	
	quadTree.rightChild                         = [[TreeNode alloc] initWithFunctionPointerIndex:kAdditionIndex];       // add
	quadTree.rightChild.leftChild.leftChild     = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level+1];                                   // 'b' branch
	quadTree.rightChild.leftChild               = [[TreeNode alloc] initWithFunctionPointerIndex:kMultiplicationIndex]; // multiply
	quadTree.rightChild.leftChild.rightChild    = [[TreeNode alloc] initWithConstantValue:x];                           // 'x'
	quadTree.rightChild.rightChild              = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level];                                     // 'c' branch
	return quadTree;
}



- (void)trainPopulation:(Population*)poplation
         forGenerations:(NSUInteger)numberGenerationsToTrain
{
    NSLog(@"trainPopulation called in ECEvolutionManager");
    
    for(NSUInteger localGenNumber = 0; localGenNumber < numberGenerationsToTrain; localGenNumber++)
    {
        
    }
        
    [self updateAndSaveData];
}

- (void)updateAndSaveData
{
    
}

#pragma mark Singleton Methods

+ (id)sharedManager
{
    static ECEvolutionManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

- (id)init
{
    
    NSLog(@"ECEVolutionManager.init called");
    
    if (self = [super init])
    {
        // seed random number generator here ONLY
        time_t seed = time(NULL);
        srand((unsigned) time(&seed));
        
        self.population                     = nil;
        self.generationsAlreadyEvolved      = 0;
        self.trainingGenerationsThisCycle   = 0;
    }
    
    return self;
}

@end
