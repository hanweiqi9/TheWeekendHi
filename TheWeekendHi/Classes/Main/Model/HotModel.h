//
//  HotModel.h
//  TheWeekendHi
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotModel : NSObject

@property(nonatomic,copy) NSString *activityId;
@property(nonatomic,copy) NSString *img;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
