//
//  DWTWaveChunk.h
//  WaveTools
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <Foundation/Foundation.h>


extern const NSUInteger kDWTWaveChunkHeaderSize;    // This is 8.
extern const NSUInteger kDWTWaveChunkIDSize;        // This is 4.


@interface DWTWaveChunk : NSObject

@property (nonatomic, readwrite, retain) NSString* chunkID;
@property (nonatomic, readwrite, assign) NSUInteger chunkDataSize;
@property (nonatomic, readwrite, assign) DWTWaveChunk* parentChunk; // Unretained backpointer.
@property (nonatomic, readwrite, copy) NSArray* subchunks;
@property (nonatomic, readonly, retain) NSString* moreInfo;

// Subchunk property accessor methods.

- (NSUInteger) countOfSubchunks;
- (DWTWaveChunk*) objectInSubchunksAtIndex:(NSUInteger)index;
- (void) getSubchunks:(DWTWaveChunk**)buffer range:(NSRange)inRange;

- (void) insertObject:(DWTWaveChunk*)object inSubchunksAtIndex:(NSUInteger)index;
- (void) removeObjectFromSubchunksAtIndex:(NSUInteger)index;
- (void) replaceObjectInSubchunksAtIndex:(NSUInteger)index withObject:(DWTWaveChunk*)object;

- (void) appendSubchunk:(DWTWaveChunk*)subchunk;

- (id) initWithData:(NSData*)data; // Designated Initializer.

// Registration

+ (DWTWaveChunk*) chunkForData:(NSData*)data;
+ (void) registerChunkClasses;
// If a class wants more info about a chunk than just its type and length before deciding
// to handle it, it can override this method to examine the data and return NO if it wants
// to pass the buck. The base class implementation just returns YES.
// This way you can build multiple classes to handle different variants of a single chunk type.
+ (BOOL) canHandleChunkWithData:(NSData*)data;

// Utility
+ (NSArray*) processChunksInData:(NSData*)data;
// If this returns a value other than NSUIntegerMax, we will automatically process subchunks
// in -initWithData:, beginning at the given offset within the chunk data.
// Do not include this chunk's header type ID and size; this is an offset within the chunk data.
// For example, the base class returns 0.
+ (NSUInteger) autoProcessSubchunkOffset;

+ (NSString*) read4CharFromData:(NSData*)data atOffset:(NSUInteger)offset;
+ (uint32_t) readUint32FromData:(NSData*)data atOffset:(NSUInteger)offset;
+ (uint16_t) readUint16FromData:(NSData*)data atOffset:(NSUInteger)offset;

// Debugging
- (NSString*) additionalDebugInfo;

@end
