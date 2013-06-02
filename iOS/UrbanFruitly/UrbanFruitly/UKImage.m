// UKImage.mm -- extra UIImage methods
// by allen brunson  march 29 2009
// based on original code by Kevin Lohman:
// http://blog.logichigh.com/2008/06/05/uiimage-fix/

#include "UKImage.h"

static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat  swap = rect.size.width;
    
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}

@implementation UIImage (UKImage)

- (UIImage *)scaleImageToSize:(CGSize)targetSize {
    //If scaleFactor is not touched, no scaling will occur      
    CGFloat scaleFactor = 1.0;
    
    //Deciding which factor to use to scale the image (factor = targetSize / imageSize)
    if (self.size.width > targetSize.width || self.size.height > targetSize.height)
        if (!((scaleFactor = (targetSize.width / self.size.width)) > (targetSize.height / self.size.height))) //scale to fit width, or
            scaleFactor = targetSize.height / self.size.height; // scale to fit heigth.
    
    UIGraphicsBeginImageContext(targetSize); 
    
    //Creating the rect where the scaled image is drawn in
    CGRect rect = CGRectMake((targetSize.width - self.size.width * scaleFactor) / 2,
                             (targetSize.height -  self.size.height * scaleFactor) / 2,
                             self.size.width * scaleFactor, self.size.height * scaleFactor);
    
    //Draw the image into the rect
    [self drawInRect:rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


//-(UIImage*)rotate:(UIImageOrientation)orient
//{
//    CGRect             bnds = CGRectZero;
//    UIImage*           copy = nil;
//    CGContextRef       ctxt = nil;
//    CGImageRef         imag = self.CGImage;
//    CGRect             rect = CGRectZero;
//    CGAffineTransform  tran = CGAffineTransformIdentity;
//    
//    rect.size.width  = CGImageGetWidth(imag);
//    rect.size.height = CGImageGetHeight(imag);
//    
//    bnds = rect;
//    
//    switch (orient)
//    {
//        case UIImageOrientationUp:
//            // would get you an exact copy of the original
//            assert(false);
//            return nil;
//            
//        case UIImageOrientationUpMirrored:
//            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
//            tran = CGAffineTransformScale(tran, -1.0, 1.0);
//            break;
//            
//        case UIImageOrientationDown:
//            tran = CGAffineTransformMakeTranslation(rect.size.width,
//                                                    rect.size.height);
//            tran = CGAffineTransformRotate(tran, M_PI);
//            break;
//            
//        case UIImageOrientationDownMirrored:
//            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
//            tran = CGAffineTransformScale(tran, 1.0, -1.0);
//            break;
//            
//        case UIImageOrientationLeft:
//            bnds = swapWidthAndHeight(bnds);
//            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
//            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//            bnds = swapWidthAndHeight(bnds);
//            tran = CGAffineTransformMakeTranslation(rect.size.height,
//                                                    rect.size.width);
//            tran = CGAffineTransformScale(tran, -1.0, 1.0);
//            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
//            break;
//            
//        case UIImageOrientationRight:
//            bnds = swapWidthAndHeight(bnds);
//            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
//            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
//            break;
//            
//        case UIImageOrientationRightMirrored:
//            bnds = swapWidthAndHeight(bnds);
//            tran = CGAffineTransformMakeScale(-1.0, 1.0);
//            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
//            break;
//            
//        default:
//            // orientation value supplied is invalid
//            assert(false);
//            return nil;
//    }
//    
//    UIGraphicsBeginImageContext(bnds.size);
//    ctxt = UIGraphicsGetCurrentContext();
//    
//    switch (orient)
//    {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            CGContextScaleCTM(ctxt, -1.0, 1.0);
//            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
//            break;
//            
//        default:
//            CGContextScaleCTM(ctxt, 1.0, -1.0);
//            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
//            break;
//    }
//    
//    CGContextConcatCTM(ctxt, tran);
//    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
//    
//    copy = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return copy;
//}

- (UIImage *)crop:(CGRect)rect {
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

@end