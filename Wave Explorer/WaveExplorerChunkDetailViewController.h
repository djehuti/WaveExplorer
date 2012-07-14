//
//  WaveExplorerChunkDetailViewController.h
//  Wave Explorer
//
//  Created by Ben Cox on 7/14/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <Cocoa/Cocoa.h>


@class WaveExplorerChunk;


@interface WaveExplorerChunkDetailViewController : NSViewController

- (id) initWithChunk:(WaveExplorerChunk*)chunk; // DI

@property (nonatomic, readonly, assign) WaveExplorerChunk* chunk;

@end
