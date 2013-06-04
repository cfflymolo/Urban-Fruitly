//
//  UFSearchTableViewController.m
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import "UFSearchTableViewController.h"
#import "UFProductMapViewController.h"
#import <Parse/Parse.h>

@interface UFSearchTableViewController ()

@end

@implementation UFSearchTableViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.typeField.delegate = self;
    self.distField.delegate = self;

}

- (IBAction)signOut:(UIBarButtonItem *)sender
{
    NSLog(@"user was logged out");
    [PFUser logOut];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UFProductMapViewController* vc = segue.destinationViewController;
    [vc setType:self.typeField.text andDistance:self.distField.text];                                       
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    [(UITableView*)self.view scrollToRowAtIndexPath:[(UITableView*)self.view indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


@end
