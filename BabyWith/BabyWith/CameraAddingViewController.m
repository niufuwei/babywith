//
//  CameraAddingViewController.m
//  AiJiaJia
//
//  Created by wangminhong on 13-5-16.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "CameraAddingViewController.h"
#import "SettingCell.h"
#import "Configuration.h"
#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import "UIViewController+Alert.h"
#import <QuartzCore/QuartzCore.h>
#import "DeviceConnectManager.h"
@implementation CameraAddingViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    UIView *view = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] applicationFrame].size.height)];
    view.backgroundColor = babywith_background_color;
    self.view = view;
    [view release];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];

    //导航条设置
    {
        [self leftButtonItemWithImageName:@"camera_back.png"];
//        //左导航-主选择页面
//        UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
//        navButton.tag = 1;
//        [navButton setImage:[UIImage imageNamed:@"goMain.png"] forState:UIControlStateNormal];
//        [navButton setImage:[UIImage imageNamed:@"goMain_highlight.png"] forState:UIControlStateHighlighted];
//        [navButton addTarget:self action:@selector(ShowMainList:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
//        self.navigationItem.leftBarButtonItem = leftItem;
//        
//        [navButton release];
//        [leftItem release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"看护器绑定";
        titleLabel.textColor = babywith_text_background_color;
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
        
        //右导航--设置按钮
        UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [setButton setBackgroundImage:[UIImage imageNamed:@"setSure.png"] forState:UIControlStateNormal];
        [setButton setBackgroundImage:[UIImage imageNamed:@"setSure_highlight.png"] forState:UIControlStateHighlighted];
        [setButton addTarget:self action:@selector(ButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: setButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        [rightItem release];
        [setButton release];
    }
    
    int blank7 = 0;
    if (IOS7) {
//        blank7 = 44;
    }
    
    //手动输入
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10+blank7, 300, 40)];
    textField.backgroundColor = babywith_text_background_color;
    textField.text = @"手动输入";
    textField.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1];
    textField.delegate = self;
    textField.layer.cornerRadius = 5.0;
    textField.tag = 20;
    textField.font = [UIFont systemFontOfSize:18];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField setKeyboardType:UIKeyboardTypeASCIICapable];
    textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [self.view addSubview:textField];

    
    //二维码扫描
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(11, 60+blank7, 298, 40)];
    [button2 setBackgroundColor:babywith_text_background_color];
    [button2 setTitle:@"二维码扫描" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:18];
    [button2 setTitleColor:[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 5.0;
    button2.layer.masksToBounds = YES;
    button2.tag = 1;
    [button2 addTarget:self action:@selector(ShowZBarView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    //局域网搜索
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(11, 110+blank7, 298, 40)];
    [button3 setBackgroundColor:babywith_text_background_color];
    button3.layer.cornerRadius = 5.0;
    button3.layer.masksToBounds = YES;
    button3.titleLabel.font = [UIFont systemFontOfSize:18];
    [button3 setTitle:@"局域网搜索" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1] forState:UIControlStateNormal];
    button3.tag = 0;
    [button3 addTarget:self action:@selector(SearchDevice) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
    _cameraSearchList = [[NSMutableArray alloc] initWithCapacity:1];
    
    //局域网搜索
    _pSearchDVS = new CSearchDVS();
    _pSearchDVS->searchResultDelegate = self;
    
    //局域网搜索的时候在下面显示设备信息的tableView
    _cameraListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, 320, self.view.frame.size.height - 240) style:UITableViewStyleGrouped];
    _cameraListTableView.delegate = self;
    _cameraListTableView.dataSource = self;
    _cameraListTableView.backgroundView = nil;
    _cameraListTableView.backgroundColor = [UIColor clearColor];
    _cameraListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:_cameraListTableView];
//    [self viewAddGest];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"手动输入"])
    {
        textField.text = @"";
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length] == 0)
    {
        textField.text = @"手动输入";
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //换行回收键盘
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}


//增加手势
-(void) viewAddGest{
    //单击事件
    UITapGestureRecognizer *taprecognizer;
    taprecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBlankView:)];
    taprecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:taprecognizer];
    [taprecognizer release];
}

