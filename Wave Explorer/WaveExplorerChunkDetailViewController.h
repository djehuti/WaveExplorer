//
//  WaveExplorerChunkDetailViewController.h
//  Wave Explorer
//
//  Created by Ben Cox on 7/14/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <Cocoa/Cocoa.h>


@class DWTWaveChunk;


@interface WaveExplorerChunkDetailViewController : NSViewController

- (id) initWithChunk:(DWTWaveChunk*)chunk; // DI

@property (nonatomic, readonly, assign) DWTWaveChunk* chunk;

- (NSAttributedString*) dataDump;

@end
