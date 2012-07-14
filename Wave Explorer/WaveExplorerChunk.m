//
//  WaveExplorerChunk.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerChunk.h"
#import "WaveExplorerUnknownChunk.h"


#define kWaveExplorerChunkIDSize 4
#define kWaveExplorerChunkHeaderSize 8


#pragma mark Utility Registration

static NSMutableDictionary* s_registeredChunkClasses = nil;
static dispatch_once_t s_registeredChunkOnce;


#pragma mark -

@interface WaveExplorerChunk ()
{
    NSString* mChunkID;
    NSUInteger mChunkDataSize;
    NSMutableArray* mSubchunks;
}

+ (NSString*) p_chunkTypeFromData:(NSData*)data;
+ (NSUInteger) p_chunkLengthFromData:(NSData*)data;
+ (void) p_registerChunkClass:(Class)chunkClass forType:(NSString*)chunkType;

@end


#pragma mark -

@implementation WaveExplorerChunk

#pragma mark Properties

@synthesize chunkDataSize = mChunkDataSize;

- (NSString*) chunkID
{
    return mChunkID;
}

- (void) setChunkID:(NSString*)chunkID
{
    if (chunkID != mChunkID) {
        // TODO: Validate that [chunkID length] == kWaveExplorerChunkIDSize.
        [chunkID retain];
        [mChunkID release];
        mChunkID = chunkID;
    }
}

- (NSArray*) subchunks
{
    return [NSArray arrayWithArray:mSubchunks];
}

- (void) setSubchunks:(NSArray*)subchunks
{
    [mSubchunks removeAllObjects];
    // TODO: Validate that all of the objects in the array are WaveExplorerChunks.
    [mSubchunks addObjectsFromArray:subchunks];
}

- (NSUInteger) countOfSubchunks
{
    return [mSubchunks count];
}

- (WaveExplorerChunk*) objectInSubchunksAtIndex:(NSUInteger)index
{
    return (WaveExplorerChunk*)[mSubchunks objectAtIndex:index];
}

- (void) getSubchunks:(WaveExplorerChunk**)buffer range:(NSRange)inRange
{
    return [mSubchunks getObjects:buffer range:inRange];
}

- (void) insertObject:(WaveExplorerChunk*)object inSubchunksAtIndex:(NSUInteger)index
{
    [mSubchunks insertObject:object atIndex:index];
}

- (void) removeObjectFromSubchunksAtIndex:(NSUInteger)index
{
    [mSubchunks removeObjectAtIndex:index];
}

- (void) replaceObjectInSubchunksAtIndex:(NSUInteger)index withObject:(WaveExplorerChunk*)object
{
    [mSubchunks replaceObjectAtIndex:index withObject:object];
}

- (void) appendSubchunk:(WaveExplorerChunk*)subchunk
{
    [mSubchunks addObject:subchunk];
}

- (NSString*) moreInfo
{
    return @"RIFF Chunk";
}

#pragma mark Lifecycle

- (id)init
{
    static unsigned char s_emptyChunkData[kWaveExplorerChunkHeaderSize] = { 'R', 'I', 'F', 'F', 0, 0, 0, 0 };

    NSMutableData* emptyChunkData = [NSMutableData dataWithBytesNoCopy:&s_emptyChunkData[0] length:sizeof(s_emptyChunkData) freeWhenDone:NO];
    return [self initWithData:emptyChunkData];
}

- (id) initWithData:(NSData*)data
{
    if ((self = [super init])) {
        if ([data length] < kWaveExplorerChunkHeaderSize) {
            [self release];
            self = nil;
        } else {
            mChunkDataSize = [[self class] p_chunkLengthFromData:data];
            if ([data length] != mChunkDataSize + kWaveExplorerChunkHeaderSize) {
                [self release];
                self = nil;
            } else {
                mChunkID = [[[self class] p_chunkTypeFromData:data] retain];
                mSubchunks = [[NSMutableArray alloc] init];
                NSUInteger subchunkOffset = [[self class] autoProcessSubchunkOffset];
                // Gotta be enough data for at least one subchunk header in there.
                if (subchunkOffset != NSUIntegerMax && [data length] > (subchunkOffset + kWaveExplorerChunkHeaderSize)) {
                    const void* bytes = [data bytes];
                    const void* base = bytes + subchunkOffset + kWaveExplorerChunkHeaderSize;
                    NSData* subchunkData = [[NSData alloc] initWithBytesNoCopy:(void*)base length:(mChunkDataSize - subchunkOffset) freeWhenDone:NO];
                    [mSubchunks addObjectsFromArray:[[self class] processChunksInData:subchunkData]];
                    [subchunkData release];
                }
            }
        }
    }
    return self;
}

