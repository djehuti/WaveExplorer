//
//  WaveExplorerDocument.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerDocument.h"
#import "WaveExplorerChunk.h"


@interface WaveExplorerDocument ()
{
    WaveExplorerChunk* mRiffChunk;
}
@end


@implementation WaveExplorerDocument

+ (void) initialize
{
    if (self == [WaveExplorerDocument class]) {
        [WaveExplorerChunk registerChunkClasses];
    }
}

- (void) dealloc
{
    [mRiffChunk release];
    mRiffChunk = nil;
    [super dealloc];
}

- (NSString*) windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"WaveExplorerDocument";
}

- (NSData*) dataOfType:(NSString*)typeName error:(NSError**)outError
{
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return nil;
}

- (BOOL) readFromData:(NSData*)data ofType:(NSString*)typeName error:(NSError**)outError
{
    BOOL result = NO;
    [mRiffChunk release];
    mRiffChunk = nil;
    NSArray* chunks = [[WaveExplorerChunk class] processChunksInData:data];
    if ([chunks count] == 1) {
        WaveExplorerChunk* firstChunk = [chunks objectAtIndex:0];
        if ([firstChunk.chunkID isEqualToString:@"RIFF"]) {
            mRiffChunk = [firstChunk retain];
            result = YES;
        }
    }
    return result;
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
    return (item == nil) ? mRiffChunk : [(WaveExplorerChunk*)item objectInSubchunksAtIndex:(NSUInteger)index];
}

- (id) outlineView:(NSOutlineView*)outlineView objectValueForTableColumn:(NSTableColumn*)tableColumn byItem:(id)item
{
    if (item == nil) item = mRiffChunk;
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
