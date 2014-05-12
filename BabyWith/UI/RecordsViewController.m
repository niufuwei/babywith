//
//  RecordsViewController.m
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import "RecordsViewController.h"
#import "ImagePickerController.h"
#import "MainAppDelegate.h"
#import "SQLiteManager.h"
#import "CollectionCell.h"
#import "HeaderView.h"
#import "PhotoScanViewController.h"
#import "AppGlobal.h"

#define REUSEABLE_CELL_IDENTITY @"CELL"
#define REUSEABLE_HEADER @"HEADER"
@interface RecordsViewController ()

@end
int flag_monthList = 0;
int pre_month=12;
int ppre_month=13;
@implementation RecordsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [navButton setImage:[UIImage imageNamed:@"拍照.png"] forState:UIControlStateNormal];
    [navButton setImage:[UIImage imageNamed:@"拍照.png"] forState:UIControlStateHighlighted];
    [navButton addTarget:self action:@selector(takePic:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self titleSet:@"记录"];
    
    
    
    
    _label = [[UILabel alloc] init];
    _year = 0;
    localLoadFlag = 0;
    _recordLocalMonthListDic = [[ NSMutableDictionary alloc] initWithCapacity:1];
    _recordLocalMonthCountDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    _deleteDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    _yearArray = [[NSMutableArray alloc] initWithArray:appDelegate.recordLocalYearCountArray];
    _countForSectionArray = [[NSMutableArray alloc] init];
    _sectionArray = [[NSMutableArray alloc] init];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //
    UICollectionViewFlowLayout *fl =[[UICollectionViewFlowLayout alloc] init];
    _imageCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64 - 44) collectionViewLayout:fl];
    _imageCollection.backgroundColor = [UIColor clearColor];
    _imageCollection.delegate = self;
    _imageCollection.dataSource = self;
    [_imageCollection registerClass:[CollectionCell class] forCellWithReuseIdentifier:REUSEABLE_CELL_IDENTITY];
    
    [_imageCollection registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSEABLE_HEADER];
    
    [self.view addSubview:_imageCollection];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate.sqliteManager getLocalListOfYearCount];
    _yearArray = appDelegate.recordLocalYearCountArray;
    

    NSLog(@"viewwillAppear调用");
    [self performSelector:@selector(ShowRecordList) withObject:nil afterDelay:0.1];
    
}
-(void)viewDidDisappear:(BOOL)animated
{

    [_countForSectionArray removeAllObjects];
    [_sectionArray removeAllObjects];
    NSLog(@"viewwilldisappear调用");

}
-(void)ShowRecordList
{
    if ([_yearArray count] > 0)
    {
        
        _label.hidden = YES;
        //加载的是本地的记录信息
        //这里取得的是最后一个数据，也就是最新的数据，因为我们每一次调用viewAppear的时候都会给appDelegate.recordLocalYearCountArray一个新值，所以这里取得的应该是本年度的最新的记录数
        [self LoadLocalRecord:[[[_yearArray objectAtIndex:[_yearArray count]-1] objectForKey:@"Year"] integerValue]];
      //  NSLog(@"年份是%@",[[_yearArray objectAtIndex:[_yearArray count]-1] objectForKey:@"Year"]);
        
    }
    
    else
    {
        _label.frame = CGRectMake(20, 200, 280, 60);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text =@"您还没有记录信息";
        _label.hidden = NO;
        _label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_label];
    
    }


}
//取得本地的记录并更新数据
-(void)LoadLocalRecord:(int)year{
    
    
    _year = year;
    //第一次处理该年份 获取该年份内每个月的记录条数 获取该年份总记录列表 设置各个月份记录列表
    [appDelegate.sqliteManager getLocalListOfYearCount];

    [appDelegate.sqliteManager getLocalListOfMonthCountFromYear:_year];
    
    _recordLocalMonthCountDic = [appDelegate.recordLocalMonthCountDic objectForKey:[NSString stringWithFormat:@"%d", _year]];
    
    [appDelegate.sqliteManager getLocalRecordInfoListFromYear:_year];
    
    [self setMonthListOfYear:_year];
    
    
    for (int i = 12; i>0; i--)
    {
        [appDelegate.sqliteManager getLocalListofDayCountFromMonth:i Year:_year];
        
        [self setDaysListFromMonth:i Year:_year];
    }
    
    [_imageCollection reloadData];

    
}
#pragma mark MonthList  Set
/*设置每个月的记录的字典*/
//只是这里为什么是在数据库取得的数据，又存回到数据库  ？？？？？？？？？？？？？
-(void)setMonthListOfYear:(int)year
{
    if ([appDelegate.recordLocalMonthCountDic objectForKey:[NSString stringWithFormat:@"%d", year]] == nil) {
        return;
    }
    
    //取得本地的某一年的月记录
    //也就是一年所有的记录
    NSArray *localArray = [NSArray arrayWithArray:[appDelegate.recordLocalYearMonthListDic objectForKey:[NSString stringWithFormat:@"%d", year]]];
    NSLog(@"本地的年记录是%d",[localArray count]);
    if ([localArray count] ==0) {
        return;
    }
    
    
    int count = 0;
    for (NSInteger i= 12; i>0; i--)
    {
        
        //每个月的记录数量
        NSInteger num = [[_recordLocalMonthCountDic objectForKey:[NSString stringWithFormat:@"%d", i]] integerValue];
        if (num == 0 ) {
            continue;
        }
        
        
        //这个recordArray每次进来之后都是重新定义的
        //我们取数据是在localArray里面取得，数组里面的排列是先后顺序，先取最新的，比如从0开始的20个，那么下次的话就是从21开始的比如15个，下下次就是36开始的比如10个
        NSMutableArray *recordArray = [NSMutableArray arrayWithArray:[localArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(count, num)]]];
        
        
        //存入到本地属性
        [_recordLocalMonthListDic setObject:recordArray forKey:[NSString stringWithFormat:@"%d",i]];
        count += num;
    }
    //全部记录，取得每个月的之后存入到这个年份里面
    [appDelegate.recordLocalYearMonthListDic setObject:_recordLocalMonthListDic forKey:[NSString stringWithFormat:@"%d", year]];

    
}
-(int)getDaysFromMonth:(int)month Year:(int)year
{
    int i = 0;
    switch (month) {
        case 12:
            i= 31;
            break;
        case 11:
            i= 30;
            break;
        case 10:
            i= 31;
            break;
        case 9:
            i= 30;
            break;
        case 8:
            i= 31;
            break;
        case 7:
            i= 31;
            break;
        case 6:
            i= 30;
            break;
        case 5:
            i= 31;
            break;
        case 4:
            i= 30;
            break;
        case 3:
            i= 31;
            break;
        case 2:
        {
            if ((year % 400 == 0)||((year % 4 == 0)&&(year % 100 !=0))) {
                i= 29;
            }
            else
            {
            
                i= 28;
            
            }
 
        }
            break;
        case 1:
            i= 31;
            break;
        default:
            break;
    }

    return i;


}
-(void)setDaysListFromMonth:(int)month Year:(int)year
{

    //某一个月的记录数
    NSArray *localArray = [_recordLocalMonthListDic objectForKey:[NSString stringWithFormat:@"%d",month]];
    if ([localArray count] ==0)
    {
        return;
    }
    int days = [self getDaysFromMonth:month Year:_year];
    int count = 0;
    for (NSInteger i =days; i>0; i--) {
        NSInteger num = [[[appDelegate.recordLocalDayCountDic objectForKey:[NSString stringWithFormat:@"%d",month]] objectForKey:[NSString stringWithFormat:@"%d",i]]integerValue];
        if (num ==0) {
            continue;
        }
        NSMutableArray *recordArray = [NSMutableArray arrayWithArray:[localArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(count, num)]]];
        if (num !=0) {
            
            [_countForSectionArray addObject:[NSString stringWithFormat:@"%d",num]];
            [_sectionArray addObject:recordArray];
            
        }
        count += num;
    }

    NSLog(@"数组是%@,section总数是%@",_countForSectionArray,_sectionArray);
}

