//
//  UFProductListViewController.h
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/1/13.
//
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface UFProductMapViewController : UIViewController <AGSMapViewLayerDelegate,AGSInfoTemplateDelegate,AGSCalloutDelegate>

- (void) setType:(NSString*)type andDistance:(NSString*)distance;

@end
