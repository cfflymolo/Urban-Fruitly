//
//  ProductSelectionTableViewController.m
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/4/13.
//
//

#import "UFProductSelectionTableViewController.h"

@interface UFProductSelectionTableViewController ()

@end

@implementation UFProductSelectionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* path = [tableView indexPathForSelectedRow];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:path];
    [self.delegate productTypeSelected:cell.textLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
