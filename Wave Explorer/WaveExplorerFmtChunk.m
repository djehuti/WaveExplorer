//
//  WaveExplorerFmtChunk.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerFmtChunk.h"

#define kWaveExplorerFmtChunkCompressionCodeOffset          8
#define kWaveExplorerFmtChunkNumChannelsOffset              10
#define kWaveExplorerFmtChunkSampleRateOffset               12
#define kWaveExplorerFmtChunkAverageBytesPerSecondOffset    16
#define kWaveExplorerFmtChunkBlockAlignOffset               20
#define kWaveExplorerFmtChunkBitsPerSampleOffset            22
#define kWaveExplorerFmtChunkExtraFormatBytesOffset         24

@interface WaveExplorerFmtChunk ()
{
    uint16_t mCompressionCode;
    uint16_t mNumChannels;
    uint32_t mSampleRate;
    uint32_t mAverageBytesPerSecond;
    uint16_t mBlockAlign;
    uint16_t mBitsPerSample;
    uint16_t mExtraFormatBytes;
}
@end


@implementation WaveExplorerFmtChunk

@synthesize compressionCode = mCompressionCode;
@synthesize numChannels = mNumChannels;
@synthesize sampleRate = mSampleRate;
@synthesize averageBytesPerSecond = mAverageBytesPerSecond;
@synthesize blockAlign = mBlockAlign;
@synthesize bitsPerSample = mBitsPerSample;
@synthesize extraFormatBytes = mExtraFormatBytes;

- (id) initWithData:(NSData*)data
{
    if ((self = [super initWithData:data])) {
        Class c = [self class];
        mCompressionCode       = [c readUint16FromData:data atOffset:kWaveExplorerFmtChunkCompressionCodeOffset];
        mNumChannels           = [c readUint16FromData:data atOffset:kWaveExplorerFmtChunkNumChannelsOffset];
        mSampleRate            = [c readUint32FromData:data atOffset:kWaveExplorerFmtChunkSampleRateOffset];
        mAverageBytesPerSecond = [c readUint32FromData:data atOffset:kWaveExplorerFmtChunkAverageBytesPerSecondOffset];
        mBlockAlign            = [c readUint16FromData:data atOffset:kWaveExplorerFmtChunkBlockAlignOffset];
        mBitsPerSample         = [c readUint16FromData:data atOffset:kWaveExplorerFmtChunkBitsPerSampleOffset];
        mExtraFormatBytes      = [c readUint16FromData:data atOffset:kWaveExplorerFmtChunkExtraFormatBytesOffset];
    }
    return self;
}

+ (NSUInteger) autoProcessSubchunkOffset
{
    return NSUIntegerMax;
}

- (NSString*) moreInfo
{
    return [NSString stringWithFormat:@"%u channels, %u bits, sample rate %lu, data rate %lu, compression code %u",
            (unsigned int) mNumChannels, (unsigned int) mBitsPerSample,
            (unsigned long) mSampleRate, (unsigned long) mAverageBytesPerSecond,
            (unsigned int) mCompressionCode];
}

@end
