### 由于很多接口被X微博封了，所以会从原来的Auth2.0网页认证换为基于WeiboSDK的SSO认证。这阵子下载下来的是无法运行的，需要下载的暂停下载了只能。
# Fenvo
###### Objective-C, iOS
类似简单的第三方微博客户端,可进行登录微博浏览相关信息。UI简陋，暂未完善。


![image](https://github.com/ChenNan-FRAM/Fenvo/blob/master/Fenvo/FenvoPreview.gif)

----------------------------------

### 已实现模块
- 登录、注册
- 微博个人关注微博主页内容（微博信息图片浏览，转发，回复，赞，收藏等）
- 微博个人信息内容模块

---------------------------------------
### 正在实现模块
- 写微博，发送微博
- 个人消息提醒（评论回复、赞、粉丝）

---------------------------------------

### 主要数据模型（Model）
基于Core Data存储（7.18更改）

- WeiboMsg.h   //主要微博信息
- WeiboGeoInfo.h  //地理信息
- WeiboRemind.h  //提示信息
- WeiboUserInfo.h  //用户个人信息
- WeiboVisibleInfo.h  //微博可见性
- WeiboPrivacySetting.h //微博隐私分组
- WeiboComment.h  //评论
- ---------暂未完成---------
- WeiboChatMsg.h  //私信

 ---------------------------------------
### 数据管理

#### 远程数据请求（RemoteRequest）
- TimeLineRPC.h //微博数据异步请求网络数据

#### 本地数据管理 (LocalManager)
- WeiboStoreManager.h //本地微博缓存数据管理
- WeiboCommentManager.h //本地微博评论缓存数据管理

 
---------------------------------------
### 主要控制器（ViewController）
- FollowingWBViewController.h //用户关注微博首页
- ProfileViewController.h //用户个人主页
	 - AlbumView.h //用户原创图片
	 - UserInfoView.h //用户个人简介
- WeiboTableView.h //用户个人已发送微博
- FollowingListTableViewController.h //用户粉丝列表
- FollowerListTableViewController.h //用户关注列表
- NewWeiboVC.h //用户写新微博
- WebViewController.h //微博附带网站跳转

---------------------------------------

### 各种界面组件
位于WeiboMsgComponent组下

---------------------------
#### 控制器结构：
- windows -> MainTabBarController -> UINavigationController -> 各个根控制器。

#### 微博Cell主要结构：
- HeaderView -> TextView -> DetailView -> ButtonView;

----------------
（未完待续）

