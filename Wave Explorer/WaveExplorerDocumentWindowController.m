//
//  WaveExplorerDocumentWindowController.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/14/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerDocumentWindowController.h"
#import "WaveExplorerDocument.h"
#import "WaveExplorerChunk.h"


@interface WaveExplorerDocumentWindowController ()
{
    WaveExplorerDocument* mDocument;
}

@end


@implementation WaveExplorerDocumentWindowController

@synthesize document = mDocument;

#pragma mark - NSOutlineViewDataSource

- (NSInteger) outlineView:(NSOutlineView*)outlineView numberOfChildrenOfItem:(id)item
{
    return (item == nil) ? 1 : (NSInteger)[(WaveExplorerChunk*)item countOfSubchunks];
}

- (BOOL) outlineView:(NSOutlineView*)outlineView isItemExpandable:(id)item
{
    return (item == nil) ? YES : ([(WaveExplorerChunk*)item countOfSubchunks] > 0);
}

- (id) outlineView:(NSOutlineView*)outlineView child:(NSInteger)index ofItem:(id)item
{
    return (item == nil) ? mDocument.riffChunk : [(WaveExplorerChunk*)item objectInSubchunksAtIndex:(NSUInteger)index];
}

- (id) outlineView:(NSOutlineView*)outlineView objectValueForTableColumn:(NSTableColumn*)tableColumn byItem:(id)item
{
    if (item == nil) item = mDocument.riffChunk;
    id result = nil;
    if ([[tableColumn identifier] isEqualToString:@"Type"]) {
        result = [(WaveExplorerChunk*)item chunkID];
    }
    else if ([[tableColumn identifier] isEqualToString:@"Size"]) {
        result = [NSNumber numberWithUnsignedInteger:[(WaveExplorerChunk*)item chunkDataSize]];
    }
    else if ([[tableColumn identifier] isEqualToString:@"More"]) {
        result = [(WaveExplorerChunk*)item moreInfo];
    }
    return result;
}

@end
