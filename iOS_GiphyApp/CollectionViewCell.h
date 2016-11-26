//
//  CollectionViewCell.h
//  SampleApp
//
//  Created by Alvin Kuang on 11/7/16.
//  Copyright © 2016 Alvin Kuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLAnimatedImageView;

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end
