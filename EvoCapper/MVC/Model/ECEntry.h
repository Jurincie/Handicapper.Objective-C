//
//  Entry.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/25/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ECEntry : NSManagedObject

@property (nonatomic, retain) NSDate    *dateOfBirth;
@property (nonatomic, retain) NSString  *name;
@property (nonatomic, retain) NSString  *pastLines;

@end
