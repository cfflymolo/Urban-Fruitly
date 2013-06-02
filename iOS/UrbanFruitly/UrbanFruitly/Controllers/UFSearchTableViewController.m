//
//  UFSearchTableViewController.m
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import "UFSearchTableViewController.h"
#import "UFProductListViewController.h"
#import <Parse/Parse.h>

@interface UFSearchTableViewController ()

@end

@implementation UFSearchTableViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)signOut:(UIBarButtonItem *)sender
{
    NSLog(@"user was logged out");
    [PFUser logOut];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UFProductListViewController* vc = segue.destinationViewController;
    [vc setType:self.typeField.text andDistance:self.distField.text];                                       
}

@end
