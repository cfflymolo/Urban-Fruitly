//
//  UFSearchTableViewController.h
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import <UIKit/UIKit.h>
#import "UFProductSelectionTableViewController.h"

@interface UFSearchTableViewController : UITableViewController <UITextFieldDelegate,UFProductSelectionTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UITextField *distField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
