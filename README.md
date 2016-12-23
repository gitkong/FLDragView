#一、前言
- **1、写了10多天的小程序代码，有兴趣的可以看我这篇[小程序官方文档-小程序版【持续更新】](http://www.jianshu.com/p/5a781c989299)，被坑得有点晕，突然想换换口味，写点iOS的，看群上有人提过这个拖拽view的功能，应该挺多人需要的，那就造一个分享吧。**

- **2、公司有自己的一个直播项目，看其他直播app都有小屏幕可拖拽播放的view（如下图），虽然还没有这个需求，早点准备好。**

![截图来自某牙直播](http://upload-images.jianshu.io/upload_images/1085031-702608b4a959f9d9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)


- **3、而且很久没分享了，像往常一样，封装轮子的过程都会详细介绍，分享更多的都是封装的思想。**

- **4、来看看效果图先吧：**
![演示效果图，还可以吧](http://upload-images.jianshu.io/upload_images/1085031-da24d75b67f1e537.gif?imageMogr2/auto-orient/strip)

#二、功能分析（针对所有控件）

- 1、**可拖拽**。最基本的功能，拖出父容器松手后可复位，可关闭。

- 2、**拖拽不遮盖**。同级层次的控件，如果拖拽过程中出现重叠，会显示在最上层。

- 3、**可吸附边界**。吸附这点参考苹果的AssistiveTouch，只能在屏幕的左边或者右边，可关闭。

- 4、**弹簧效果**。如果超出屏幕，会有弹簧效果，这点参考scrollView 的 bounces 效果，可关闭。

- 5、**支持xib、storyboard 参数设置**。很多控件都是在xib或storyboard 中创建，此时可通过，看下图：
 
![支持xib、storyboard 参数设置](http://upload-images.jianshu.io/upload_images/1085031-64f6d296519d228a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)

#三、API 分析设计

- 1、**是否允许拖拽，默认关闭，支持xib、storyboard 参数设置**

```
/**
 *  @author gitKong
 *
 *  是否允许拖拽，默认关闭（可以在XIB或SB中设置）
 */
@property (nonatomic,assign)IBInspectable BOOL fl_canDrag;
```

- 2、**是否需要边界弹簧效果，默认开启，支持xib、storyboard 参数设置**

```
/**
 *  @author gitKong
 *
 *  是否需要边界弹簧效果，默认开启（可以在XIB或SB中设置）
 */
@property (nonatomic,assign)IBInspectable BOOL fl_bounces;
```

- 3、**是否需要吸附边界效果，默认开启（可以在XIB或SB中设置**

```
/**
 *  @author gitKong
 *
 *  是否需要吸附边界效果，默认开启（可以在XIB或SB中设置）
 */
@property (nonatomic,assign)IBInspectable BOOL fl_isAdsorb;
```

#四、功能实现分析
- **1、分类或继承实现**。因为需要支持所有控件，我们都知道控件都是直接或者间接继承 `UIView` ，此时可以有两种办法实现，` 继承`  和 ` 分类` ，此时我是用分类实现的，至于为什么呢？
   -   （1）、如果我当前的view是已经继承了另一个自定义view，而且功能很独立，此时如果要给当前view添加拖拽功能的话，就必须融合两个功能的代码，这将变得很麻烦，而且会很乱。

  -   （2）、如果我需要给一个按钮添加拖拽功能，那么继承就没办法实现了，因为你给这个按钮修改了继承，就没了自带的功能了。

- **2、监听拖拽**。拖拽事件可以通过 `- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event` 方法去监听，也可以通过添加 pan 拖拽手势，至于为什么要用 手势呢？
  -  （1）、需要在分类中实现 touchesMoved 方法，此时如果外界也实现了这个方法，那么就很容易起冲突。
  -  （2）、虽然动态修改拖拽功能开关，但 会 多次调用 touchesMoved 方法，即使关闭了拖拽功能，相对手势实现就没那么灵活了。

- **3、Setter 方法里添加pan事件**。一开始想到的是通过 runtime 的 `Swizzle` 替换掉 系统的 `init` 方法，进而在自己的方法里面实现 拖拽手势添加，但后来考虑到，此时是给UIView 添加分类，而页面上的所有控件都是UIView 的 子类，此时 init 就会调用多次，会造成页面显示慢；于是直接在setter方法里面判断，当需要拖拽的时候，我才添加事件，不需要拖拽的时候移除手势，算是一个小优化。**此时还需要记录当前控件在父容器中的 `index` ，这个等下就知道要用来干嘛。**

- **4、遮盖处理**。我们都知道，控件通过 `addSubviews` 添加到父容器中，是有顺序的，后面添加的会在上层；此时如果我先添加 view1 在添加 view2，我拖拽 view1 到 view2 的时候，就会被 view2 挡住。做法如下：
  -  （1）、遍历父类view 的 subViews 数组，判断是否与当前view重合，用系统自带的 `CGRectIntersectsRect` 方法判断。
  -  （2）、在拖拽开始（`UIGestureRecognizerStateBegan`）的时候，用 `bringSubviewToFront` 将拖拽的view 移到最上层。
  -  （3）、在拖拽结束（`UIGestureRecognizerStateEnd`）的时候，判断此时状态是否还重合，如果不重合，通过 `insertSubview` 将控件重置回原来的顺序（通过上面第三点记录的 `index`）

- **5、支持xib、storyboard 参数设置**。这个只需要添加一个 关键字修饰就行 `IBInspectable` ,用法可以看我API 设计，这个主要`作用是使view内的变量可视化，并且可以修改后马上看到`

- **6、弹簧效果和吸附效果**。这个可以使用UIView 的 动画就可以实现，此时有一个**注意点**，判断吸附到左边还是右边，比较的应该是绝对位置，而不是相对位置，需要加上父类的x值

```
if (gesR.view.fl_centerX + self.superview.fl_x > self.superview.fl_centerX) {
    [UIView animateWithDuration:0.25 animations:^{
        gesR.view.center = CGPointMake(self.superview.fl_width - self.fl_width / 2, y);
    }];
    
}
else{
    [UIView animateWithDuration:0.25 animations:^{
        gesR.view.center = CGPointMake(self.fl_width / 2, y);
    }];
}
```

![计算小坑](http://upload-images.jianshu.io/upload_images/1085031-85821e9f5b229bb8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#五、注意点：
- 1、如果你是使用约束来布局的话，此时可能出现当你拖拽出一定范围后，能正常停留在当前位置；但当你此时拖拽后的位置在约束好的位置附近，就会被吸附回去，如下图：（**此时图片是使用约束布局**）

![使用约束布局可能会出现这种情况](http://upload-images.jianshu.io/upload_images/1085031-366a0e53b67e67a2.gif?imageMogr2/auto-orient/strip)

- 2、如果手势失败，会有断言提示。

#六、总结
- **1、为了方便大家使用，支持cocoapod，通过 `pod search FLDragView` 就能搜到。如果你搜不到，先清理一下吧，执行 `rm ~/Library/Caches/CocoaPods/search_index.json` 执行完重新 search 就行**
  
  ![cocoapod](http://upload-images.jianshu.io/upload_images/1085031-eb99cb25bcbaa15c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- **2、代码不难实现，具体代码就不拷贝上来了，代码中计算相对多一点，文字分析应该比较清楚了，如果还有什么其他问题，尽管找我。**

- **3、[简书地址](http://www.jianshu.com/users/fe5700cfb223/latest_articles) ，欢迎大家关注我，喜欢给个star 和 like ，你的支持是我最大的动力，会随时更新原创文章喔！**
