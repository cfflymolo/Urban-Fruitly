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

@property (weak, nonatomic) IBOutlet UIButton *searchButton;


@end

@implementation UFSearchTableViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    [self setAppearance];
}

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
    if([[segue identifier] isEqualToString:@"Search"]){
        UFProductMapViewController* vc = segue.destinationViewController;
        [vc setType:self.typeField.text andDistance:self.distField.text];
    }
    else if([segue.identifier isEqualToString:@"ChooseProduceType"]){
        UFProductSelectionTableViewController* vc = segue.destinationViewController;
        vc.delegate = self;
    }
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

#pragma mark - UFProductSelectionTableViewControllerDelegate methods

- (void)productTypeSelected:(NSString *)type{
    self.typeField.text = type;
}

#pragma mark - Appearance

- (void) setAppearance{
    UIImage* greenButtonImage = [[UIImage imageNamed:@"greenButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(18,18,18,18)];
    [self.searchButton setBackgroundImage:greenButtonImage forState:UIControlStateNormal];

    UIImageView* tableBgView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    tableBgView.image = [[UIImage imageNamed:@"squairy_light"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    self.tableView.backgroundView = tableBgView;

}


@end
