//
//  GiphyObject.h
//  SampleApp
//
//  Created by Alvin Kuang on 11/7/16.
//  Copyright © 2016 Alvin Kuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiphyObject : NSObject

@property (nonatomic, strong) NSString *gifStringURL;

-(void)setGifURL:(NSString *)gifStringURL;

@end
