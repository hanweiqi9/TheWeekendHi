//
//  MainModel.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.type = dict[@"type"];
        if ([self.type integerValue] == RecommendTypeActivity) {
            //推荐活动
            self.price = dict[@"price"];
            self.lat = [dict[@"lat"] floatValue];
            self.lng = [dict[@"lng"] floatValue];
            self.address = dict[@"address"];
            self.counts = dict[@"counts"];
            self.startTime = dict[@"startTime"];
            self.endTime = dict[@"endTime"];
            self.title = dict[@"title"];
            self.activityId = dict[@"id"];

        }else{
            //推荐专题
            self.activityDescription = dict[@"description"];
            
        }
        self.image_big = dict[@"image_big"];
        self.title = dict[@"title"];
        self.activityId = dict[@"id"];
        
    }
    return  self;
}

@end
