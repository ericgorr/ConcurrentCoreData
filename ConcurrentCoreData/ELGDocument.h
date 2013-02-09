//
//  ELGDocument.h
//  ConcurrentCoreData
//
//  Created by Eric Gorr on 2/2/13.
//  Copyright (c) 2013 Eric Gorr. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@class ELGWorkerOperation;



@interface ELGDocument : NSPersistentDocument <NSWindowDelegate>


@property (strong) NSOperationQueue*		queue;
@property (strong) ELGWorkerOperation*		operation;
@property (strong) NSNumber*				autosaves;



- (IBAction) actionPlus:(id)sender;



@end
