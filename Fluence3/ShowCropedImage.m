//
//  TakeCameraPhoto2.m
//  Fluence3
//
//  Created by Naim on 3/28/13.
//
//

#import "ImageUtil.h"
#import "ColorMatrix.h"

#import "ShowCropedImage.h"
#import "CameraImageController.h"
@interface ShowCropedImage ()

@end

@implementation ShowCropedImage
@synthesize rootImageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)]autorelease];
    self.view.backgroundColor = [UIColor blackColor];
    
    rootImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 240, 320)];
    // Do any additional setup after loading the view from its nib.
  
    
    
    
    NSArray * arr = [NSArray arrayWithObjects: @ "Artwork", @"Lomo", @"BnW", @"Retro", @"Gothic", @"Sharp", @"Elegant", @"Burgundy",@"Lime", @"Romantic",@"Halo", @"Blues", @"Dream", @"Night", nil];
    
    seg = [[UISegmentedControl alloc]initWithItems:arr];
    
    seg.segmentedControlStyle = UISegmentedControlStyleBar;//样式
    //    seg.momentary = YES;//点击后恢复原样
    seg.frame = CGRectMake(0, 50, 640, 30);
    seg.tintColor = [UIColor blackColor];
    seg.userInteractionEnabled = NO;//Close用户交互
    
    //    seg.tintColor = [UIColor blackColor];
    //    UIBarButtonItem *segItem = [[UIBarButtonItem alloc]initWithCustomView:seg];
    //    NSArray *arr2 =[NSArray arrayWithObject:segItem];
    //    [toolBar setItems:arr2];
    //    [self.view addSubview:toolBar];
    //    [seg release];
    //    [toolBar release];
    
    scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 340, 320, 100)];
    scrollerView.backgroundColor = [UIColor clearColor];
    scrollerView.indicatorStyle = UIScrollViewIndicatorStyleBlack;//滚动条样式
    scrollerView.showsHorizontalScrollIndicator = YES;
    //显示横向滚动条
    scrollerView.showsVerticalScrollIndicator = NO;//Close纵向滚动条
    scrollerView.bounces = NO;//取消反弹效果
    scrollerView.pagingEnabled = YES;//划一屏
    scrollerView.contentSize = CGSizeMake(640, 30);
    
    for(int i=0;i<14;i++)
    {
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10.3+46*i, 10, 25, 30)];
        UIImage *bgImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        bgImageView.image = bgImage;
        [scrollerView addSubview:bgImageView];
        [bgImageView release];
        
    }
    
    [self.view addSubview:scrollerView];
    
    [scrollerView addSubview:seg];
    [seg addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventValueChanged];
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString: @"test.png"] ];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    currentImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(260, 340)];
    //    currentImage = image;
    
    
    
    [currentImage retain];
    
    rootImageView.image = currentImage;
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 50)];
    rootImage = [UIImage imageNamed:@"110.png"];
    imageView.image = rootImage;
    [scrollerView addSubview:imageView];
    [imageView release];
    
    seg.userInteractionEnabled = YES;
    [self.view addSubview:rootImageView];
    
    [scrollerView release];
    [seg release];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    
    
    self.navigationItem.rightBarButtonItem = right;
    [right release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //        NSString *string = [[NSBundle mainBundle] pathForResource:@"1110" ofType:@"JPEG"];
        //        currentImage = [UIImage imageWithContentsOfFile:string];
        //        rootImageView.image = currentImage;
        //        seg.userInteractionEnabled = YES;
        //        [self.view addSubview:rootImageView];
        
        imagePicker = [[UIImagePickerController alloc] init];//图像选取器
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
        //        imagePicker.allowsEditing = NO;//禁止对图片进行编辑
        
        [self presentModalViewController:imagePicker animated:YES];//打开模态视图控制器选择图像
        
    }
    if(buttonIndex == 1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//照片来源为相机
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            [self presentModalViewController:imagePicker animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Prompt" message:@"The device does not have camera" delegate:nil cancelButtonTitle:@"Determine" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
    }
    
    currentImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(260, 340)];
    //    currentImage = image;
    
    //调用imageWithImageSimple:scaledToSize:方法
    
    [currentImage retain];
    
    rootImageView.image = currentImage;
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 50)];
    rootImage = [UIImage imageNamed:@"110.png"];
    imageView.image = rootImage;
    [scrollerView addSubview:imageView];
    [imageView release];
    
    seg.userInteractionEnabled = YES;
    [self.view addSubview:rootImageView];
    [self dismissModalViewControllerAnimated:YES];//Close模态视图控制器
}

-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];//根据新的尺寸画出传过来的图片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    
    UIGraphicsEndImageContext();//Close当前环境
    
    return newImage;
}

-(void)save
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString: @"test.png"] ];
    NSData* data = UIImagePNGRepresentation(rootImageView.image);
    [data writeToFile:path atomically:YES];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Saved Successfully" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    //        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
    [alert release];}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        
        //        NSData *newData = UIImageJPEGRepresentation(currentImage, 1);
        //        NSString *docpath = @"/Users/ibokan/Desktop";
        //        NSString *path = [docpath stringByAppendingPathComponent:@"aaa.jpg"];
        //        [newData writeToFile:path atomically:YES];
        
        UIImage *img = rootImageView.image;// 要保存的图片
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);// 保存图片到相册中
        
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Prompt" message:@"Save failed, please re-save" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        //        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [alert show];
        [alert release];
        
    }
    else// 没有error
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Close" message:@"Prompt" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

//-(void)move
//{
//    CGPoint fromPoint = imageView.bounds.origin;
//
//    UIBezierPath *movePath = [UIBezierPath bezierPath];
//    [movePath moveToPoint:fromPoint];
//    CGPoint toPoint = CGPointMake(46, 30);
//    [movePath addQuadCurveToPoint:toPoint controlPoint:CGPointMake(toPoint.x, fromPoint.x)];
//
//    //关键帧
//    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    moveAnim.path = movePath.CGPath;
//    moveAnim.removedOnCompletion = YES;

//    //旋转变化
//    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
//    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    //x，y轴缩小到0.1,Z 轴不变
//    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
//    scaleAnim.removedOnCompletion = YES;
//
//    //关键帧，旋转组合起来执行
//    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
//    animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, nil];
//    animGroup.duration = 1;
//    [imageView.layer addAnimation:moveAnim forKey:nil];
//}


-(void)changeImage:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            rootImageView.image = currentImage;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(0, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 1:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_lomo];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.Frame = CGRectMake(46, 0, 45, 50);
            [UIView commitAnimations];
            
        }
            break;
        case 2:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_heibai];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*2, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 3:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_huajiu];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*3, 0, 45, 50);
            [UIView commitAnimations];
            
        }
            break;
        case 4:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_gete];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*4, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 5:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_ruise];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*5, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 6:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_danya];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*6, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 7:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_jiuhong];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*7, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 8:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_qingning];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*8, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 9:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_langman];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*9, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 10:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_guangyun];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*10, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 11:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_landiao];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*11, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 12:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_menghuan];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*12, 0, 45, 50);
            [UIView commitAnimations];
        }
            break;
        case 13:
        {
            rootImageView.image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_yese];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageView.frame = CGRectMake(46*13, 0, 45, 50);
            [UIView commitAnimations];
        }
        default:
            break;
    }
}

@end
