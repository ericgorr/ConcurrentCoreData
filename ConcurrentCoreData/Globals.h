//
//  Globals.h
//  ConcurrentCoreData
//
//  Created by Eric Gorr on 2/9/13.
//  Copyright (c) 2013 Eric Gorr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Globals : NSManagedObject

@property (nonatomic, retain) NSNumber * counterA;
@property (nonatomic, retain) NSNumber * autosave;

@end
