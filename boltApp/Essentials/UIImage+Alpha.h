// UIImage+Alpha.h
// Created By Anshul Jain on 25-March-2019
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

@import UIKit;

// Helper methods for adding an alpha layer to an image
@interface UIImage (Alpha)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;
@end
