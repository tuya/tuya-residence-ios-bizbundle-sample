# 涂鸦 智慧居住 App SDK 和 BizBundle iOS 版示例

[中文版](README-zh.md) | [English](README.md)

---

本示例演示了如何使用 智慧居住 App SDK iOS 版 构建适用于智慧租住场景的应用程序，以及如何集成 UI 业务包。智慧居住 App SDK iOS 版 提供多个功能组，包括用户注册流程、站点管理、App 通行管理和密码通行管理。


## 运行环境

- Xcode 13.0 及以上版本
- iOS 12.0 及以上版本

## 运行示例

1. 智慧居住 App SDK 和 BizBundle iOS 版 通过 [CocoaPods](http://cocoapods.org/) 进行集成。您需要安装 CocoaPods 才能运行本示例。如果你没有安装 CocoaPods，可以通过以下命令安装 CocoaPods:

    ```bash
    sudo gem install cocoapods
    pod setup
    ```

2. Clone 或者下载本示例源码，打开终端并进入 **Podfile** 所在的文件夹路径下，然后在终端执行以下命令:

    ```bash
    pod install
    ```

3. 运行本示例需要 **AppKey**、**SecretKey** 和 **安全图片**。您可以前往 [涂鸦开发者 IoT 平台](https://developer.tuya.com/cn/) 注册成为开发者，并通过以下步骤获取：

   1. 登录 [涂鸦 IoT 开发平台](https://iot.tuya.com/)，在左侧导航栏面板分别选择： **App** -> **SDK 开发**。

   2. 点击 **创建 App** 按钮，开始创建应用。

   3. 填写必要的应用信息，包括 应用名称、Bundle ID 等。

   4. 点击创建好的应用，在 **获取密钥** 页签，可以获取 SDK 的 **AppKey**、**AppSecret**、安全图片 等信息。

4. 打开本示例工程的 `TuyaSmartResidenceSDKSample-iOS-ObjC.xcworkspace`。

5. 在 **AppDelegate.m** 中将 `AppKey`、`SecretKey`替换为你的 **AppKey** 和 **AppSecret**。

    ```objective-c
    #define APP_KEY @"<#AppKey#>"
    #define APP_SECRET_KEY @"<#SecretKey#>"
    ```

6. 下载 **安全图片** 并重命名为 `t_s.bmp`，将安全图片拖拽到 `Info.plist` 所在的文件夹下。
7. 如果您想在搭载 M1 芯片的 MacBook 提供的模拟器上调试，前往 `Pods` > `PROJECT`，加入下图所示内容。

    <img alt="Pods" src="https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/1638348535b9dac74712e.png" width="900">

**注意**：**Bundle ID**、**AppKey**、**AppSecret** 和 安全图片 必须与您在 [涂鸦 IoT 开发平台](https://iot.tuya.com/) 创建的应用配置保持一致。否则，本示例工程无法正常运行。

## 开发文档

关于 智慧居住 App SDK iOS 版 的更多信息，请参考：[智慧居住 App SDK](https://developer.tuya.com/cn/docs/app-development/saas-smart-residence-ios?id=Kb3npxylwo4dm)。
