//
//  ProductSelectionTableViewController.h
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/4/13.
//
//

#import <UIKit/UIKit.h>
#import "UFProductSelectionTableViewControllerDelegate.h"

@interface UFProductSelectionTableViewController : UITableViewController

@property (weak,nonatomic,readwrite) id<UFProductSelectionTableViewControllerDelegate> delegate;

@end
