//
//  UFProductDetailViewController.h
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/2/13.
//
//

#import <UIKit/UIKit.h>

@interface UFProductDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *vendorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end
