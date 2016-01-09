//
//  HotModel.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "HotModel.h"

@implementation HotModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        self.activityId = dict[@"id"];
        self.img = dict[@"img"];
        
    }
    return self;
}

@end
