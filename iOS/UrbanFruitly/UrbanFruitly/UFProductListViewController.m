//
//  UFProductListViewController.m
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/1/13.
//
//

#import "UFProductListViewController.h"

@interface UFProductListViewController ()
@property (strong,nonatomic) AGSMapView* mapView;
@end

@implementation UFProductListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _mapView = [[AGSMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mapView];
    
    AGSTiledMapServiceLayer *tiledLayer =
    [AGSTiledMapServiceLayer
     tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://server.arcgisonline.com/ArcGIS/rest/services/ESRI_StreetMap_World_2D/MapServer"]];
    [self.mapView addMapLayer:tiledLayer withName:@"Tiled Layer"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
