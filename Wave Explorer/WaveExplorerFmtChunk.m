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

- (NSString*) compressionDescription
{
    static NSDictionary* s_compressionCodeDescriptions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_compressionCodeDescriptions = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         NSLocalizedString(@"Unspecified", @"Unspecified audio codec"), [NSNumber numberWithInt:0],
                                         NSLocalizedString(@"Linear PCM", @"PCM audio codec"), [NSNumber numberWithInt:1],
                                         NSLocalizedString(@"Microsoft ADPCM", @"ADPCM audio codec"), [NSNumber numberWithInt:2],
                                         NSLocalizedString(@"a-law", @"a-law audio codec"), [NSNumber numberWithInt:6],
                                         NSLocalizedString(@"u-law", @"u-law audio codec"), [NSNumber numberWithInt:7],
                                         NSLocalizedString(@"IMA ADPCM", @"IMA audio codec"), [NSNumber numberWithInt:17],
                                         NSLocalizedString(@"Yamaha ADPCM", @"Yamaha ADPCM codec"), [NSNumber numberWithInt:20],
                                         NSLocalizedString(@"GSM 6.10", @"GSM 6.10 audio codec"), [NSNumber numberWithInt:49],
                                         NSLocalizedString(@"ITU G.721 ADPCM", @"ITU G.721 ADPCM audio codec"), [NSNumber numberWithInt:64],
                                         NSLocalizedString(@"MPEG", @"MPEG audio codec"), [NSNumber numberWithInt:80],
                                         NSLocalizedString(@"Experimental", @"Experimental audio codec"), [NSNumber numberWithInt:0xffff],
                                         nil];
    });
    NSString* description = [s_compressionCodeDescriptions objectForKey:[NSNumber numberWithInt:(int)self.compressionCode]];
    if (description == nil) {
        description = NSLocalizedString(@"Unknown", @"Unknown audio codec");
    }
    return description;
}

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

+ (NSString*) nibName
{
    return @"WaveExplorerFmtChunk";
}

- (NSString*) moreInfo
{
    NSString* formatString = NSLocalizedString(@"%1$u channels, %2$u bits, sample rate %3$u, data rate %4$u, codec %5$@",
                                               @"fmt chunk summary description format specifier");
    return [NSString localizedStringWithFormat:formatString,
            (unsigned int) mNumChannels, (unsigned int) mBitsPerSample,
            (unsigned int) mSampleRate, (unsigned int) mAverageBytesPerSecond,
            [self compressionDescription]];
}

@end
