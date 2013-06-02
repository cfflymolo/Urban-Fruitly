//
//  UFProductDetailViewController.m
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/2/13.
//
//

#import "UFProductDetailViewController.h"

@interface UFProductDetailViewController ()

@end

@implementation UFProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Apples";
    self.imageView.image = [UIImage imageNamed:@"apple_002.jpg"];
    self.typeLabel.text = @"Apples";
    self.vendorNameLabel.text = @"Amigo";
    self.priceLabel.text = @"$3.5";
    self.quantityLabel.text = @"9";
    self.descriptionTextView.text = @"Great fresh Apples!";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
