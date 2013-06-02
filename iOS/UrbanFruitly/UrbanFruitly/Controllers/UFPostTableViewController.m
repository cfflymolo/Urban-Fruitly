//
//  UFPostTableViewController.m
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import "UFPostTableViewController.h"

@interface UFPostTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@end

@implementation UFPostTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.typeTextField.enabled = NO;
    self.typeTextField.inputView = self.pickerView;
}

- (IBAction)changeTypeOfProduct
{
    NSLog(@"changeTypeofProduct");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"SelectingType");
    }
}

@end
