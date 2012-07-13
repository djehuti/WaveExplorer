//
//  WaveExplorerChunk.h
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface WaveExplorerChunk : NSObject

@property (nonatomic, readwrite, retain) NSString* chunkID;
@property (nonatomic, readwrite, assign) NSUInteger chunkDataSize;
@property (nonatomic, readwrite, copy) NSArray* subchunks;
@property (nonatomic, readonly, retain) NSString* moreInfo;

// Subchunk property accessor methods.

- (NSUInteger) countOfSubchunks;
- (WaveExplorerChunk*) objectInSubchunksAtIndex:(NSUInteger)index;
- (void) getSubchunks:(WaveExplorerChunk**)buffer range:(NSRange)inRange;

- (void) insertObject:(WaveExplorerChunk*)object inSubchunksAtIndex:(NSUInteger)index;
- (void) removeObjectFromSubchunksAtIndex:(NSUInteger)index;
- (void) replaceObjectInSubchunksAtIndex:(NSUInteger)index withObject:(WaveExplorerChunk*)object;

- (void) appendSubchunk:(WaveExplorerChunk*)subchunk;

- (id) initWithData:(NSData*)data; // Designated Initializer.

// Registration

+ (WaveExplorerChunk*) chunkForData:(NSData*)data;
+ (void) registerChunkClasses;

// Utility
+ (NSArray*) processChunksInData:(NSData*)data;
// If this returns a value other than NSUIntegerMax, we will automatically process subchunks
// in -initWithData:, beginning at the given offset within the chunk data.
// Do not include this chunk's header type ID and size; this is an offset within the chunk data.
// For example, the base class returns 0.
+ (NSUInteger) autoProcessSubchunkOffset;

+ (uint32_t) readUint32FromData:(NSData*)data atOffset:(NSUInteger)offset;
+ (uint16_t) readUint16FromData:(NSData*)data atOffset:(NSUInteger)offset;

// Debugging
- (NSString*) additionalDebugInfo;

@end
