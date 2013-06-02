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
    _mapView.layerDelegate = self;
    [self.view addSubview:_mapView];
    
    AGSTiledMapServiceLayer *tiledLayer =
    [AGSTiledMapServiceLayer
     tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://server.arcgisonline.com/ArcGIS/rest/services/ESRI_StreetMap_World_2D/MapServer"]];
    [self.mapView addMapLayer:tiledLayer withName:@"Tiled Layer"];
}

//delegate methods

- (void)mapViewDidLoad:(AGSMapView *) mapView {
    //do something now that the map is loaded
    //for example, show the current location on the map
    [self.mapView.locationDisplay startDataSource];
    //zoom to an area
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:-124.83145667 ymin:30.49849464 xmax:-113.91375495  ymax:44.69150688  spatialReference:mapView.spatialReference];
    [self.mapView zoomToEnvelope:envelope animated:NO];
}

@end
