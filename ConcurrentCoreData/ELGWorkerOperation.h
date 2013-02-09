//
//  ELGWorkerOperation.h
//  ConcurrentCoreData
//
//  Created by Eric Gorr on 2/2/13.
//  Copyright (c) 2013 Eric Gorr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELGWorkerOperation : NSOperation


@property (strong) NSManagedObjectContext*			moc;
@property (strong) NSPersistentStoreCoordinator*	psc;

@end
