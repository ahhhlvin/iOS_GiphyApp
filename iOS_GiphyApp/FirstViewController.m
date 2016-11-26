//
//  ViewController.m
//  NetworkPractice
//
//  Created by Alvin Kuang on 10/24/16.
//  Copyright © 2016 Alvin Kuang. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation FirstViewController

- (IBAction)actionButton:(UIButton *)sender {

    NSString *dataUrl = @"http://corgiorgy.com";
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
    svc.delegate = self;
    [self presentViewController:svc animated:YES completion:nil];
    
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

@end