-(void)touchBlankView:(UITapGestureRecognizer *)taprecognizer{
    
    if (taprecognizer.numberOfTapsRequired == 1) {
        for (UIView *view in [self.view subviews]) {
            if (view.tag == 20) {
                UITextField *textField = (UITextField *)view;
                [textField resignFirstResponder];
            }
        }
    }
    
}

//局域网搜索设备
-(void)SearchDevice{
    
    //分隔条
    int barFlag = 0;
    for (UIView *view in [self.view subviews]) {
        if (view.tag == 20) {
            UITextField *textField = (UITextField *)view;
            [textField resignFirstResponder];
        }
        if (view.tag == 99) {
            barFlag = 1;
            break;
        }
    }
    if (barFlag == 0) {
        UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 300, 40)];
        resultLabel.backgroundColor = [UIColor clearColor];
        resultLabel.font = [UIFont boldSystemFontOfSize:18];
        resultLabel.text = @"局域网摄像机";
        resultLabel.textAlignment = NSTextAlignmentCenter;
        resultLabel.textColor = babywith_text_color;
        [self.view addSubview:resultLabel];
        resultLabel.tag = 99;
        [resultLabel release];
    }
    
    _pSearchDVS->Close();
    
    [_cameraSearchList removeAllObjects];
    [_cameraListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    _pSearchDVS->Open();
}

//搜索设备的额代理方法
- (void) SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did{
    
    
    int  flag = 0;
    //去掉重复
    for (NSDictionary *dic in _cameraSearchList) {
        if ([[dic objectForKey:@"uid"] isEqualToString:did]) {
            flag = 1;
            break;
        }
    }
    
    if (flag == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name", did, @"uid", nil];
        [_cameraSearchList addObject:dic];
        [_cameraListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}
-(void)readQRcode
{
    NSArray * viewArray = self.view.subviews;
    for (UIView *view in viewArray)
    {
        view.hidden = YES;
    }
    
    _labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(30, 310, 260, 50)];
    _labIntroudction.backgroundColor = [UIColor clearColor];
    _labIntroudction.numberOfLines=1;
    _labIntroudction.textColor=[UIColor whiteColor];
    _labIntroudction.text=@"将设备底部二维码放入框内,可自动扫描";
    _labIntroudction.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    [self.view addSubview:_labIntroudction];
    
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 40, 260, 260)];
    _imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:_imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    
    
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    [session addInput:input];
    
    [session addOutput:output];
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    preview.frame =self.view.bounds;
    [self.view.layer insertSublayer:preview atIndex:0];
    
    self.previewLayer = preview;
    
    [session startRunning];
    
    
    
    self.session = session;
    
    
    
}
-(void)animation1
{
    if (upOrdown == NO)
    {
        num ++;
        _line.frame = CGRectMake(50, 50+2*num, 220, 2);
        if (2*num == 240)
        {
            upOrdown = YES;
        }
    }
    else
    {
        num --;
        _line.frame = CGRectMake(50, 50+2*num, 220, 2);
        if (num == 0)
        {
            upOrdown = NO;
        }
    }
    
}

#pragma mark - 扫描

