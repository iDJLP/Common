//
//  RuleVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/9/10.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "RuleVC.h"
#import "RuleView.h"

@interface RuleVC ()

@property (nonatomic,strong)NSString *symbol;
@property (nonatomic,strong)RuleView *ruleView;

@end

@implementation RuleVC

+ (void)jumpTo:(NSString *)symbol{
    RuleVC *target = [[RuleVC alloc] init];
    target.symbol = symbol;
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_ruleView willAppear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"规则说明";
    self.view.backgroundColor = [GColorUtil C6];
    
    _ruleView = [[RuleView alloc] initWithSymbol:_symbol isChild:NO];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IPHONE_X_BOTTOM_HEIGHT)];
    footerView.backgroundColor = [GColorUtil C6];
    _ruleView.tableFooterView = footerView;
    [self.view addSubview:_ruleView];
    [_ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
