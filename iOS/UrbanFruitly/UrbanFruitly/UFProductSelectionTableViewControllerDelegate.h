//
//  UFProductSelectionTableViewControllerDelegate.h
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/4/13.
//
//

#import <Foundation/Foundation.h>

@protocol UFProductSelectionTableViewControllerDelegate <NSObject>

- (void) productTypeSelected:(NSString*)type;

@end
