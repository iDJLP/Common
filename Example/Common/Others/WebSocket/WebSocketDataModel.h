//
//  WebSocketDataModel.h
//  BitInfi
//
//  Created by 黄春晓 on 2018/2/9.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    WebSocketDataToolTypeNone = 0,   //无用信息
    WebSocketDataTypeContractedList,
    WebSocketDataTypeSingleContractId,

} WebSocketDataToolType;

@protocol WebSocketDataModelDelegate <NSObject>
//推送出解析后的结果
-(void)pushResultData:(NSArray *)dataArry;
@end

@interface WebSocketDataModel : NSObject

@property (nonatomic,weak)id<WebSocketDataModelDelegate> delegate;
//解析Socket返回的数据
-(void)webSocketAnalysisDataType:(WebSocketDataToolType)dataType withData:(id)data;

//删除当前类型的数据--
-(void)deleteCurrentData;
@end
