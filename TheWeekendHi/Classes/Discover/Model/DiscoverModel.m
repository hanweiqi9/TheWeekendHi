//
//  DiscoverModel.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.activityId = dict[@"id"];
        self.image = dict[@"image"];
        self.type = dict[@"type"];
    }
    return self;
}


@end
