//
//  SortUtil.m
//  NWinBoom
//
//  Created by ngw15 on 2018/10/6.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "SortUtil.h"

@implementation SortUtil

+ (void)quickSort:(NSMutableArray *)list isAscending:(BOOL)isAs keyHander:(CGFloat(^)(NSDictionary *))keyHander{
    [self quickSort:list left:0 right:list.count-1 keyHander:keyHander isAscending:isAs];
}

+ (void)quickSort:(NSMutableArray *)list left:(NSInteger)left right:(NSInteger)right keyHander:(CGFloat(^)(NSDictionary *))keyHander isAscending:(BOOL)isAs{
    if (left>=right) {
        return;
    }
    NSInteger i=left;
    NSInteger j = right;
    NSDictionary *dict = list[i];
    CGFloat key = keyHander(dict);
    
    while (i<j) {
        while (i<j&&(isAs?keyHander(list[j])>=key:keyHander(list[j]) <=key)) {
            //找到小于key的 j；
            j--;
        }
        [list replaceObjectAtIndex:i withObject:list[j]];
        while (i<j&&(isAs?keyHander(list[i])<=key:keyHander(list[i]) >=key)) {
            //找到大于key的 i；
            i++;
        }
        [list replaceObjectAtIndex:j withObject:list[i]];
    }
    [list replaceObjectAtIndex:i withObject:dict];
    [self quickSort:list left:left right:i-1 keyHander:keyHander isAscending:isAs];
    [self quickSort:list left:i+1 right:right keyHander:keyHander isAscending:isAs];
}











void sortList(int *list,int left,int right){
    if (left>=right) {
        return;
    }
    int i=left;
    int j=right;
    int key = list[i];
    while (i<j) {
        
        while (i<j&&list[j]>=key) {
            j--;
        }
        list[i]=list[j];
        while (i<j&&list[i]<=key) {
            i++;
        }
        list[j]=list[i];
    }
    
    list[i]=key;
    sortList(list, left, i-1);
    sortList(list, i+1, right);
}

@end
