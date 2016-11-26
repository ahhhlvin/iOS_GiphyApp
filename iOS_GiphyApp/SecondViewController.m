//
//  SecondViewController.m
//  SampleApp
//
//  Created by Alvin Kuang on 11/3/16.
//  Copyright © 2016 Alvin Kuang. All rights reserved.
//

#import "SecondViewController.h"
#import "EnlargedGifViewController.h"
#import "CollectionViewCell.h"
#import "GiphyObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FLAnimatedImage.h"
#import <AFNetworking.h>

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet NSMutableArray<GiphyObject *> *resultsView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (strong, nonatomic) UIImageView *giphyImageView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.loadingView setHidden:YES];
    [self.loadingView setHidesWhenStopped:YES];
    
    self.resultsView = [[NSMutableArray<GiphyObject *> alloc] initWithCapacity:30];
    
    [self.collectionView setContentInset:UIEdgeInsetsZero];
    [self.collectionView setScrollIndicatorInsets:UIEdgeInsetsZero];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell_reuse_identifier"];
    [self.view addSubview:self.collectionView];
    
    self.giphyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://cdn.appstorm.net/web.appstorm.net/web/files/2013/09/giphy-logo1.png"]];
    UIImage *img = [[UIImage alloc] initWithData:imgData];
    self.giphyImageView.image = img;
    [self.collectionView addSubview:self.giphyImageView];
    
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"Search GIFs by Keywords"];
    [self.view addSubview:self.searchBar];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    if (self.resultsView.count > 0) {
    [self.resultsView removeAllObjects];
    }
    [self searchBarTask:searchBar];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.loadingView stopAnimating];
    [self.loadingView setHidden:YES];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarTask:(UISearchBar *)searchBar {
    
    if (searchBar.text == nil || [searchBar.text isEqualToString:@""]) {
        return;
    }
    
    if ([self.giphyImageView isHidden] == false) {
        [self.giphyImageView setHidden:YES];
    }
    
    [self.loadingView setHidden:NO];
    [self.loadingView startAnimating];
    
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\ " options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSString *formattedStringURL = [regex stringByReplacingMatchesInString:searchBar.text options:0 range:NSMakeRange(0, [searchBar.text length]) withTemplate:@"+"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", @"https://api.giphy.com/v1/gifs/search?q=", formattedStringURL, @"&api_key=dc6zaTOxFJmzC"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        GiphyObject *gifObj;
        
        for (int i = 0; i < dataArray.count; i++) {
            NSDictionary *images = [dataArray[i] objectForKey:@"images"];
            NSDictionary *downsized = [images objectForKey:@"downsized"];
            NSString *gifUrlString = [downsized objectForKey:@"url"];
            NSLog(@"%d, %@", i, gifUrlString);
            gifObj = [[GiphyObject alloc] init];
            if (gifUrlString.length > 0) {
                [gifObj setGifURL:gifUrlString];
                [self.resultsView addObject:gifObj];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.loadingView setHidden:YES];
        });
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resultsView.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_reuse_identifier" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (!cell.imageView) {
    cell.imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell addSubview:cell.imageView];
    }
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.resultsView[indexPath.row].gifStringURL] placeholderImage:[UIImage imageNamed:@"loading.gif"]];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    EnlargedGifViewController *enlargedGifViewController = [[EnlargedGifViewController alloc] init];
    enlargedGifViewController.gifStringURL = self.resultsView[indexPath.row].gifStringURL;
    [[self navigationController] pushViewController:enlargedGifViewController animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(375, 375);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
