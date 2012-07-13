//
//  WaveExplorerStringChunk.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerStringChunk.h"


@interface WaveExplorerStringChunk ()
{
    NSString* mStringValue;
}
@end

#pragma mark -

@implementation WaveExplorerStringChunk

@synthesize stringValue = mStringValue;

- (id) initWithData:(NSData*)data
{
    if ((self = [super initWithData:data])) {
        const void* bytes = [data bytes];
        const void* base = bytes + 8; // gah.
        mStringValue = [[NSString alloc] initWithBytes:base length:(self.chunkDataSize-1) encoding:NSISOLatin1StringEncoding];
    }
    return self;
}

- (void) dealloc
{
    [mStringValue release];
    mStringValue = nil;
    [super dealloc];
}

+ (NSUInteger) autoProcessSubchunkOffset
{
    return NSUIntegerMax;
}

- (NSString*) additionalDebugInfo
{
    if ([mStringValue length] > 0) {
        return [NSString stringWithFormat:@" \"%@\"", mStringValue];
    } else {
        return [super additionalDebugInfo];
    }
}

- (NSString*) moreInfo
{
    return mStringValue ? mStringValue : @"";
}

@end
