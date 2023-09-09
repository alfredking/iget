//
//  YYTestViewController.m
//  YYKitDemo
//
//  Created by alfredking－cmcc on 2020/10/1.
//  Copyright © 2020 ibireme. All rights reserved.
//

#import "YYTestViewController.h"
#import "YYKit.h"

@interface YYTestViewController ()

@end

@implementation YYTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self test];
//    [self test01];
//    [self test02];
    
//    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
//    {
//        NSString *aKey = @"akey";
//        NSObject *aObject = [[NSObject alloc] init];
//        [aDictionary setObject:aObject forKey:aKey];
//        NSLog(@"dictionary: %@", aDictionary);
//    }
//    NSLog(@"dictionary: %@", aDictionary);
//
//    NSMapTable *aMapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
//    {
//        NSObject *keyObject = [[NSObject alloc] init];
//        NSObject *valueObject = [[NSObject alloc] init];
//        [aMapTable setObject:valueObject forKey:keyObject];
//        NSLog(@"NSMapTable:%@", aMapTable);
//    }
//    NSLog(@"NSMapTable:%@", aMapTable);
//    NSString *textStr = @"The YYLabel class implements a read-only text view,这是删除样式~~这是下划线样式~~这是带边框样式，这是带阴影样式，点击交互事件，添加点击事件，分割分割分割";
//        YYLabel * label = [[YYLabel alloc] initWithFrame:CGRectZero];
//        label.backgroundColor = [UIColor grayColor];
//        label.numberOfLines = 0;
//        label.textVerticalAlignment =  YYTextVerticalAlignmentTop;//垂直属性，上  下 或居中显示
//
//     //富文本属性
//        NSMutableAttributedString  * attriStr = [[NSMutableAttributedString alloc] initWithString:textStr];
//
//     //设置行间距
//        attriStr.lineSpacing = 10;
//        attriStr.font = [UIFont systemFontOfSize:20];
//
//        //富文本属性
//     NSRange range =[textStr rangeOfString:@"The YYLabel class implements a read-only text view"];
//        [attriStr setFont:[UIFont boldSystemFontOfSize:30] range:range];
//
//     //删除样式
//        NSRange range2 =[textStr rangeOfString:@"这是删除样式" options:NSCaseInsensitiveSearch];
//        YYTextDecoration *deletDecoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@(1) color:[UIColor redColor]];
//        [attriStr setTextStrikethrough:deletDecoration range:range2];
//
//
//
//
//    //下划线
//        NSRange range3 =[textStr rangeOfString:@"这是下划线样式" options:NSCaseInsensitiveSearch];
//        YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@(2) color:[UIColor yellowColor]];
//        [attriStr setTextUnderline:decoration range:range3];
//
//
//
//     //文本设置边框
//        NSRange range4 = [textStr rangeOfString:@"这是带边框样式" options:NSCaseInsensitiveSearch];
//        //边框
//        YYTextBorder *border = [YYTextBorder new];
//        border.strokeColor = [UIColor greenColor];
//        border.strokeWidth = 1;
//        border.lineStyle = YYTextLineStyleSingle;
//        border.cornerRadius = 1;
//        border.insets = UIEdgeInsetsMake(0, -2, 0, -2);
//        [attriStr setTextBorder:border range:range4];
//
//
//      //设置阴影
//        NSRange range5 = [textStr rangeOfString:@"这是带阴影样式" options:NSCaseInsensitiveSearch];
//        //阴影
//        NSShadow *shadow = [[NSShadow alloc] init];
//        [shadow setShadowColor:[UIColor redColor]];
//        [shadow setShadowBlurRadius:1.0];
//        [shadow setShadowOffset:CGSizeMake(2, 2)];
//        [attriStr setShadow:shadow range:range5];
//
//
//     //高亮显示文本 点击交互事件
//        NSRange range6 =[textStr rangeOfString:@"点击交互事件" options:NSCaseInsensitiveSearch];
//        YYTextBorder *border2 = [YYTextBorder new];
//        border2.cornerRadius = 50;
//        border2.insets = UIEdgeInsetsMake(0, -10, 0, -10);
//        border2.strokeWidth = 0.5;
//        border2.strokeColor = [UIColor yellowColor];
//        border2.lineStyle = YYTextLineStyleSingle;
//        [attriStr setTextBorder:border2 range:range6];
//        [attriStr setColor:[UIColor greenColor] range:range6];
//
//        YYTextBorder *highlightBorder = border2.copy;
//        highlightBorder.strokeWidth = 1;
//        highlightBorder.strokeColor =  [UIColor purpleColor];
//        highlightBorder.fillColor =  [UIColor purpleColor];
//        YYTextHighlight *highlight = [YYTextHighlight new];
//        [highlight setColor:[UIColor orangeColor]];
//        [highlight setBackgroundBorder:highlightBorder ];
//        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//            NSLog(@"点击事件");
////            [self back];
//
//        };
//       [attriStr setTextHighlight:highlight range:range6];
//
//
//
//
//      NSRange range7 =[textStr rangeOfString:@"添加点击事件" options:NSCaseInsensitiveSearch];
//        YYTextHighlight *highlight2 = [YYTextHighlight new];
//        [highlight2 setColor:[UIColor orangeColor]];//点击时字体颜色
//        highlight2.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//            NSLog(@"点击事件222");
////            [self back];
//
//        };
//        [attriStr setTextHighlight:highlight2 range:range7];
//
//
//
//     NSRange range8 =[textStr rangeOfString:@"分割分割分割"];
//        [attriStr setFont:[UIFont boldSystemFontOfSize:25] range:range8];
//        [attriStr setColor:[UIColor redColor] range:range8];
//
//
//     // 图文混排 支持各种格式包括gif
//       YYImage *image = [YYImage imageNamed:@"house1"];
//       image.preloadAllAnimatedImageFrames = YES;
//       YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
//       NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeTop attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:18] alignment:YYTextVerticalAlignmentCenter];
//       // [attriStr appendAttributedString:attachText];
//        [attriStr insertAttributedString:attachText atIndex:range8.location];
//
//
//        //Gif图片
//       NSString *  path = [[NSBundle mainBundle] pathForScaledResource:@"gif_loading" ofType:@"gif"];
//       NSData *data = [NSData dataWithContentsOfFile:path];
//        //修改表情大小
//        YYImage *image2 = [YYImage imageWithData:data scale:2];
//        image2.preloadAllAnimatedImageFrames = YES;
//        YYAnimatedImageView *imageView2 = [[YYAnimatedImageView alloc] initWithImage:image2];
//        NSMutableAttributedString *attachText2 = [NSMutableAttributedString attachmentStringWithContent:imageView2 contentMode:UIViewContentModeCenter attachmentSize:imageView2.size alignToFont:[UIFont systemFontOfSize:18] alignment:YYTextVerticalAlignmentCenter];
//        [attriStr appendAttributedString:attachText2];
//
//
//
//
//        label.attributedText = attriStr;
//      // 创建容器
//        YYTextContainer *container = [[YYTextContainer alloc] init];
//        //限制宽度
//        container.size = CGSizeMake(300, CGFLOAT_MAX);
//
//        //根据容器和文本创建布局对象
//        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attriStr];
//        //得到文本高度
//        CGFloat titleLabelHeight = layout.textBoundingSize.height;
//        //设置frame
//        label.frame = CGRectMake(20,84,300,titleLabelHeight);
//        //此处的YYTextLayout可以计算富文本的高度,他有一个属性textBoundingRect和textBoundingSize,container.size是用来限制宽度的,可以计算高度
//        //YYTextLayout是用来赋值给YYLabel,相当于UILabel的attributedText
//        //如果单纯的做点击处理可以用attributedText直接赋值给YYLabel,但是如果需要异步渲染就必须用YYTextLayout
//        [self.view addSubview:label];

    UILabel * lbl = [[UILabel alloc] init];

         lbl.backgroundColor = [UIColor redColor];

         lbl.textColor = [UIColor blackColor];

         lbl.numberOfLines = 0;

         lbl.text = @"连卡精神分裂就离开家啊";

         lbl.lineBreakMode = UILineBreakModeWordWrap;

      NSMutableDictionary * dic = [NSMutableDictionary dictionary];

         dic[NSFontAttributeName] = [UIFont systemFontOfSize:17];

      CGRect rect = [lbl.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];

      NSLog(@"%f-----%f", rect.size.width,  rect.size.height);

         lbl.frame = (CGRect){{0, 20}, rect.size};

         [self.view addSubview:lbl];

}



