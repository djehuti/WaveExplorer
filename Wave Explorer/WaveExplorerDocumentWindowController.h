//
//  WaveExplorerDocumentWindowController.h
//  Wave Explorer
//
//  Created by Ben Cox on 7/14/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <Cocoa/Cocoa.h>


@class WaveExplorerDocument;
@class DWTWaveChunk;


@interface WaveExplorerDocumentWindowController : NSWindowController <NSOutlineViewDataSource, NSOutlineViewDelegate, NSSplitViewDelegate>

@property (nonatomic, readwrite, assign) WaveExplorerDocument* document;
@property (nonatomic, readonly, retain) DWTWaveChunk* selectedChunk;

@property (nonatomic, readwrite, retain) IBOutlet NSOutlineView* outlineView;
@property (nonatomic, readwrite, retain) IBOutlet NSView* detailView;

@end
