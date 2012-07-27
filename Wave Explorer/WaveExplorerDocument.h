//
//  WaveExplorerDocument.h
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <Cocoa/Cocoa.h>


@class DWTWaveChunk;


@interface WaveExplorerDocument : NSDocument

@property (nonatomic, readonly, retain) DWTWaveChunk* riffChunk;

@end
