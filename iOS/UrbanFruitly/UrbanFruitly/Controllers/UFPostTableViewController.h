//
//  UFPostTableViewController.h
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import <UIKit/UIKit.h>

@interface UFPostTableViewController : UITableViewController <UITextFieldDelegate,UIActionSheetDelegate>
- (IBAction)postData:(id)sender;
- (IBAction)selectPhotoButtonTapped:(id)sender;

@end
