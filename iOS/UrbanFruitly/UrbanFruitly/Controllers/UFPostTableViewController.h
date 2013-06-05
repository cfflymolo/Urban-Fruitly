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

@interface UFPostTableViewController : UFAccountRequiredTableViewController <UITextFieldDelegate,UIActionSheetDelegate,UFProductSelectionTableViewControllerDelegate>



- (IBAction)postData:(id)sender;
- (IBAction)selectPhotoButtonTapped:(id)sender;
- (IBAction)gpsLocationButtonTapped:(id)sender;

@end