- (void)test
{

    if (true)
    {
        NSInteger age;
        UILabel *mylabel=[UILabel new];
        mylabel.text= age?[NSString stringWithFormat:@"%@",age]:@"";
        NSLog(@"mylabel.text is %@",mylabel.text);
        [self.view addSubview:mylabel];
        
    }

}

- (void)test01
{

    if (true)
    {
        NSInteger age;
        UILabel *mylabel=[UILabel new];
        mylabel.text= age?[NSString stringWithFormat:@"%@",age]:@"";
        age = 10;
        
        [self.view addSubview:mylabel];
    }

    int c = 10;
    
}

-(void) test02
{
    //下面分别定义各种类型的变量
     int a = 10;                       //普通变量
    __block int b = 20;                //带__block修饰符的block普通变量
    NSString *str = @"123";
    __block NSString *blockStr = str;  //带__block修饰符的block OC变量
    NSString *strongStr = @"456";      //默认是__strong修饰的OC变量
    NSMutableString *mutableStr = @"456";
    __block NSMutableArray *mArray = [NSMutableArray arrayWithObjects:@"a",@"b",@"abc",nil];
    NSMutableArray *testArray = [NSMutableArray arrayWithObjects:@"a",@"b",@"abc",@"test",nil];
    __weak NSString *weakStr = @"789"; //带__weak修饰的OC变量
    
    NSLog(@"mArray is %@",mArray);
  
  //定义一个block块并带一个参数
    void (^testBlock)(int) = ^(int c){
         int  d = a + b + c;
//        [mArray addObject:@"alfredking"];
        mArray = testArray;
         NSLog(@"a=%d,b=%d,c=%d,d=%d, strongStr=%@, blockStr=%@, weakStr=%@", a,b,c,d, strongStr, blockStr, weakStr);
     };
 
    a = 20;  //修改值不会影响testBlock内的计算结果
    b = 40;  //修改值会影响testBlock内的计算结果。
    testBlock(30);  //执行block代码。
    
    NSLog(@"a is %d",a);
    NSLog(@"b is %d",b);
    NSLog(@"mArray is %@",mArray);
}

@end
