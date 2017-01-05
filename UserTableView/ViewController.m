//
//  Created by wujin on 16-12-25.
//

#import "ViewController.h"
#import "UIColor+hexColor.h"
#import "UIView+Frames.h"
#import "pinyin.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UITableView  *tbView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableDictionary *tbData;//词典保存，因为需要用到索引
@property (nonatomic, strong) NSMutableArray *tbIndex;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *tbDataArray;

@end

@implementation ViewController

-(void)makeNavBar{
    
    CGRect frame_title = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44+StateBarHeight);
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:frame_title];
    [titleView setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:titleView];
    
    // 设置标题视图
    UILabel *titlelable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20+StateBarHeight, 200, 40)];
    titlelable.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, 20+StateBarHeight);
    titlelable.backgroundColor = [UIColor clearColor];
    [titlelable setTextColor:[UIColor whiteColor]];
    [titlelable setTextAlignment:NSTextAlignmentCenter];
    titlelable.font = [UIFont systemFontOfSize:20];
    titlelable.text = @"索引表";
    [self.view addSubview:titlelable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeNavBar];
    _names = @[@"柯罗",@"德加",@"蒙德里安",@"莫奈",@"塞尚",@"阿波利奈尔",@"丢勒",@"米勒",@"列宾",@"佐恩",@"达芬奇",@"梵高",@"马蒂斯",@"毕加索",@"齐白石",@"高更",@"卢梭"];
    _tbDataArray = _names;
    [self buildIndex:_tbDataArray];
    
    [self initSearchBar];
    [self initTable];
    [self initKeyboard];
}

-(void) initTable {
    CGRect frame = CGRectMake(0, navBarHeight+70, [[UIScreen mainScreen] bounds].size.width,
                              [[UIScreen mainScreen] bounds].size.height-navBarHeight-70);
    _tbView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.backgroundColor = [UIColor clearColor];
    //设置分割线
    _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tbView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tbView];
}

-(void) initSearchBar{
    
    UIImage* clearImg = [self imageWithColor:[UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1] andHeight:32.0f];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 45)];
    self.searchBar.placeholder = @"请输入搜索相关信息";
    // 设定键盘类型, 字母大写，自动纠正, 栏类型
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.delegate = self;
    [self.searchBar setBackgroundImage:clearImg];
    
    [self.view addSubview:self.searchBar];
}

-(void)initKeyboard {
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    //弹性控件，可以把完成按钮固定在一侧。
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    //先放置弹性控件，再放置按钮，那么按钮就在右侧
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    [self.searchBar setInputAccessoryView:topView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchCustomer:searchText];
    [self buildIndex:_tbDataArray];
    [_tbView reloadData];
}

-(void) searchCustomer:(NSString *) search{
    
    NSMutableArray * array = [NSMutableArray array];
    
    if(search.length==0){
        _tbDataArray=_names;
        
    }else{
        for (int i=0;i<_names.count;i++){
            NSString *name = _names[i];
            if([name containsString:search]){
                [array addObject:name];
            }
        };
        _tbDataArray=array;
    }
    
}

- (UIImage*) imageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 建立索引
- (void)buildIndex:(NSArray *)names{
    _tbData = [[NSMutableDictionary alloc] init];
    _tbIndex = [[NSMutableArray alloc] init];
    for(NSString *name in names){
        if(name.length > 0){
            //获取首字母
            char TheLetter = pinyinFirstLetter([name characterAtIndex:0]);
            //重庆需特殊处理，这里显示的是z，zhong
            // if([name hasPrefix:@"重庆"]){
            // TheLetter = 'c';
            // }
            //查看是否建立索引了，如果索引没有建立，就建立
            NSString *index = [NSString stringWithFormat:@"%c", TheLetter];
            if(![_tbIndex containsObject:index]){
                [_tbIndex addObject:index];
            }
            
            //如果已经有，就添加到对应的地方
            if([_tbData objectForKey:index]){
                [[_tbData objectForKey:index] addObject:name];
            }else{
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:name];
                [_tbData setValue:array forKey:index];
            }
        }
    }
    
    [_tbIndex sortUsingComparator:^NSComparisonResult(id  obj1, id  obj2) {
        NSString *str1 = obj1;
        NSString *str2 = obj2;
        return [str1 compare:str2];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tbIndex.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *index = _tbIndex[section];
    NSArray *array = [_tbData objectForKey:index];
    
    return array.count;
}

//增加搜索索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _tbIndex;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _tbIndex[section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"homeCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSString *index = _tbIndex[indexPath.section];//找到索引字符串
    NSArray *array = [_tbData objectForKey:index];//找到索引字符串对应的数组
    NSString *title = array[indexPath.row];//取出对应的行
    
    //测试重用
    [cell.textLabel setText:title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"您点击了%ld行", (long)indexPath.row + 1);
}

-(void) dismissKeyBoard{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
