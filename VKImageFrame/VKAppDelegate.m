//
//  VKAppDelegate.m
//  VKImageFrame
//
//  Created by Vyacheslav Kim on 2/22/13.
//  Copyright (c) 2013 Vyacheslav Kim. All rights reserved.
//

#import "VKAppDelegate.h"
#import "VKImageView.h"

@implementation VKAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSString *path = [[NSBundle mainBundle] pathForResource:@"slava_at_life" ofType:@"png"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    [self.imageView setImage:image];
    
    
    NSImage *image2  =[[NSWorkspace sharedWorkspace] iconForFileType:@"asdafasdfasdfadfadfadsfasdfasdfasdfas"];
    [[image2 TIFFRepresentation] writeToFile:@"/Users/imslavko/generic.tiff" atomically:YES];
}

@end
