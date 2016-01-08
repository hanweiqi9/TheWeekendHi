//
//  GoodModel.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.address = dict[@"address"];
        self.activityId = dict[@"id"];
        self.type = dict[@"type"];
        self.price = dict[@"price"];
        self.image = dict[@"image"];
        self.counts = dict[@"counts"];
        self.age = dict[@"age"];
    }
    return self;
}

@end
