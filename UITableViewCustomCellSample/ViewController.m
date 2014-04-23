//
//  ViewController.m
//  UITableViewCustomCellSample
//
//  Created by yasuhisa.arakawa on 2014/04/12.
//  Copyright (c) 2014年 Yasuhisa Arakawa. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "TableViewConst.h"

/**
 *  テーブルビューのセクション数が入ります。
 */
static NSInteger const ViewControllerTableSecsion   = 2;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

/**
 *  Storyboardに配置したテーブルが紐づいてます。
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  Storyboardに配置したサーチバーが紐づいてます。
 */
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

/**
 *  テーブルに表示する情報が入ります。
 */
@property (nonatomic, strong) NSArray *dataSourceiPhone;
@property (nonatomic, strong) NSArray *dataSourceAndroid;

/**
 *  テーブルに表示する検索結果が入ります。
 */
@property (nonatomic, strong) NSArray *dataSourceSearchResultsiPhone;
@property (nonatomic, strong) NSArray *dataSourceSearchResultsAndroid;

@end

@implementation ViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // デリゲートメソッドをこのクラスで実装する
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchDisplayController.delegate = self;
    
    // テーブルに表示したいデータソースをセット
    self.dataSourceiPhone = @[@"iPhone 4", @"iPhone 4S", @"iPhone 5", @"iPhone 5c", @"iPhone 5s"];
    self.dataSourceAndroid = @[@"Nexus", @"Galaxy", @"Xperia"];
    
    // カスタマイズしたセルをテーブルビューにセット
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:TableViewCustomCellIdentifier bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource delegate methods

/**
 *  テーブルに表示するデータ件数を返します。（実装必須）
 *
 *  @param tableView テーブルビュー
 *  @param section   対象セクション番号
 *
 *  @return データ件数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger dataCount;
    
    // ここのsearchDisplayControllerはStoryboardで紐付けされたsearchBarに自動で紐づけられています
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        switch (section) {
            case 0:
                dataCount = self.dataSourceSearchResultsiPhone.count;
                break;
            case 1:
                dataCount = self.dataSourceSearchResultsAndroid.count;
                break;
            default:
                break;
        }
    } else {
        switch (section) {
            case 0:
                dataCount = self.dataSourceiPhone.count;
                break;
            case 1:
                dataCount = self.dataSourceAndroid.count;
                break;
            default:
                break;
        }
    }
    return dataCount;
}

/**
 *  テーブルに表示するセクション（区切り）の件数を返します。（任意実装）
 *
 *  @param  テーブルビュー
 *
 *  @return セクション件数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ViewControllerTableSecsion;
}

/**
 *  テーブルに表示するセルを返します。（実装必須）
 *
 *  @param tableView テーブルビュー
 *  @param indexPath セクション番号・行番号の組み合わせ
 *
 *  @return セル
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // ここのsearchDisplayControllerはStoryboardで紐付けされたsearchBarに自動で紐づけられています
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        // 検索中の暗転された状態のテーブルビューはこちらで処理
        switch (indexPath.section) {
            case 0: // iOSの検索結果を表示する
                cell.imageThumb.image = [UIImage imageNamed:@"ios1-100x100"];
                cell.labelDeviceName.text = self.dataSourceSearchResultsiPhone[indexPath.row];
                break;
            case 1: // Androidの検索結果を表示する
                cell.imageThumb.image = [UIImage imageNamed:@"android-200x200"];
                cell.labelDeviceName.text = self.dataSourceSearchResultsAndroid[indexPath.row];
                break;
            default:
                break;
        }
    } else {
        // 通常時のテーブルビューはこちらで処理
        switch (indexPath.section) {
            case 0: // iOS
                cell.imageThumb.image = [UIImage imageNamed:@"ios1-100x100"];
                cell.labelDeviceName.text = self.dataSourceiPhone[indexPath.row];
                break;
            case 1: // Android
                cell.imageThumb.image = [UIImage imageNamed:@"android-200x200"];
                cell.labelDeviceName.text = self.dataSourceAndroid[indexPath.row];
                break;
            default:
                break;
        }
    }
    
    cell.labelCellNumber.text = [NSString stringWithFormat:@"セル番号：%ld", (long)indexPath.row + 1];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CustomTableViewCell rowHeight];
}

#pragma mark - UISearchDisplayDelegate method

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // 検索バーに入力された文字列を引数に、絞り込みをかけます
    [self filterContainsWithSearchText:searchString];
    
    // YESを返すとテーブルビューがリロードされます。
    // リロードすることでdataSourceSearchResultsiPhoneとdataSourceSearchResultsAndroidからテーブルビューを表示します
    return YES;
}

#pragma mark - Private method

- (void)filterContainsWithSearchText:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    self.dataSourceSearchResultsiPhone = [self.dataSourceiPhone filteredArrayUsingPredicate:predicate];
    self.dataSourceSearchResultsAndroid = [self.dataSourceAndroid filteredArrayUsingPredicate:predicate];
}

@end
