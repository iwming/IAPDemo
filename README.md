# IAPDemo
一、Contracts, Tax, and Banking Information
该模块完成财政相关信息 部分信息不可修改
1、同意最新的  Developer Program License Agreement.
2、完成你的 contract, tax, and banking Information.
必须有一个有效的 iOS Paid Applications contract (iOS) or a Mac OS X Paid Applications contract (OS X)
完成图：
https://developer.apple.com/library/ios/technotes/tn2259/Art/tn2259_contract.png

二、Certificates, Identifiers & Profiles
1、注册 APP ID （不含通配符）支持 in-app purchase
2、用注册的APP ID 创建、下载、安装 新的 Development Provisioning Profile  
完成图：
https://developer.apple.com/library/ios/technotes/tn2259/Art/TN2259_ProvisioningProfilePortal.png

三、iTunes Connect
为了测试In-APP Purchase ，必须创建要购买的产品、测试账户完成购买 
1、创建测试账户
Apple 提供沙河测试环境，允许用测试账户内购功能而不需要真正支付。
2、创建内购的产品（via the Manage In-App Purchases）
填写 内购支付表单 --- Product ID 一个唯一的识别码 一般为com.xxx.xxx
使你的产品状态为等待上传截图 --- 等你完成测试 并 准备上传审核时 上传你的截图
Note: Upload a a screenshot of your In-App Purchase product once you are done testing it and ready to upload it for review.https://developer.apple.com/library/ios/technotes/tn2259/Art/tn2259_AppAndIAPProducts.png
四、What's Next
XCode 相关操作
1、项目中info.plist 的Bundle identifier 填写申请的 APP ID 绑定的  Bundle Identifier 部分
2、填写 Plist中的Version 和 Build 
https://developer.apple.com/library/ios/technotes/tn2259/Art/TN2259_XcodeProject.png
3、设置证书签名  iOS Development Certificate/Provisioning Profile pair (iOS) 
4、完成编码 
5、在沙河环境中测试应用
① 在设置中登出账号
② 连接设备 用Xcode写入设备
6、测试通过后提交审核