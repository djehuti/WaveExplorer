//
//  DWTWaveStringChunk.h
//  WaveTools
//
//  Created by Ben Cox on 7/17/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <WaveTools/DWTWaveChunk.h>


@interface DWTWaveStringChunk : DWTWaveChunk

@property (nonatomic, readwrite, retain) NSString* stringValue;

@end
