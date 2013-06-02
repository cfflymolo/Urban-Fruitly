
// UKImage.h -- extra UIImage methods
// by allen brunson  march 29 2009

#ifndef UKIMAGE_H
#define UKIMAGE_H

#import <UIKit/UIKit.h>

@interface UIImage (UKImage)

- (UIImage *)scaleImageToSize:(CGSize)targetSize;
- (UIImage*)resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality; 
- (UIImage*)rotate:(UIImageOrientation)orient;
- (UIImage *)crop:(CGRect)rect;
@end

#endif  // UKIMAGE_H