//进入拍照页面
-(void)takePic:(UIBarButtonItem *)item
{

    _picker = [[ImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        _picker.customDelegate = self;
        [self presentViewController:_picker animated:YES completion:^{
            
        }];
    }

}

//这里要将新增加的照片数据显示出来
//那么就要添加到数据库，从数据库取出来，显示到界面上
-(void)cameraPhoto:(NSArray *)imageArra
{

    for (NSDictionary *dic in imageArra)
    {
        NSData *imageData = [NSData dataWithContentsOfFile:[dic objectForKey:@"image"]];
        
        //记录的日期
        NSDate *saveDate = [dic objectForKey:@"date"];
        unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
        NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *nowComp = [myCal components:units fromDate:saveDate];
        
        
        //记录ID
        NSString *record_id = [NSString stringWithFormat:@"%@_%@",[dic objectForKey:@"time" ],[appDelegate.appDefault objectForKey:@"Member_id_self"]];
        
        
        //创建一个自动释放池

        
        //图片相对路径
        NSString *path = [NSString stringWithFormat:@"/image/record/%d/%d/%d/%d/%@.png",[nowComp year],[nowComp month],[nowComp day],[[appDelegate.appDefault objectForKey:@"Member_id_self"] integerValue]%10,record_id];
        
       
        //保存图片到沙盒目录
        NSString *imagePath = [NSString stringWithFormat:@"%@",[babywith_sandbox_address stringByAppendingPathComponent:path]];
        NSString *imageDir = [NSString stringWithFormat:@"%@",[imagePath stringByDeletingLastPathComponent]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error = nil;
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:&error];
        
        //视频流相对路径
        //这里加入了视频流的路径，让所有的图片保存保持一样的参数，但是在这里并没有存入视频，取的时候也不会用到这个视频的路径
        NSString *path1 = [NSString stringWithFormat:@"/vedio/record/%d/%d/%d/%d/%@.pm4",[nowComp year],[nowComp month],[nowComp day],[[appDelegate.appDefault objectForKey:@"Member_id_self"] integerValue]%10,record_id];
        NSString *vedioPath = [NSString stringWithFormat:@"%@",[babywith_sandbox_address stringByAppendingPathComponent:path1]];
        NSString *vedioDir = [NSString stringWithFormat:@"%@",[vedioPath stringByDeletingLastPathComponent]];
        NSError *vedioError = nil;
        [fileManager createDirectoryAtPath:vedioDir withIntermediateDirectories:YES attributes:nil error:&vedioError];
        
        
        if (!error)
        {
            if ([fileManager createFileAtPath:imagePath contents:imageData attributes:nil])
            {
                //插入表库
                NSArray *array = [NSArray arrayWithObjects:record_id,[appDelegate.appDefault objectForKey:@"Member_id_self"],[dic objectForKey:@"time"],[NSString stringWithFormat:@"%d",[nowComp year]],[NSString stringWithFormat:@"%d",[nowComp month]],[NSString stringWithFormat:@"%d",[nowComp day]],[dic objectForKey:@"width"],[dic objectForKey:@"height"],path,[NSString stringWithFormat:@"%d",0],path1,nil];
                
                NSArray *keyArray = [NSArray arrayWithObjects:@"id_record", @"id_member", @"time_record",@"year_record",@"month_record",@"day_record",@"width_image",@"height_image",@"path",@"is_vedio",@"record_data_path", nil];
                NSDictionary *insertDic = [NSDictionary dictionaryWithObjects:array forKeys:keyArray];
                
                //插入到数据库
                [appDelegate.sqliteManager insertRecordInfo:insertDic];
                [self.imageCollection reloadData];
            }
            
        }
        else
        {
            [self makeAlert:@"保存图片错误!"];
        }
                             
    }
    
    

}

#pragma mark -CollectionDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"有%d个元素",[ [_countForSectionArray objectAtIndex:section] integerValue]);
    return [[_countForSectionArray objectAtIndex:section] integerValue];
    
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [_imageCollection dequeueReusableCellWithReuseIdentifier:REUSEABLE_CELL_IDENTITY forIndexPath:indexPath];
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[[_sectionArray  objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    NSData *imageData = [NSData dataWithContentsOfFile: [babywith_sandbox_address stringByAppendingPathComponent:[dic objectForKey:@"path"]]];
    UIImage *image = [UIImage imageWithData:imageData];
    
    NSLog(@"图片是%@",image);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 75.5, 75.5);
    
    
    //假如是视频图片，要加一个按钮一样的图片加以区别
    if ([[dic objectForKey:@"is_vedio"] intValue] ==1)
    {
        _startImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start1.png"]];
        _startImage.frame = CGRectMake(21.75, 21.75,32, 32);
        [imageView addSubview:_startImage];
    }
   
    [cell addSubview:imageView];
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderView *headerView = [_imageCollection dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSEABLE_HEADER forIndexPath:indexPath];
    
     NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[[_sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    
    headerView.headerLabel.text = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"time_record"] doubleValue]/1000]];
    NSLog(@"头部视图是%@",headerView.headerLabel.text);
    
    return headerView;


}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75.5, 75.5);

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 0, 5, 0);
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    NSLog(@"section的个数是%d",[_sectionArray count]);
    return [_sectionArray count];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ([[_sectionArray objectAtIndex:section] count] == 0) {
        return CGSizeZero;
    }
    else
    {
    return CGSizeMake(320, 30);

    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *currentSectionPhoto = [_sectionArray objectAtIndex:indexPath.section];
    PhotoScanViewController *photoController = [[PhotoScanViewController alloc] initWithArray:currentSectionPhoto Type:0 Delegate:nil];
    [self.navigationController pushViewController:photoController animated:YES];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{

    return 6.0;


}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{

    return 6.0;


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
@end
