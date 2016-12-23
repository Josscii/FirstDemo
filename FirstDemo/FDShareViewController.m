//
//  FDShareViewController.m
//  FirstDemo
//
//  Created by mxl on 16/12/23.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDShareViewController.h"
#import "FDShareCollectionViewCell.h"
#import "FDConstants.h"
#import "Masonry/Masonry.h"
#import <UMSocialCore/UMSocialCore.h>

@interface FDShareViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FDShareDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FDShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"取消分享" forState:UIControlStateNormal];
    button.tintColor = [UIColor colorWithRed:0.17 green:0.59 blue:0.81 alpha:0.5];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 20 * 2 - 15 * 3)/ 4, 80);
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 15, 20);
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 15;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[FDShareCollectionViewCell class] forCellWithReuseIdentifier:@"sharecell"];
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(230);
        make.bottom.equalTo(button.mas_top);
    }];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:separator];
    
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(button.mas_top);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark -
#pragma mark - collectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FDShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sharecell" forIndexPath:indexPath];
    cell.delegate = self;
    
    switch (indexPath.item) {
        case 0:
            cell.platformType = UMSocialPlatformType_WechatSession;
            cell.shareLabel.text = @"微信好友";
            cell.shareCircleView.backgroundColor = [UIColor colorWithRed:0.271 green:0.698 blue:0.231 alpha:1];
            cell.shareImageView.image = [UIImage imageNamed:@"share-weixing1-icon"];
            break;
        case 1:
            cell.platformType = UMSocialPlatformType_WechatTimeLine;
            cell.shareLabel.text = @"朋友圈";
            cell.shareCircleView.backgroundColor = [UIColor orangeColor];
            cell.shareImageView.image = [UIImage imageNamed:@"share-weixing2-icon"];
            break;
        case 2:
            cell.platformType = UMSocialPlatformType_QQ;
            cell.shareLabel.text = @"QQ";
            cell.shareCircleView.backgroundColor = [UIColor colorWithRed:0.345 green:0.808 blue:1 alpha:1];
            cell.shareImageView.image = [UIImage imageNamed:@"share-qq-icon"];
            break;
        case 3:
            cell.platformType = UMSocialPlatformType_Qzone;
            cell.shareLabel.text = @"QQ空间";
            cell.shareCircleView.backgroundColor = [UIColor colorWithRed:1 green:0.765 blue:0.271 alpha:1];
            cell.shareImageView.image = [UIImage imageNamed:@"share-qzone-icon"];
            break;
        case 4:
            cell.platformType = UMSocialPlatformType_Sina;
            cell.shareLabel.text = @"微博";
            cell.shareCircleView.backgroundColor = [UIColor colorWithRed:1 green:0.376 blue:0.345 alpha:1];
            cell.shareImageView.image = [UIImage imageNamed:@"share-sinaweibo-icon"];
            break;
        case 5:
            cell.platformType = UMSocialPlatformType_Email;
            cell.shareLabel.text = @"邮箱";
            cell.shareCircleView.backgroundColor = [UIColor colorWithRed:0.286 green:0.588 blue:1 alpha:1];
            cell.shareImageView.image = [UIImage imageNamed:@"share-mail-icon"];
            break;
        case 6:
            cell.platformType = UMSocialPlatformType_Sms;
            cell.shareLabel.text = @"短信";
            cell.shareCircleView.backgroundColor = [UIColor colorWithRed:0.016 green:0.769 blue:0 alpha:1];
            cell.shareImageView.image = [UIImage imageNamed:@"share-message-icon"];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 
#pragma mark - share

- (void)shareWithCell:(FDShareCollectionViewCell *)cell {
    
    NSLog(@"fdasfads");
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    if (cell.platformType == UMSocialPlatformType_Email || cell.platformType == UMSocialPlatformType_Sms) {
        messageObject.text = _desc;
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.shareImage = _image;
        messageObject.shareObject = shareObject;
    } else {
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"万年历" descr:_desc thumImage:_image];
        shareObject.webpageUrl = [NSString stringWithFormat:@"http://www.51wnl.com/products.html?f=15&cityid=%@&p=i", _city.cityCode];
        messageObject.shareObject = shareObject;
    }
    
    // 调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:cell.platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
