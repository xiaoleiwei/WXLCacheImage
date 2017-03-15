//
//  WXLRootTableViewController.m
//  WXLImageView
//
//  Created by weixiaolei on 16/6/2.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import "WXLRootTableViewController.h"
#import "WXLCustomImageView.h"
#import "WXLConstants.h"
#import "YUMINativeRequest.h"
#import "WXLPubfun.h"

@interface WXLRootTableViewController ()<YuMINativHttpRequestDelegate> {
    YUMINativeRequest *request;
   
}

@end

@implementation WXLRootTableViewController

- (NSMutableArray *)imgArray {
    if (!_imgArray) {
        _imgArray = [[NSMutableArray alloc] init];
    }
    return _imgArray;
}

- (NSMutableArray *)heightArray {
    if (!_heightArray) {
        _heightArray = [[NSMutableArray alloc] init];
    }
    return _heightArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //请求图片地址
    request = [YUMINativeRequest initWithURL:DataURL httpMethod:@"GET" params:nil httpHeaderFields:nil shortTimeOutType:15 postDataType:AdsYuMIHttpRequestPostDataTypeJSONDES3 delegate:self];
    [request asynchronousConnect];
}

#pragma mark - YUMINativeHttpRequest Delegate
- (void)request:(YUMINativeRequest *)request didFinishLoadingWithResult:(id)result {
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
    
    NSArray * items = dic[@"items"];
    for (NSDictionary * dict in items) {
        NSString * img = dict[@"wpic_middle"];
        
        [self.imgArray addObject:img];
    }
    
    NSLog(@"图片地址\n%@",self.imgArray);
    
    //获取图片的宽和高
    for (NSString * url in self.imgArray)
    {
        
        CGSize size = [[WXLPubfun defaultPubfun] getImageSizeWithURL:[NSURL URLWithString:url]];
        
        CGFloat width = ImgDefaultWidth;
        CGFloat height = (width/size.width)*size.height;
        NSString * hstr = [NSString stringWithFormat:@"%f",height];
        if (![hstr isEqualToString:@"nan"]) {
            [self.heightArray addObject:hstr];
        }
    
    }
    
    NSLog(@"共%ld张图\n%@",(unsigned long)self.heightArray.count,self.heightArray);
    
    
    [self.tableView reloadData];
}



#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.heightArray.count > 0)
    {
        return [self.heightArray[indexPath.row] floatValue];
    }
    else
    {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.heightArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    WXLCustomImageView * imgView = [[WXLCustomImageView alloc] initWithFrame:CGRectMake(0, 0, ImgDefaultWidth, [self.heightArray[indexPath.row] floatValue]) URL:self.imgArray[indexPath.row] defaultImg:@"timg.jpg"];
    [cell.contentView addSubview:imgView];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
