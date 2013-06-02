//
//  UFProductListViewController.h
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/1/13.
//
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface UFProductListViewController : UIViewController <AGSMapViewLayerDelegate,AGSInfoTemplateDelegate,AGSCalloutDelegate>

- (void) setType:(NSString*)type andDistance:(NSString*)distance;

@end