-(void)ShowZBarView{

    
    if (IOS7)
    {
        //使用系统自带的二维码扫描
        [self readQRcode];
        
    }
    else
    {
      ZBarReaderViewController *reader = [ZBarReaderViewController new];
    
    //扫面范围
    CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(reader.view.frame)-126, 200, 200);
    reader.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:reader.view.bounds];
    UITextField *backgroundTF = [[UITextField alloc]initWithFrame:scanMaskRect];
    backgroundTF.borderStyle = UITextBorderStyleBezel;
    backgroundTF.userInteractionEnabled = NO;
    [reader.view addSubview:backgroundTF];
    [backgroundTF release];
    //扫描横线
    UIImageView *animaitionView = [[UIImageView alloc]initWithFrame:CGRectMake(60, CGRectGetMidY(reader.view.frame)-126, 200, 10)];
    animaitionView.image = [UIImage imageNamed:@"callButton"];
    [reader.view addSubview:animaitionView];
    [animaitionView release];
    
    
    

    reader.readerDelegate = self;
    //reader.showsZBarControls = YES;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    [reader setToolbarItems:nil];
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:^{
        
    } ];
    [reader release];
    
    [self performSelector:@selector(animation:) withObject:animaitionView afterDelay:0.5];
        
    }
    
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    
    [self.session stopRunning];
    
    [self.previewLayer removeFromSuperlayer];
    
    [_labIntroudction removeFromSuperview];
    [self.line removeFromSuperview];
    [_imageView removeFromSuperview];
    [timer invalidate];
    
    NSArray * viewArray = self.view.subviews;
    for (UIView *view in viewArray)
    {
        view.hidden = NO;
    }
    
    
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        [self ShowNextSetting:obj.stringValue];
        
    }
    
    
    
    
}
- (void)animation:(UIImageView *)view
{   //扫描框内动画
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        view.frame = CGRectMake(60, CGRectGetMidY(view.superview.frame)-126+200-10, 200, 10) ;
    } completion:^(BOOL finished) {
        
    }];
}
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}
-(void)ShowMainList:(UIButton *)button{
    UITextField *textField = (UITextField *)[self.view viewWithTag:20];
    [textField resignFirstResponder];
    textField.text = @"手动输入";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMainList" object:[NSString stringWithFormat:@"%d",button.tag]];
}

-(void)ButtonPressed
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:20];
    if ([textField.text length] == 0)
    {
        [self makeAlert:@"手动输入序列号不可为空"];
        return;
    }
    [self ShowNextSetting:textField.text];
}

-(void)ShowNextSetting:(NSString *)deviceID{
    
    
    if([deviceID isEqualToString:@"手动输入"])
    {
        [self makeAlert:@"未输入看护器序列号"];
        return;
    }
    if(![deviceID hasPrefix:@"VST"] || [deviceID length] != 15)
    {
        [self makeAlert:@"看护器序列号不正确"];
        return;
    }
    
    
    //添加设备
    NSString *token = [appDelegate.appDefault objectForKey:@"Token"];
    BOOL result = [appDelegate.webInfoManger UserAddDeviceUsingDeviceId:deviceID DeviceName:@"我的看护器" Token:token];
    
    if (result)
    {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"看护器绑定成功";
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            [indicator release];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToMain" object:nil];
            

        }];
        
    }else{
        //提示错误
        [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
    }
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =[info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    //条形码
    if (symbol.type == 0x80) {
        return;
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToShowTabarMenu" object:self];
    
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    /*************************** 二维码通信部分 **************************/
    NSLog(@"得到的二维码是 %@",symbol.data);
    if (symbol.data.length != 0) {
        
        [self ShowNextSetting:symbol.data];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select row = [%d]", indexPath.row);
    
    SettingCell *cell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [self ShowNextSetting:cell.textLabel.text];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  40;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [_cameraSearchList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Device_uid_search";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = babywith_button_text_color;
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    cell.textLabel.text = [[_cameraSearchList objectAtIndex:indexPath.section] objectForKey:@"uid"];
    return cell;
}

-(void)viewWillAppear:(BOOL)animated{
    
    _pSearchDVS->Close();
    for (UIView *view in [self.view subviews]) {
        if (view.tag == 20) {
            UITextField *textField = (UITextField *)view;
            [textField resignFirstResponder];
        }else if(view.tag == 99){
            [view removeFromSuperview];
        }
    }
    
    [_cameraSearchList removeAllObjects];
    [_cameraListTableView reloadData];
    
    
}

-(void)viewDidUnload{
    
    [_cameraSearchList release];
    _cameraSearchList = nil;
    
    [_cameraListTableView release];
    _cameraListTableView = nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   }

-(void)dealloc{
    [_cameraSearchList release];
    [_cameraListTableView release];
    if (_pSearchDVS != NULL) {
        SAFE_DELETE(_pSearchDVS);
    }
    
    [super dealloc];
}
- (void)pop:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
