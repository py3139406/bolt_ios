// UIImage+RoundedCorner.h
// Created By Anshul Jain on 25-March-2019
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

@import UIKit;

// Extends the UIImage class to support making rounded corners
@interface UIImage (RoundedCorner)
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;
@end
