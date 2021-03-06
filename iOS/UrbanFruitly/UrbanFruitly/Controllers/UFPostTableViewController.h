//
//  UFPostTableViewController.h
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import <UIKit/UIKit.h>
#import "UFAccountRequiredTableViewController.h"
#import "UFProductSelectionTableViewController.h"
#import "UFProduct.h"

@interface UFPostTableViewController : UFAccountRequiredTableViewController <UITextFieldDelegate,UIActionSheetDelegate,UFProductSelectionTableViewControllerDelegate,UITextViewDelegate>

@property (weak,nonatomic) UFProduct* productToUpdate;

- (IBAction)postData:(id)sender;
- (IBAction)selectPhotoButtonTapped:(id)sender;
- (IBAction)gpsLocationButtonTapped:(id)sender;

- (void)updateUIForProduct:(UFProduct*)product;
//-(void) setUpdateMode;

@end
