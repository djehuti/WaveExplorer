//
//  WaveExplorerDocumentWindowController.h
//  Wave Explorer
//
//  Created by Ben Cox on 7/14/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <Cocoa/Cocoa.h>


@class WaveExplorerDocument;


@interface WaveExplorerDocumentWindowController : NSWindowController <NSOutlineViewDataSource>

@property (nonatomic, readwrite, assign) WaveExplorerDocument* document;

@end
