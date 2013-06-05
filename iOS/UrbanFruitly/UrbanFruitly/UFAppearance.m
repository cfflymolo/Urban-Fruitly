//
//  UFAppearance.m
//  UrbanFruitly
//
//  Created by Kalpesh Solanki on 6/5/13.
//
//

#import "UFAppearance.h"

@implementation UFAppearance

+ (void) setAppearance{
    
    //For Nav Bars
    UIImage *navBackgroundImage = [UIImage imageNamed:@"4-light-menu-bar"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];    

    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor lightGrayColor], UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                           UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"Georgia" size:18.0], UITextAttributeFont, nil]];
    
    //For UITabBar
//    UIImage* tabbarBgImage = [[UIImage imageNamed:@"4-light-menu-bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
//    [[UITabBar appearance] setBackgroundImage:tabbarBgImage];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor colorWithWhite:0.5 alpha:1], UITextAttributeTextColor,
//                                                       [UIColor blackColor], UITextAttributeTextShadowColor, nil]
//                                             forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor colorWithWhite:0.85 alpha:1], UITextAttributeTextColor,
//                                                       [UIColor blackColor], UITextAttributeTextShadowColor, nil]
//                                             forState:UIControlStateSelected];
    
//    UIImage *backButtonImage = [UIImage imageNamed:@"4-light-back-button"];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, backButtonImage.size.height*2) forBarMetrics:UIBarMetricsDefault];
}

@end
