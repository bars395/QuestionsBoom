//
//  UIBezierPath+TextPaths.m
//
//  Created by Adrian Russell on 11/10/2012.
//  Copyright (c) 2014 Adrian Russell. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import "UIBezierPath+TextPaths.h"
#import "ARCGPathFromString.h"


// for the multiline the CTFrame must have a max path size. This value is arbitrary, currently 4x the height of ipad screen.
#define MAX_HEIGHT_OF_FRAME 4096
#define COMPLAIN_AND_BAIL(_COMPLAINT_, _ARG_) {NSLog(_COMPLAINT_, _ARG_); return;}




@implementation UIBezierPath (TextPaths)


#pragma mark - NSString


+ (UIBezierPath *)pathForString:(NSString *)string withFont:(UIFont *)font
{
    // if there is no string or font then just return nil.
    if (!string || !font) return nil;
    
    // create the dictionary of attributes for the attributed string contaning the font.
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    
    // create the attributed string.
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    // create path from attributed string.
    return [self pathForAttributedString:attrString];
}


+ (UIBezierPath *)pathForMultilineString:(NSString *)string
                                 withFont:(UIFont *)font
                                 maxWidth:(CGFloat)maxWidth
                            textAlignment:(NSTextAlignment)alignment

{
    // if there is no string or font or no width then just return nil.
    if (!string || !font || maxWidth <= 0.0) return nil;
    
    // create the paragraph style so the text alignment can be assigned to the attributed string.
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = alignment;
    
    // create the dictionary of attributes for the attributed string contaning the font and the paragraph style with the text alignment.
    NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle };
    
    // create the attributed string.
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    // create path for attributed string.
    return [self pathForMultilineAttributedString:attrString maxWidth:maxWidth];
}


#pragma mark - NSAttributedString


+ (UIBezierPath *)pathForAttributedString:(NSAttributedString *)string
{
    // if there is no specified string then there will be no path so just return nil.
    if (!string) return nil;
    
    // create the path from the specified string.
    CGPathRef letters = CGPathCreateSingleLineStringWithAttributedString(string);
    
    // make an iOS UIBezierPath object from the CGPath.
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    
    // release the created CGPath.
    CGPathRelease(letters);
    
    return path;
}


+ (UIBezierPath *)pathForMultilineAttributedString:(NSAttributedString *)string maxWidth:(CGFloat)maxWidth
{
    // if there is no specified string or the maxwidth is set to 0 then there will be no path so return nil.
    if (!string || maxWidth <= 0.0) return nil;
    
    // create the path from the specified string.
    CGPathRef letters = CGPathCreateMultilineStringWithAttributedString(string, maxWidth, MAX_HEIGHT_OF_FRAME);
    
    // make an iOS UIBezierPath object from the CGPath.
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    
    // release the created CGPath.
    CGPathRelease(letters);
    
    return path;
}

- (UIBezierPath *) inverseInRect: (CGRect) rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:self];
    [path appendPath:[UIBezierPath bezierPathWithRect:rect]];
    path.usesEvenOddFillRule = YES;
    return path;
}

- (void) strokeInside: (CGFloat) width color: (UIColor *) color {
    CGContextRef context = UIGraphicsGetCurrentContext(); if (context == NULL)
    {
        NSLog(@"Error: No context to draw to");
        return; }
    CGContextSaveGState(context);
    [self addClip];
    [self stroke: width * 2 color:color]; // Listing 4-1
    CGContextRestoreGState(context);
}


- (void) stroke: (CGFloat) width color: (UIColor *) color
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
        
        PushDraw(^{
            if (color) [color setStroke];
            CGFloat holdWidth = self.lineWidth;
            if (width > 0)
                self.lineWidth = width;
            [self stroke];
            self.lineWidth = holdWidth;
        });
    }

- (void) drawInnerShadow: (UIColor *) color size: (CGSize) size blur: (CGFloat) radius
{
    if (!color)
        COMPLAIN_AND_BAIL(@"Color cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
        COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    CGContextSaveGState(context);
    // Originally inspired by the PaintCode guys
    // http://paintcodeapp.com
    // Establish initial offsets
    CGFloat xOffset = size.width;
    CGFloat yOffset = size.height;
    // Adjust the border
    CGRect borderRect = CGRectInset(self.bounds, -radius, -radius);
    borderRect = CGRectOffset(borderRect, -xOffset, -yOffset);
    CGRect unionRect = CGRectUnion(borderRect, self.bounds);
    borderRect = CGRectInset(unionRect, -1.0, -1.0);
    // Tweak the size a tiny bit
    xOffset += round(borderRect.size.width);
    CGSize tweakSize = CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
    // Set the shadow and clip
    CGContextSetShadowWithColor(context, tweakSize, radius, color.CGColor);
    [self addClip];
    // Apply transform
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(borderRect.size.width), 0);
    UIBezierPath *negativePath = [self inverseInRect:borderRect];
    [negativePath applyTransform:transform];
    // Any color would do, use red for testing
    [negativePath fill:color];
    CGContextRestoreGState(context);
    
}

- (void) clipToPath
{
    [self addClip];
}

- (void) drawOuterGlow: (UIColor *) fillColor withRadius: (CGFloat) radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to draw to");
        return;
        
    }
    CGContextSaveGState(context);
    [self.inverse clipToPath];
    CGContextSetShadowWithColor(context, CGSizeZero, radius, fillColor.CGColor);
    [self fill:[UIColor grayColor]];
    CGContextRestoreGState(context);
}

- (UIBezierPath *) inverse {
    return [self inverseInRect:CGRectInfinite]; }

- (void) fill: (UIColor *) fillColor {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to draw to");
        return;
    }
    CGContextSaveGState(context);
    [fillColor set];
    [self fill];
    CGContextRestoreGState(context);
}


@end

void ApplyCenteredPathTransform(UIBezierPath *path, CGAffineTransform transform){
    CGPoint center = PathBoundingCenter(path);
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformTranslate(t, center.x, center.y);
    t = CGAffineTransformConcat(transform, t);
    t = CGAffineTransformTranslate(t, -center.x, -center.y);
    [path applyTransform:t];
}
CGPoint PathBoundingCenter(UIBezierPath *path){
    return RectGetCenter(PathBoundingBox(path));
}

CGPoint RectGetCenter(CGRect rect){
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}
CGRect PathBoundingBox(UIBezierPath *path){
    return CGPathGetPathBoundingBox(path.CGPath);
}
void MirrorPathVertically(UIBezierPath *path){
    CGAffineTransform t = CGAffineTransformMakeScale(1, -1);
    ApplyCenteredPathTransform(path, t);
}
void PushDraw(DrawingStateBlock block)
{
    if (!block) return; // nothing to do
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    CGContextSaveGState(context);
    block();
    CGContextRestoreGState(context);
}

UIImage* ImageCenteredInImage(UIImage *image1, UIImage *image2){
    UIGraphicsBeginImageContextWithOptions(image1.size, false, 1);
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, (image1.size.width - image2.size.width) / 2, (image1.size.height - image2.size.height) / 2);
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
}


