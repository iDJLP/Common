//
//  DCCountryAlert.m
//  Bitmixs
//
//  Created by ngw15 on 2019/6/5.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "DCCountryAlert.h"
#import "BaseCell.h"

@interface DCCountryCell : BaseCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation DCCountryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bgColorType = C5_ColorType;
        self.hasPressEffect = YES;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)autoLayout{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)configOfCell:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@ (%@)",[NDataUtil stringWith:dict[@"name"]],[NDataUtil stringWith:dict[@"ccode"]]];
    if ([NDataUtil boolWithDic:dict key:@"isSelected" isEqual:@"1"]) {
        _titleLabel.textColor = [GColorUtil C13];
    }else{
        _titleLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
    }
}
//MARK:Getter

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
        _titleLabel.font = [GUIUtil fitFont:16];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [GColorUtil colorWithWhiteColorType:C7_ColorType];
    }
    return _lineView;
}

@end


@interface DCCountryView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *titlelabel;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSString *countryId;
@property (nonatomic,strong) NSArray *list;
@property (nonatomic,strong) NSArray *searchList;
@property (nonatomic,strong) void (^selectedHander) (NSDictionary *dic);

@end

@implementation DCCountryView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        [self setupUI];
        [self autoLayout];
        [self loadData];
    }
    return self;
}


- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titlelabel];
    [self.contentView addSubview:self.closeBtn];
    [self.contentView addSubview:self.tableView];
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo([GUIUtil fit:-10]);
        make.size.mas_equalTo([GUIUtil fitWidth:300 height:515]);
    }];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo([GUIUtil fit:15]);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-3]);
        make.centerY.equalTo(self.titlelabel);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo([GUIUtil fit:56]);
        make.right.bottom.mas_equalTo(0);
    }];
}

- (void)loadData{
    WEAK_SELF;
    ProgressStateView *stateView1 = (ProgressStateView *)[StateUtil show:self.tableView type:StateTypeProgress];
    stateView1.backgroundColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
    [DCService getCountryCode:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"result" isEqual:@"1"]) {
            [StateUtil hide:weakSelf.tableView];
            NSArray *tem = [NDataUtil arrayWith:data[@"data"]];
            NSMutableArray *list = [NSMutableArray array];
            NSMutableArray *childList = [NSMutableArray array];
            NSMutableArray *searchList = [NSMutableArray array];
            NSString *lastChar = @"";
            for (NSInteger idx=0; idx<tem.count; idx++) {
                NSDictionary *obj = tem[idx];
                NSMutableDictionary *dic = [obj mutableCopy];
                NSString *code = [NDataUtil stringWith:obj[@"ccode"]];
                NSString *name = [NDataUtil stringWith:obj[@"name"]];
                NSString *firstChar = [name substringToIndex:1];
                if (lastChar.length<=0) {
                    lastChar = firstChar;
                }
                if ([code isEqualToString:weakSelf.countryId]) {
                    [dic setObject:@"1" forKey:@"isSelected"];
                }
                if ([code isEqualToString:@"+86"]) {
                    [list insertObject:@[dic] atIndex:0];
                    [searchList insertObject:@"" atIndex:0];
                }else{
                    if ([lastChar isEqualToString:firstChar]) {
                        [childList addObject:dic];
                    }else{
                        [list addObject:childList];
                        [searchList addObject:lastChar];
                        lastChar = firstChar;
                        childList = [NSMutableArray array];
                        [childList addObject:dic];
                    }
                }
            }
            [list addObject:childList];
            [searchList addObject:lastChar];
            weakSelf.searchList = searchList;
            weakSelf.list = list;
            [weakSelf.tableView reloadData];
        }else{
            ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:weakSelf.tableView type:StateTypeNodata];
            stateView.backgroundColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
            stateView.onReload = ^{
                [weakSelf loadData];
            };
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:weakSelf.tableView type:StateTypeNodata];
        stateView.backgroundColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
        stateView.onReload = ^{
            [weakSelf loadData];
        };
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

//MARK: - Action

- (void)selectedData:(NSDictionary *)dic{
    [self removeFromSuperview];
    if (self.selectedHander) {
        self.selectedHander(dic);
    }
}

- (void)closeAction{
    [self removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _list.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = _list[section];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DCCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DCCountryCell"];
    NSArray *list = _list[indexPath.section];
    NSDictionary *dic = [NDataUtil dataWithArray:list index:indexPath.row];
    [cell configOfCell:dic];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _searchList;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list = _list[indexPath.section];
    NSDictionary *dic = [NDataUtil dataWithArray:list index:indexPath.row];
    [self selectedData:dic];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _searchList[section];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (index<_list.count) {    
        [tableView scrollToRow:0 inSection:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return -1;
}

//MARK: - Getter

-(UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil C5];
        _contentView.layer.cornerRadius = [GUIUtil fit:12];
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}
-(UILabel *)titlelabel{
    if(!_titlelabel){
        _titlelabel = [[UILabel alloc] init];
        _titlelabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
        _titlelabel.font = [GUIUtil fitFont:16];
        _titlelabel.text = @"Select Region";
        _titlelabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
    }
    return _titlelabel;
}
-(UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"nav_icon_close_light"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [GColorUtil C5];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DCCountryCell class] forCellReuseIdentifier:@"DCCountryCell"];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [GUIUtil fit:44];
      
    }
    return _tableView;
}

@end


@implementation DCCountryAlert


+ (void)showAlert:(NSString *)countryId selectedHander:(void (^)(NSDictionary *dic))selectedHander{
    UIWindow *window = [GJumpUtil window];
    DCCountryView *view = [[DCCountryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.countryId = countryId;
    view.selectedHander = selectedHander;
    view.tag = 47362;
    [window addSubview:view];
}

+ (void)hide{
    UIWindow *window = [GJumpUtil window];
    DCCountryView *view = [window viewWithTag:47362];
    [view removeFromSuperview];
}

@end
