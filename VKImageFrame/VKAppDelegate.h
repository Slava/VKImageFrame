//
//  VKAppDelegate.h
//  VKImageFrame
//
//  Created by Vyacheslav Kim on 2/22/13.
//  Copyright (c) 2013 Vyacheslav Kim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VKAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *imageView;

@end
