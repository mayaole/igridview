//
//  ViewController.m
//  igridviewdemo
//
//  Created by vincent_guo on 13-12-12.
//  Copyright (c) 2013年 vincent_guo. All rights reserved.
//

#import "ViewController.h"
#import "UITableGridViewCell.h"
#import "UIImageButton.h"
#define kImageWidth  100 //UITableViewCell里面图片的宽度
#define kImageHeight  100 //UITableViewCell里面图片的高度
@interface ViewController ()

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImage *image;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"九宫格";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.image = [self cutCenterImage:[UIImage imageNamed:@"macbook_pro.jpg"]  size:CGSizeMake(100, 100)];
    
    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth = mSize.width;
    CGFloat screenHeight = mSize.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
}


#pragma mark UITable datasource and delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    //自定义UITableGridViewCell，里面加了个NSArray用于放置里面的3个图片按钮
    UITableGridViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectedBackgroundView = [[UIView alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<3; i++) {
            //自定义继续UIButton的UIImageButton 里面只是加了2个row和column属性
            UIImageButton *button = [UIImageButton buttonWithType:UIButtonTypeCustom];
            button.bounds = CGRectMake(0, 0, kImageWidth, kImageHeight);
            button.center = CGPointMake((1 + i) * 5 + kImageWidth *( 0.5 + i) , 5 + kImageHeight * 0.5);
            //button.column = i;
            [button setValue:[NSNumber numberWithInt:i] forKey:@"column"];
            [button addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:self.image forState:UIControlStateNormal];
            [cell addSubview:button];
            [array addObject:button];
        }
        [cell setValue:array forKey:@"buttons"];
    }
    
    //获取到里面的cell里面的3个图片按钮引用
    NSArray *imageButtons =cell.buttons;
    //设置UIImageButton里面的row属性
    [imageButtons setValue:[NSNumber numberWithInt:indexPath.row] forKey:@"row"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kImageHeight + 5;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不让tableviewcell有选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)imageItemClick:(UIImageButton *)button{
    NSString *msg = [NSString stringWithFormat:@"第%i行 第%i列",button.row + 1, button.column + 1];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"好的，知道了"
                                          otherButtonTitles:nil, nil];
    [alert show];
}





#pragma mark 根据size截取图片中间矩形区域的图片 这里的size是正方形
-(UIImage *)cutCenterImage:(UIImage *)image size:(CGSize)size{
    CGSize imageSize = image.size;
    CGRect rect;
    //根据图片的大小计算出图片中间矩形区域的位置与大小
    if (imageSize.width > imageSize.height) {
        float leftMargin = (imageSize.width - imageSize.height) * 0.5;
        rect = CGRectMake(leftMargin, 0, imageSize.height, imageSize.height);
    }else{
        float topMargin = (imageSize.height - imageSize.width) * 0.5;
        rect = CGRectMake(0, topMargin, imageSize.width, imageSize.width);
    }
    
    CGImageRef imageRef = image.CGImage;
    //截取中间区域矩形图片
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    
    UIGraphicsBeginImageContext(size);
    CGRect rectDraw = CGRectMake(0, 0, size.width, size.height);
    [tmp drawInRect:rectDraw];
    // 从当前context中创建一个改变大小后的图片
    tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return tmp;
}
@end