- (void) dealloc
{
    [mChunkID release];
    mChunkID = nil;
    mChunkDataSize = 0;
    [mSubchunks release];
    mSubchunks = nil;
    [super dealloc];
}

#pragma mark - Registration

+ (WaveExplorerChunk*) chunkForData:(NSData*)data
{
    WaveExplorerChunk* result = nil;
    NSString* chunkType = [self p_chunkTypeFromData:data];
    if (chunkType) {
        Class chunkClass = Nil;
        NSArray* classesForType = [s_registeredChunkClasses objectForKey:chunkType];
        if (classesForType) {
            for (Class candidateClass in classesForType) {
                if ([candidateClass canHandleChunkWithData:data]) {
                    chunkClass = candidateClass;
                    break;
                }
            }
        }
        if (chunkClass == Nil) {
            chunkClass = [WaveExplorerUnknownChunk class];
        }
        result = [[[chunkClass alloc] initWithData:data] autorelease];
    }
    return result;
}

+ (void) registerChunkClasses
{
    NSLog(@"Loading chunk classes...");
    NSUInteger chunkTypeCount = 0;
    NSUInteger chunkClassCount = 0;
    NSUInteger chunkClassOK = 0;
    NSString* dictPath = [[NSBundle mainBundle] pathForResource:@"WaveExplorerChunkClasses" ofType:@"plist"];
    NSDictionary* chunkDict = [NSDictionary dictionaryWithContentsOfFile:dictPath];
    for (id<NSObject> chunkTypeKey in [chunkDict allKeys]) {
        if (![chunkTypeKey isKindOfClass:[NSString class]]) {
            NSLog(@"Bad key %@ in class dictionary", chunkTypeKey);
            continue;
        }
        NSString* chunkType = (NSString*)chunkTypeKey;
        ++chunkTypeCount;
        id<NSObject> chunkMapObject = [chunkDict objectForKey:chunkTypeKey];
        NSArray* chunkClasses = nil;
        if ([chunkMapObject isKindOfClass:[NSArray class]]) {
            chunkClasses = (NSArray*)chunkMapObject;
        }
        else if ([chunkMapObject isKindOfClass:[NSString class]]) {
            chunkClasses = [NSArray arrayWithObject:chunkMapObject];
        }
        else {
            NSLog(@"Bad object %@ in class dictionary for chunk type '%@'", chunkMapObject, chunkType);
            continue;
        }
        for (id<NSObject> chunkClassObject in chunkClasses) {
            if (![chunkClassObject isKindOfClass:[NSString class]]) {
                NSLog(@"Bad object %@ in class name list for chunk type '%@'", chunkClassObject, chunkType);
                continue;
            }
            ++chunkClassCount;
            NSString* chunkClassName = (NSString*)[chunkDict objectForKey:chunkType];
            Class chunkClass = NSClassFromString(chunkClassName);
            if (chunkClass) {
                [self p_registerChunkClass:chunkClass forType:chunkType];
                NSLog(@"Registered class '%@' for chunk type '%@'.", chunkClassName, chunkType);
                ++chunkClassOK;
            } else {
                NSLog(@"Failed to load class '%@' for chunk type '%@'.", chunkClassName, chunkType);
            }
        }
    }
    NSLog(@"Registered %lu chunk classes (of %lu attempted) for %lu chunk types.", chunkClassOK, chunkClassCount, chunkTypeCount);
}

+ (BOOL) canHandleChunkWithData:(NSData*)data
{
    return YES;
}

#pragma mark - Utility

