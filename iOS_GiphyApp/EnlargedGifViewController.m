//
//  EnlargedGifViewController.m
//  SampleApp
//
//  Created by Alvin Kuang on 11/7/16.
//  Copyright © 2016 Alvin Kuang. All rights reserved.
//

#import "EnlargedGifViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "FLAnimatedImage.h"

@interface EnlargedGifViewController ()

@end

@implementation EnlargedGifViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
    [self setHidesBottomBarWhenPushed:YES];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, (self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y), self.view.frame.size.width, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y)/2)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [imageView setClipsToBounds:YES];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.gifStringURL] placeholderImage:[UIImage imageNamed:@"loading.gif"]];

    [self.view addSubview:imageView];

}

- (void)share:(id)sender {
    
    NSData * gifData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.gifStringURL]];
    NSArray *activityItems = @[gifData];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(float)scaleForNewHeight: (float)width : (float)height {
    float oldWidth = width;
    float scaleFactor = width / oldWidth;
    
    return height * scaleFactor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
