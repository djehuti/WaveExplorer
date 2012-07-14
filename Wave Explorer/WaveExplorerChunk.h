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
// If a class wants more info about a chunk than just its type and length before deciding
// to handle it, it can override this method to examine the data and return NO if it wants
// to pass the buck. The base class implementation just returns YES.
// This way you can build multiple classes to handle different variants of a single chunk type.
+ (BOOL) canHandleChunkWithData:(NSData*)data;
// The nib name for the chunk detail view. Base class returns "WaveExplorerChunk".
// If you override this, you should return your class name.
// But not as NSClassFromString([self class]) because that will break subclasses that
// don't have their own nibs. Do it as a string literal.
+ (NSString*) nibName;

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
