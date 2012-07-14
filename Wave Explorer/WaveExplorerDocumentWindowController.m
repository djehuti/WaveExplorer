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
#import "WaveExplorerChunkDetailViewController.h"


@interface WaveExplorerDocumentWindowController ()
{
    WaveExplorerDocument* mDocument;
    NSOutlineView* mOutlineView;
    NSView* mDetailView;
    NSView* mChunkDetailView;
}

@end


@implementation WaveExplorerDocumentWindowController

@synthesize document = mDocument;
@synthesize outlineView = mOutlineView;
@synthesize detailView = mDetailView;

- (void) dealloc
{
    [mOutlineView release];
    [mDetailView release];
    [mChunkDetailView release];
    [super dealloc];
}

- (WaveExplorerChunk*) selectedChunk
{
    WaveExplorerChunk* selectedChunk = nil;
    NSInteger selectedRow = [mOutlineView selectedRow];
    if (selectedRow >= 0) {
        selectedChunk = (WaveExplorerChunk*)[mOutlineView itemAtRow:selectedRow];
    }
    return selectedChunk;
}


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


#pragma mark - NSOutlineViewDelegate

- (void) outlineViewSelectionDidChange:(NSNotification*)notification
{
    [mChunkDetailView removeFromSuperview];
    [mChunkDetailView release];
    mChunkDetailView = nil;
    WaveExplorerChunk* selectedChunk = self.selectedChunk;
    if (selectedChunk) {
        WaveExplorerChunkDetailViewController* chunkDetailVC = [[WaveExplorerChunkDetailViewController alloc] initWithChunk:selectedChunk];
        mChunkDetailView = [chunkDetailVC.view retain];
        mChunkDetailView.frame = mDetailView.bounds;
        [mDetailView addSubview:mChunkDetailView];
        [chunkDetailVC release];
    }
}


#pragma mark - NSSplitViewDelegate

- (void) splitViewDidResizeSubviews:(NSNotification*)notification
{
    // Shouldn't the "autoresizes subviews" checkbox in IB, which is checked, accomplish this?
    if (mChunkDetailView) {
        mChunkDetailView.frame = mDetailView.bounds;
    }
}

@end
