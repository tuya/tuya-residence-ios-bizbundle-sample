# Tuya Smart Residence App SDK and Bizbundle Sample in Objective-C for iOS

 [English](README.md) | [中文版](README-zh.md)

---

This sample demonstrates the use of Tuya Smart Residence App SDK to build a smart residence app and how to integrate UI bizbundle. The SDK is divided into several functional modules to give you a clear insight into the implementation of different features, including the user registration process, site management by different users, app access management, and password access management.


## Prerequisites

- Xcode 13.0 and later
- iOS 12 and later

## Use the sample

1. Tuya Smart Residence App SDK and Bizbundle is distributed based on [CocoaPods](http://cocoapods.org/) and other dependencies in this sample. Make sure that you have installed CocoaPods. If not, run the following command to install CocoaPods first:

    ```bash
    sudo gem install cocoapods
    pod setup
    ```

2. Clone or download this sample, change the directory to the one that includes **Podfile**, and then run the following command:

    ```bash
    pod install
    ```

3. This sample requires you to get a pair of keys and a security image from [Tuya Developer Platform](https://developer.tuya.com/), and register a developer account on this platform if you do not have one. Then, perform the following steps:

   1. Log in to the [Tuya IoT Development Platform](https://iot.tuya.com/). In the left-side navigation pane, choose **App** > **SDK Development**.

   2. Click **Create** to create an app.

   3. Fill in the required information. Make sure that you enter the valid Bundle ID. It cannot be changed afterward.

   4. You can find the AppKey, AppSecret, and security image on the **Get Key** tab.

4. Open the `TuyaSmartResidenceSDKSample-iOS-ObjC.xcworkspace` pod generated for you.

5. Fill in the AppKey and AppSecret in the **AppDelegate.m** file.

    ```objective-c
    #define APP_KEY @"<#AppKey#>"
    #define APP_SECRET_KEY @"<#SecretKey#>"
    ```

6. Download the security image, rename it `t_s.bmp`, and then drag it to the workspace at the same level as `Info.plist`.

7. To debug it by using a simulator on a MacBook with the M1 chip, add the following content to the Pods project.

    <img alt="Pods" src="https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/1638348535b9dac74712e.png" width="900">

**Note**: The bundle ID, AppKey, AppSecret, and security image must be the same as those used for your app on the [Tuya IoT Development Platform](https://iot.tuya.com). Otherwise, API requests in the sample will fail.

## References
For more information about Tuya Smart Residence App SDK, see [App SDK](https://developer.tuya.com/en/docs/app-development/saas-smart-residence-ios?id=Kb3npxylwo4dm).
