//
//  CameraPhotoRecordViewController.m
//  AiJiaJia
//
//  Created by wangminhong on 13-6-21.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "CameraPhotoRecordViewController.h"
#import "Configuration.h"
#import "MainAppDelegate.h"
#import "PPPPChannelManagement.h"
#import "SQLiteManager.h"
#import <QuartzCore/QuartzCore.h>
#import "AppGlobal.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>

@implementation CameraPhotoRecordViewController

- (id)initWithArray:(NSArray *)array Type:(int )type Delegate:(NSObject *)delegate
{
    self = [super init];
    if (self) {
        // Custom initialization
        _photoArray = [[NSMutableArray alloc] initWithArray:array];
        NSLog(@"photoArray 是 %@",_photoArray);
        _type = type;
        _delegate = delegate;
    }
    return self;
}



-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    //导航条设置
    {
        //右导航--删除按钮
        UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 74, 36)];
        
        [setButton addTarget:self action:@selector(deletePic) forControlEvents:UIControlEventTouchUpInside];
        [setButton setTitle:@"删除" forState:UIControlStateNormal];
        setButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        setButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        setButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: setButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        
       
        
        currentPage = 0;
        pageCount = [_photoArray count];
        _image = [[UIImage alloc]init];

        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [NSString stringWithFormat:@"%d/%d", currentPage+1, pageCount];
        titleLabel.textColor = babywith_text_background_color;
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
    }
    
    int contentHeight = self.view.frame.size.height;
    _photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, contentHeight)];
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.contentSize = CGSizeMake(320*pageCount,contentHeight);
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.scrollEnabled = YES;
    

    _playView = [[UIImageView alloc]init];
    
    
    
    int i=0;
    for (NSDictionary *dic in _photoArray)
    {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*320, 0, 320, contentHeight)];
        view.tag = i+1;
        
        
        NSData *imageData = [NSData dataWithContentsOfFile: [babywith_sandbox_address stringByAppendingPathComponent:[dic objectForKey:@"path"]]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        imageView.frame = CGRectMake(0, (contentHeight - 66 - 180)/2, view.frame.size.width, 180);
        imageView.userInteractionEnabled = YES;
        
        //如果是视频，那么显示图片的上面就要加一个播放按钮
        if ([[dic objectForKey:@"is_vedio"] intValue] == 1)
        {
            
            UIImageView *startImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start2.png"]];
            startImage.frame = CGRectMake(imageView.frame.size.width/2 - 40, imageView.frame.size.height/2 - 40, 64, 64);
            [imageView addSubview:startImage];
            
            UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPlay)];
            gester.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:gester];
            
        }
       
        [view addSubview:imageView];
        
        [_photoScrollView addSubview:view];
        
        i++;
    }
    
    [self.view addSubview:_photoScrollView];

}


