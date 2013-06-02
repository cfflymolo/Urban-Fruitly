//
//  UFPostTableViewController.m
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import "UFPostTableViewController.h"

#define TYPE_PICKERVIEW_HEIGHT 180

@interface UFPostTableViewController () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGRect originalPickerFrame;
}
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

@property (strong, nonatomic) NSArray *productTypes;
@property (strong, nonatomic) UIPickerView *typePickerView;
@end

@implementation UFPostTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    originalPickerFrame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width ,TYPE_PICKERVIEW_HEIGHT);
    
    self.typePickerView = [[UIPickerView alloc] initWithFrame:originalPickerFrame];
    self.typePickerView.dataSource = self;
    self.typePickerView.delegate = self;
    [self.view addSubview:self.typePickerView];
    
    self.productTypes = @[@"Apple", @"Oranges", @"Avacado"];
    self.typeTextField.enabled = NO;
}

- (IBAction)changeTypeOfProduct
{
    NSLog(@"changeTypeofProduct");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.typePickerView.frame;
            self.typePickerView.frame = CGRectMake(frame.origin.x, frame.origin.y-280, UIScreen.mainScreen.bounds.size.width, TYPE_PICKERVIEW_HEIGHT);
        }];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.productTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.productTypes [row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [UIView animateWithDuration:0.5f animations:^{
        self.typePickerView.frame = originalPickerFrame;
    }];
    
    self.typeTextField.text = self.productTypes [row];
}

@end
