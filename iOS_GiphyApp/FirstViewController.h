//
//  ViewController.h
//  NetworkPractice
//
//  Created by Alvin Kuang on 10/24/16.
//  Copyright © 2016 Alvin Kuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>


NSMutableData * _responseData;

@interface FirstViewController : UIViewController <UITabBarDelegate, SFSafariViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;


@end

