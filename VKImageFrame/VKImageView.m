//
//  VKImage.m
//  VKImageFrame
//
//  Created by Vyacheslav Kim on 2/22/13.
//  Copyright (c) 2013 Vyacheslav Kim. All rights reserved.
//

#import "VKImageView.h"

@implementation VKImageView

#define RGB(R,G,B) [NSColor colorWithCalibratedRed:(R)/255. green:(G)/255. blue:(B)/255. alpha:1]
#define RGBA(R,G,B,A) [NSColor colorWithCalibratedRed:(R)/255. green:(G)/255. blue:(B)/255. alpha:(A)]

- (void)drawRect:(NSRect)dirtyRect {
    // margin for frame
    float margin = 4;
    float marginForShadow = 5;
    // radius of frame corners
    float frameRadius = 2;
    
    // rectangle of whole view
    NSRect fullRect;
    fullRect = [self bounds];
    
    float cornerSize = 0.2 * (fullRect.size.height + fullRect.size.width) / 2;
    
    // rectangle in corner for background effect
    NSRect cornerBgRect = NSMakeRect(0, 0, cornerSize + 3, cornerSize + 3);
    NSColor* primeCorner = [NSColor colorWithCalibratedRed: 0.897 green: 0.785 blue: 0.292 alpha: 1];
    [primeCorner set];
    NSRectFill(cornerBgRect);
    
    // rectangle for frame which is margined
    NSRect frameRect = fullRect;
    frameRect.size.height -= margin * 2 + marginForShadow;
    frameRect.size.width -= margin * 2 + marginForShadow;
    frameRect.origin.x += margin;
    frameRect.origin.y += margin;
    
    // width of frame should be 5% of ave(height, width) of picture
    float frameSize = 0.05 * (frameRect.size.height + frameRect.size.width) / 2;
    
    // draw frame with small radius corners
    NSBezierPath *framePath = [NSBezierPath bezierPathWithRoundedRect:frameRect xRadius:frameRadius yRadius:frameRadius];
    
    // we need shadow on both frame and picture
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor blackColor]];
    [shadow setShadowOffset:NSMakeSize(3.1, -3.1)];
    [shadow setShadowBlurRadius:5];
    
    [NSGraphicsContext saveGraphicsState];
    [shadow set];

    // draw frame
    [[NSColor whiteColor] setFill];
    [framePath fill];
    [NSGraphicsContext restoreGraphicsState];
    
    // rectangle of actual picture
    NSRect pictureRect = frameRect;
    pictureRect.size.height -= frameSize * 2;
    pictureRect.size.width -= frameSize * 2;
    pictureRect.origin.x += frameSize;
    pictureRect.origin.y += frameSize;
    
    // draw picture in frame with shadow and gray stroke
    NSBezierPath *picturePath = [NSBezierPath bezierPathWithRoundedRect:pictureRect xRadius:frameRadius yRadius:frameRadius];
    [RGB(240, 240, 240) set];
    [picturePath stroke];
    
    [NSGraphicsContext saveGraphicsState];
    [shadow setShadowOffset:NSZeroSize];
    [shadow set];
    [self.image drawInRect:pictureRect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1 respectFlipped:YES hints:nil];
    [NSGraphicsContext restoreGraphicsState];
    
    // draw corner
    [self drawCornerWithSideLength:cornerSize];
}

- (void)drawCornerWithSideLength:(CGFloat)sideLength {
    //// General Declarations
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    //// Color Declarations
    NSColor* fillColor = [NSColor colorWithCalibratedRed: 0.913 green: 0.849 blue: 0.518 alpha: 1];
    NSColor* strokeColor = [NSColor colorWithCalibratedRed: 0.907 green: 0.808 blue: 0.367 alpha: 1];
    NSColor* primeCorner = [NSColor colorWithCalibratedRed: 0.897 green: 0.785 blue: 0.292 alpha: 1];
    NSColor* shadowColor2 = [NSColor colorWithCalibratedRed: 0.941 green: 0.727 blue: 0 alpha: 0.5];
    
    //// Gradient Declarations
    NSGradient* cornerGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                  fillColor, 0.0,
                                  strokeColor, 0.59, nil];
    
    //// Shadow Declarations
    NSShadow* shadowCorner = [[NSShadow alloc] init];
    [shadowCorner setShadowColor: shadowColor2];
    [shadowCorner setShadowOffset: NSMakeSize(3.1, -3.1)];
    [shadowCorner setShadowBlurRadius: 5];
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: RGBA(0,0,0,0.5)];
    [shadow setShadowOffset: NSMakeSize(3.1, -3.1)];
    [shadow setShadowBlurRadius: 30];
    
    //// cornerPath Drawing
    NSBezierPath* cornerPathPath = [NSBezierPath bezierPath];
    [cornerPathPath moveToPoint: NSMakePoint(0, 0)];
    [cornerPathPath lineToPoint: NSMakePoint(0, sideLength)];
    [cornerPathPath lineToPoint: NSMakePoint(sideLength, 0)];
    [cornerPathPath lineToPoint: NSMakePoint(0, 0)];
    [cornerPathPath closePath];
    [NSGraphicsContext saveGraphicsState];
    [shadow set];
    CGContextBeginTransparencyLayer(context, NULL);
    [cornerPathPath addClip];
    [cornerGradient drawFromCenter: NSMakePoint(2.28, 5.78) radius: 10.83
                          toCenter: NSMakePoint(16, 16) radius: 75.14
                           options: NSGradientDrawsBeforeStartingLocation | NSGradientDrawsAfterEndingLocation];
    CGContextEndTransparencyLayer(context);
    
    ////// cornerPath Inner Shadow
    NSRect cornerPathBorderRect = NSInsetRect([cornerPathPath bounds], -shadowCorner.shadowBlurRadius, -shadowCorner.shadowBlurRadius);
    cornerPathBorderRect = NSOffsetRect(cornerPathBorderRect, -shadowCorner.shadowOffset.width, shadowCorner.shadowOffset.height);
    cornerPathBorderRect = NSInsetRect(NSUnionRect(cornerPathBorderRect, [cornerPathPath bounds]), -1, -1);
    
    NSBezierPath* cornerPathNegativePath = [NSBezierPath bezierPathWithRect: cornerPathBorderRect];
    [cornerPathNegativePath appendBezierPath: cornerPathPath];
    [cornerPathNegativePath setWindingRule: NSEvenOddWindingRule];
    
    [NSGraphicsContext saveGraphicsState];
    {
        NSShadow* shadowCornerWithOffset = [shadowCorner copy];
        CGFloat xOffset = shadowCornerWithOffset.shadowOffset.width + round(cornerPathBorderRect.size.width);
        CGFloat yOffset = shadowCornerWithOffset.shadowOffset.height;
        shadowCornerWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
        [shadowCornerWithOffset set];
        [[NSColor grayColor] setFill];
        [cornerPathPath addClip];
        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform translateXBy: -round(cornerPathBorderRect.size.width) yBy: 0];
        [[transform transformBezierPath: cornerPathNegativePath] fill];
    }
    [NSGraphicsContext restoreGraphicsState];
    
    [NSGraphicsContext restoreGraphicsState];
    
    [primeCorner setStroke];
    [cornerPathPath setLineWidth: 0.5];
    [cornerPathPath stroke];
}

- (BOOL)isFlipped {
    return YES;
}

@end
