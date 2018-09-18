# ZYNavigationBar
定制navigationBar，解决push/pop造成不同效果navigationBar突变,闪烁问题


## GIF展示
![image](https://note.youdao.com/yws/api/personal/file/WEB15de47d32d83166870a7e98f47ab8733?method=download&shareKey=fc081d7f877b9bb44649e3afb82affa0)
![image](https://note.youdao.com/yws/api/personal/file/WEB47d6d3ed1c80b01985e70825bc038ace?method=download&shareKey=dd10f88528dde7f4d28594912ce9df45)
![image](https://note.youdao.com/yws/api/personal/file/WEBcf69ae46f80304157c3f7d69cfefdda0?method=download&shareKey=adef0433b241a3e4c0bd2836687b284a)
![image](https://note.youdao.com/yws/api/personal/file/WEB112faeaef4c35097821b40097fa6784d?method=download&shareKey=9b879bd7f76386dfd1323ef9ed4161ce)


## 安装

###  CocoaPods

1. 在 `Podfile` 中添加 `pod 'ZYNavigationBar'`
2. 执行 `pod install` 或 `pod update`
3. 导入 import ZYNavigationBar

### 手动安装

1. 下载 `ZYNavigationBar` 文件夹内的所有内容。
2. 将 `ZYNavigationBar` 内 `Source` 目录文件添加(拖放)到你的工程。

# 使用
#### 1. 代码使用 `ZYNavigationController` 创建

```swift
     let vc = UIViewController()
     let navigationController = ZYNavigationController(rootViewController: vc)
     vc.zy_barTintColor = UIColor.blue
```
#### 2. 在storyboard中使用

![image](https://note.youdao.com/yws/api/personal/file/WEB602855175ebf8835cceaab95fb7d1528?method=download&shareKey=204ac1615682e569454bf933d446a9ef)
    
![image](https://note.youdao.com/yws/api/personal/file/WEBb6ec0e8fc4937f142ece67842d3846ff?method=download&shareKey=32f71f41c21f9d182b5d9e68572a9b4d)


### 使用 `UIViewController` 的扩展属性对navigationBar进行配置

```swift
    public var zy_barStyle: UIBarStyle //navigationBar样式
    
    public var zy_barTintColor: UIColor // navigationBar背景颜色
    
    public var zy_barImage: UIImage // navigationBar背景图片
    
    public var zy_tintColor: UIColor  // navigationItem颜色
    
    public var zy_titleTextAttributes: [NSAttributedStringKey : Any] //navigationItem标题
    
    public var zy_barAlpha: CGFloat // navigationBar背景透明度
    
    public var zy_barIsHidden: Bool // 是否隐藏navigationBar
    
    public var zy_barShadowIsHidden: Bool  // 是否隐藏navigationBar的shadow
    
    public var zy_backInteractive: Bool // 当前页面是否可以通过navigationBar返回按钮和右滑pop
    
    public var zy_swipeBackEnabled: Bool // 当前页面是否支持右滑
```

## 注意事项

  1. 当设置 `zy_barImage` 时，`zy_barTintColor` 将失效
  2. 如果需要毛玻璃效果，可以设置 `zy_barTintColor` 时调整color的 `alpha` 值
  3. 目前只支持 `isTranslucent` 为 `true`
  4. `ZYNavigationBar` 必须配合 `ZYNavigationController` 一起使用，否则无效果

## Swift版本

	Swift 4.0


## Requirements

	iOS 9.0+

## 参考

[HBDNavigationBar](https://github.com/listenzz/HBDNavigationBar)