+ (NSArray*) processChunksInData:(NSData*)data
{
    NSMutableArray* chunks = [NSMutableArray array];
    NSUInteger dataProcessed = 0;
    if ([data length] >= kWaveExplorerChunkHeaderSize) {
        const void* bytes = [data bytes];
        while (dataProcessed < ([data length] - kWaveExplorerChunkHeaderSize)) {
            NSUInteger dataRemaining = [data length] - dataProcessed;
            const void* base = bytes + dataProcessed;
            // Create a temporary NSData that extends to the rest of the data.
            NSData* chunkData = [[NSData alloc] initWithBytesNoCopy:(void*)base length:dataRemaining freeWhenDone:NO];
            NSUInteger chunkDataLength = [self p_chunkLengthFromData:chunkData];
            if (chunkDataLength > dataRemaining) {
                NSLog(@"Error processing data stream: Chunk size %lu, with only %lu bytes remaining in stream.", chunkDataLength, dataRemaining);
                // Just stop now.
                break;
            }
            [chunkData release];
            // Release the temporary data and create one with the real chunk length.
            chunkData = [[NSData alloc] initWithBytesNoCopy:(void*)base length:(chunkDataLength + kWaveExplorerChunkHeaderSize) freeWhenDone:NO];
            WaveExplorerChunk* chunk = [self chunkForData:chunkData];
            [chunkData release];
            [chunks addObject:chunk];
            dataProcessed += (((chunkDataLength + kWaveExplorerChunkHeaderSize) + 1) & ~1);
        }
    }
    return chunks;
}

+ (NSUInteger) autoProcessSubchunkOffset
{
    return 4;
}

+ (uint32_t) readUint32FromData:(NSData*)data atOffset:(NSUInteger)offset
{
    uint32_t result = 0;
    if ([data length] >= (offset + sizeof(uint32_t))) {
        uint32_t* pUint = (uint32_t*)([data bytes] + offset);
#if __DARWIN_BYTE_ORDER == __DARWIN_LITTLE_ENDIAN
        result = *pUint;
#else
        result = OSSwapInt32(*pUint);
#endif
    }
    return result;
}

+ (uint16_t) readUint16FromData:(NSData*)data atOffset:(NSUInteger)offset
{
    uint16_t result = 0;
    if ([data length] >= (offset + sizeof(uint16_t))) {
        uint16_t* pUint = (uint16_t*)([data bytes] + offset);
#if __DARWIN_BYTE_ORDER == __DARWIN_LITTLE_ENDIAN
        result = *pUint;
#else
        result = OSSwapInt16(*pUint);
#endif
    }
    return result;
}

#pragma mark - Debugging

- (NSString*) descriptionWithIndent:(NSUInteger)indent
{
    NSString* indentString = [@"" stringByPaddingToLength:indent withString:@" " startingAtIndex:0];
    NSMutableString* description = [NSMutableString stringWithFormat:@"%@<%@ %p>: %@ (%lu bytes, %lu subchunks)%@",
                                    indentString, NSStringFromClass([self class]), self,
                                    mChunkID, mChunkDataSize, [mSubchunks count],
                                    [self additionalDebugInfo]];
    if ([mSubchunks count] > 0) {
        [description appendFormat:@"\n%@Subchunks: {\n", indentString];
        for (WaveExplorerChunk* chunk in mSubchunks) {
            [description appendFormat:@"%@\n", [chunk descriptionWithIndent:indent+2]];
        }
        [description appendFormat:@"%@}", indentString];
    }
    return description;
}

- (NSString*) description
{
    return [self descriptionWithIndent:0];
}

- (NSString*) additionalDebugInfo
{
    return @"";
}

#pragma mark - Private Methods

+ (NSString*) p_chunkTypeFromData:(NSData*)data
{
    NSString* result = nil;
    if ([data length] >= kWaveExplorerChunkIDSize) {
        const void* bytes = [data bytes];
        result = [[[NSString alloc] initWithBytes:bytes length:kWaveExplorerChunkIDSize encoding:NSISOLatin1StringEncoding] autorelease];
    }
    return result;
}

+ (NSUInteger) p_chunkLengthFromData:(NSData*)data
{
    return (NSUInteger)[self readUint32FromData:data atOffset:kWaveExplorerChunkIDSize];
}

+ (void) p_registerChunkClass:(Class)chunkClass forType:(NSString*)chunkType
{
    dispatch_once(&s_registeredChunkOnce, ^{
        s_registeredChunkClasses = [[NSMutableDictionary alloc] init];
    });
    NSMutableArray* classesForType = [s_registeredChunkClasses objectForKey:chunkType];
    if (!classesForType) {
        classesForType = [[NSMutableArray alloc] init];
        [s_registeredChunkClasses setObject:classesForType forKey:chunkType];
    }
    if (![classesForType containsObject:chunkClass]) {
        [classesForType addObject:chunkClass];
    } else {
        NSLog(@"Duplicate class %@ specified for chunk type '%@'", NSStringFromClass(chunkClass), chunkType);
    }
}

@end
