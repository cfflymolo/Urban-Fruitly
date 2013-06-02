//
//  UFProductListViewController.m
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/1/13.
//
//

#import "UFProductListViewController.h"
#import "UFProductDetailViewController.h"

@interface UFProductListViewController (){
    AGSSimpleMarkerSymbol *myAppleSymbol;
    AGSSimpleMarkerSymbol *myOrangeSymbol;
}

@property (strong,nonatomic) AGSMapView* mapView;
@property (weak,nonatomic) AGSGraphicsLayer* myGraphicsLayer;

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
	_mapView.callout.delegate = self;
    [self.view addSubview:_mapView];
    
    AGSTiledMapServiceLayer *tiledLayer =
    [AGSTiledMapServiceLayer
     tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://server.arcgisonline.com/ArcGIS/rest/services/ESRI_StreetMap_World_2D/MapServer"]];
    [self.mapView addMapLayer:tiledLayer withName:@"Tiled Layer"];
    
    //other inits
    self.myGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.myGraphicsLayer withName:@"Graphics Layer"];
    
    myAppleSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbol];
    myAppleSymbol.color = [UIColor redColor];
    
}



- (void)mapViewDidLoad:(AGSMapView *) mapView {
    //do something now that the map is loaded
    //for example, show the current location on the map
    [self.mapView.locationDisplay startDataSource];
    //zoom to an area
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:-118.0 ymin:33.50 xmax:-118.3  ymax:34.50 spatialReference:mapView.spatialReference];
    [self.mapView zoomToEnvelope:envelope animated:NO];
    
    [self plotProductsOnTheMap];
    
}

- (void) plotProductsOnTheMap{
    AGSPoint* myMarkerPoint = [AGSPoint pointWithX:-118.2044
                       y:34.0339
		spatialReference:self.mapView.spatialReference];

    AGSGraphic* myGraphic =
	[AGSGraphic graphicWithGeometry:myMarkerPoint
                             symbol:myAppleSymbol
                         attributes:nil
               infoTemplateDelegate:nil];
    
    //Add the graphic to the Graphics layer
    [self.myGraphicsLayer addGraphic:myGraphic];
    myGraphic.infoTemplateDelegate = self;
    
    //Tell the layer to redraw itself
  //  [self.myGraphicsLayer dataChanged];
}


//delegate methods

- (NSString *)titleForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)map {
    return @"Apples";
}

- (NSString *)detailForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)map {
    return @"from Boyle Heights";
}

- (UIImage *)imageForGraphic:(AGSGraphic *) graphic screenPoint:(CGPoint) screen mapPoint:(AGSPoint *) mapPoint {
    return [UIImage imageNamed:@"apple_002.jpg"];
}

#pragma mark - AGSCalloutDelegate

//when a user clicks the detail disclosure button on the call out
- (void) didClickAccessoryButtonForCallout:(AGSCallout *) 	callout	{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"UrbanFruitly_iPhone" bundle:nil];
    
    UFProductDetailViewController* pdvc = [storyBoard instantiateViewControllerWithIdentifier:@"ProductDetails"];
    assert(pdvc);
    
    
    //Set data for the pdvc here//

    
    [self.navigationController pushViewController:pdvc animated:YES];
}

@end
