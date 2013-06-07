//
//  MyPostingsTableViewController.m
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/4/13.
//
//

#import "UFMyPostingsTableViewController.h"
#import "MBProgressHUD.h"
#import "UFProduct.h"
#import "UFPostTableViewController.h"

@interface UFMyPostingsTableViewController (){
    NSMutableArray* resultsArray;
    dispatch_queue_t results_loader_queue;
    MBProgressHUD *progressHud;    
}

@end

@implementation UFMyPostingsTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        resultsArray = [[NSMutableArray alloc] init];
        results_loader_queue = dispatch_queue_create("com.urbanfruitly.resultsLoader", NULL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self loadPostings];
}

- (void) viewDidAppear:(BOOL)animated{
}

- (void)loadPostings{
    progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [resultsArray removeAllObjects];
    [self.tableView reloadData];
    
    dispatch_async(results_loader_queue, ^{
        //get data from Parse
        PFQuery* query = [[PFQuery alloc] initWithClassName:@"Product"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        NSArray* results = [query findObjects];
        
        for(PFObject *obj in results){        
            UFProduct *product = [[UFProduct alloc] initWithPFObject:obj];
            assert(product);
            [resultsArray addObject:product];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Total Products Retuned : %d",resultsArray.count);
            
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return resultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostingListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UFProduct* product = resultsArray[indexPath.row];
    cell.textLabel.text = product.productType;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Price: $%d Quantity:%d",product.price.intValue,product.quantity.intValue];
    cell.imageView.image = product.image;
    
    if(!product.image){
        NSLog(@"Loading image..");
        [product loadProductImageWithCompletionBlock:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        UFProduct* product = resultsArray[indexPath.row];
        [resultsArray removeObjectAtIndex:indexPath.row];
        assert(product);
        
        //Remove product from Parse
        PFObject* pfobj = product.pfObject;
        [pfobj deleteInBackground];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - Segue Methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"UpdateProduct"]){
        UFPostTableViewController* vc = segue.destinationViewController;
        NSIndexPath* index = [self.tableView indexPathForSelectedRow];
        vc.productToUpdate = resultsArray[index.row];
        NSLog(@"Product Name: %@",vc.productToUpdate.productType);
    }
}


@end