#pragma mark -scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    currentPage = (_scrollView.contentOffset.x /_scrollView.frame.size.width);
    ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"%d/%d", currentPage+1, pageCount];
    NSLog(@"当前页是%d",currentPage);
    
}
-(void)startPlay
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //主线程更新UI
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.navigationController.navigationBarHidden = YES;
        _photoScrollView.hidden = YES;
        [self.view setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
        [self.view addSubview:_playView];
        
        NSLog(@"self.view.frame.height is %f",self.view.frame.size.height);
        [UIView animateWithDuration:0.0f animations:^{
            
            _playView.backgroundColor = [UIColor blackColor];
            if(kIsIphone5)
            {
                
                _playView.frame = CGRectMake(0, 0, 568, 320);
                
            }
            
            else
            {
                
                _playView.frame = CGRectMake(0, 0, 480, 320);
                
            }
            
            
            
        }];
        
        
        
        
    });
    
    //副线程处理数据，在主线程更新完UI之后，在提示加载的同时
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
            NSString *vedioPath = [[_photoArray objectAtIndex:currentPage] objectForKey:@"record_data_path"];
            NSString *vedioPath1 = [NSString stringWithFormat:@"%@",[babywith_sandbox_address stringByAppendingPathComponent:vedioPath]];
            //取得相应的视频数据
            NSLog(@"获取数据之前");
            _vedioData = [NSData dataWithContentsOfFile:vedioPath1];
            //数据的总长度
            
            NSLog(@"获取数据完毕");
        
            int totalLengt = [_vedioData length];
            //有多少个字节流数据，就是有多少张图片
            NSLog(@"totalLength is %d",totalLengt);
            _count = totalLengt/[[appDelegate.appDefault objectForKey:@"vedioDataLength"] intValue];
            NSLog(@"count is %d",_count);
            //取数据的范围
            int range = 0;
            
            for (int i =1; i <= _count; i++)
            {
                NSData *everyData = [_vedioData subdataWithRange:NSMakeRange(range,[[appDelegate.appDefault objectForKey:@"vedioDataLength"] intValue])];
                range +=[[appDelegate.appDefault objectForKey:@"vedioDataLength"] intValue];
                Byte *byte =(Byte *)[everyData bytes];
                
                //对取得的图片进行压缩，不然会内存吃紧
                @autoreleasepool
                {
                    _image = [APICommon YUV420ToImage:byte width:[[appDelegate.appDefault objectForKey:@"vedioDataWidth"] intValue] height:[[appDelegate.appDefault objectForKey:@"vedioDataHeight"] intValue]];
                    
                    NSLog(@"image width is %f,height is %f",_image.size.width,_image.size.height);
                    CGSize imageSize = _image.size;
                    imageSize.height = 320;
                    imageSize.width = self.view.frame.size.width - 64;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_playView setImage:_image];
                        
                        
                    });
                }
                
            }
                
            
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(stopPlaying) userInfo:nil repeats:NO];
        });
            
        
        
        
        });
        
 
}


//停止播放
-(void)stopPlaying
{
    //导航栏，状态栏等显示，视图旋转至原来的位置
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    _photoScrollView.hidden = NO;
    [UIView animateWithDuration:0.0f animations:^{
        
        [self.view setTransform: CGAffineTransformRotate(self.view.transform,(-M_PI/2))];
        
        
    }];
    //数据清零，确保再次点击的时候数据重新赋值
    _count = 0;
    _vedioData = nil;
    [_playView removeFromSuperview];
    
    
}


-(void)deletePic
{
    
    
    int index = currentPage;
    NSLog(@"currentPage是 %d",index);
    [[_photoScrollView viewWithTag:index+1] removeFromSuperview];
    
    for (int i= index+2; i<pageCount+1; i++)
    {
        UIView *view = [_photoScrollView viewWithTag:i];
        view.tag = i-1;
        view.frame = CGRectMake((i-2)*320, 0, 320, 480);
    }
    
    pageCount -= 1;
   
    NSLog(@"数组的元素是 %@",[_photoArray objectAtIndex:index]);
    
    //有视频，就删除
    NSString *vedioPath = [NSString stringWithFormat:@"%@",[babywith_sandbox_address
                                                            stringByAppendingPathComponent:[[_photoArray objectAtIndex:index] objectForKey:@"record_data_path"]]];
    NSError *error = nil;
    
    if ([[[_photoArray objectAtIndex:index] objectForKey:@"is_vedio"] intValue]==1)
    {
        [appDelegate.sqliteManager
         removeRecordInfo:[[_photoArray objectAtIndex:index] objectForKey:@"id_record"]
         deleteType:1];
        [[NSFileManager defaultManager] removeItemAtPath:vedioPath error:&error];
        [_photoArray removeObjectAtIndex:index];
    }
    else
    {
        
        [appDelegate.sqliteManager
         removeRecordInfo:[[_photoArray objectAtIndex:index] objectForKey:@"id_record"]
         deleteType:1];
    }
    
     if (pageCount == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(pageCount >0)
    {
        _photoScrollView.contentSize = CGSizeMake(320*(pageCount),self.view.frame.size.height-44-60-30);
        currentPage =  (_photoScrollView.contentOffset.x /_photoScrollView.frame.size.width);
        NSLog(@"当前的currentPage是%d",currentPage);
        
        ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"%d/%d", currentPage+1, pageCount];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
   
}

-(void)viewDidUnload{
    
    _photoScrollView = nil;
    
    _photoArray = nil;
    
   
}


@end
