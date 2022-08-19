# Flutter Voip24h-SDK Mobile

[![pub package](https://img.shields.io/pub/v/voip24h_sdk_mobile.svg)](https://pub.dev/packages/voip24h_sdk_mobile)

## Mục lục

- [Tính năng](#tính-năng)
- [Yêu cầu](#yêu-cầu)
- [Cài đặt](#cài-đặt)
- [Khai báo module](#khai-báo-module)
- [CallKit](#callkit)
- [Graph](#graph)

## Tính năng
| Chức năng | Mô tả |
| --------- | ----- |
| CallKit   | • Đăng nhập/Đăng xuất/Refresh kết nối tài khoản SIP <br> • Gọi đi/Nhận cuộc gọi đến <br> • Chấp nhận cuộc gọi/Từ chối cuộc gọi đến/Ngắt máy <br> • Pause/Resume cuộc gọi <br> • Hold/Unhold cuộc gọi <br> • Bật/Tắt mic <br> • Lấy trạng thái mic <br> • Bật/Tắt loa <br> • Lấy trạng thái loa <br> • Transfer cuộc gọi <br> • Send DTMF |
| Graph     | • Lấy access token <br> • Request API từ: https://docs-sdk.voip24h.vn/ |

## Yêu cầu
- OS Platform:
    - Android -> `minSdkVersion: 23`
    - IOS -> `iOS Deployment Target: 9.0`
- Permissions: khai báo và cấp quyền lúc runtime
    - Android: Trong file `AndroidManifest.xml`
        ```
        <uses-permission android:name="android.permission.INTERNET" />
        <uses-permission android:name="android.permission.RECORD_AUDIO"/>
        ```

    - IOS: Trong file `Info.plist`
        ```
        <key>NSAppTransportSecurity</key>
        <dict>
            <key>NSAllowsArbitraryLoads</key><true/>
        </dict>
        <key>NSMicrophoneUsageDescription</key>
        <string>{Your permission microphone description}</string>
        ```

## Cài đặt
Sử dụng terminal:
```bash
$ flutter pub add voip24h_sdk_mobile
```
Linking module:
- IOS:
    - Trong `ios/Podfile`:
        ```
        ...
        # Khai báo thư viện
        platform :ios, '9.0'
        source "https://gitlab.linphone.org/BC/public/podspec.git"

        target 'Your Project' do
            ...
            use_frameworks!
            use_modular_headers!

            flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

            # Khai báo thư viện 
            pod 'linphone-sdk-novideo' , '5.1.36'
        end
        ```
    - Trong folder `ios` mở terminal, nhập dòng lệnh:
        ```bash
        $ rm -rf Pods/
        $ pod install
        ```

## Khai báo module
```
import 'package:voip24h_sdk_mobile/voip24h_sdk_mobile.dart';
import 'package:voip24h_sdk_mobile/callkit/utils/sip_event.dart';
import 'package:voip24h_sdk_mobile/callkit/utils/transport_type.dart';
import 'package:voip24h_sdk_mobile/graph/extensions/extensions.dart';
import 'package:voip24h_sdk_mobile/callkit/model/sip_configuration.dart';

// TODO: Using module
```

## CallKit

* ### Khai báo sipConfiguration:

    ```
    var sipConfiguration = SipConfigurationBuilder(extension: "extension", domain: "domain", password: "password")
                            .setKeepAlive(true/false) // optional (bool)
                            .setPort(port) // optional (int)
                            .setTransport(TransportType.Udp/TransportType.Tcp/TransportType.Tls) // optional (enum)
                            .build(); 
    ```


| <div style="text-align: center">Chức năng</div> | <div style="text-align: center">Phương thức và tham số <br> (Dùng cơ chế async/await hoặc then để lấy dữ liệu trả về)</div> | Kết quả trả về và thuộc tính |
| :--- | :--- | :---: |
| Khởi tạo | Voip24hSdkMobile.callModule.initSipModule(sipConfiguration) | None |
| Lấy trạng thái đăng kí tài khoản SIP | Voip24hSdkMobile.callModule.getSipRegistrationState() | value: `String` <br> error: `String` |
| Logout tài khoản SIP | Voip24hSdkMobile.callModule.unregisterSipAccount() | value: `bool` <br> error: `String` |
| Refresh kết nối SIP | Voip24hSdkMobile.callModule.refreshSipAccount() | value: `bool` <br> error: `String` |
| Gọi đi | Voip24hSdkMobile.callModule.call(phoneNumber) | value: `bool` <br> error: `String` |
| Ngắt máy | Voip24hSdkMobile.callModule.hangup() | value: `bool` <br> error: `String` |
| Chấp nhận cuộc gọi đến | Voip24hSdkMobile.callModule.answer() | value: `bool` <br> error: `String` |
| Từ chối cuộc gọi đến | Voip24hSdkMobile.callModule.reject() | value: `bool` <br> error: `String` |
| Transfer cuộc gọi | Voip24hSdkMobile.callModule.transfer("extension") | value: `bool` <br> error: `String` |
| Lấy call id | Voip24hSdkMobile.callModule.getCallId() | value: `String` <br> error: `String`   |
| Lấy số lượng cuộc gọi nhỡ | Voip24hSdkMobile.callModule.getMissedCalls() | value: `int` <br> error: `String` |
| Pause cuộc gọi | Voip24hSdkMobile.callModule.pause() | value: `bool` <br> error: `String` |
| Resume cuộc gọi | Voip24hSdkMobile.callModule.resume() | value: `bool` <br> error: `String` |
| Bật/Tắt mic | Voip24hSdkMobile.callModule.toggleMic() | value: `bool` <br> error: `String` |
| Trạng thái mic | Voip24hSdkMobile.callModule.isMicEnabled() | value: `bool` <br> error: `String` |
| Bật/Tắt loa | Voip24hSdkMobile.callModule.toggleSpeaker() | value: `bool` <br> error: `String` |
| Trạng thái loa | Voip24hSdkMobile.callModule.isSpeakerEnabled() | value: `bool` <br> error: `String` |
| Send DTMF | Voip24hSdkMobile.callModule.sendDTMF("number#") | value: `bool` <br> error: `String` |

* ### Event listener SIP:

    ```
    Voip24hSdkMobile.callModule.eventStreamController.stream.listen((event) {
        switch (event['event']) {
            case SipEvent.AccountRegistrationStateChanged: {
                var body = event['body'];
                // TODO
            } break;
            case SipEvent.Ring: {
                // TODO
            } break;
            case ...
              break;
        }
    });

    ...

    @override
    void dispose() {
        Voip24hSdkMobile.callModule.eventStreamController.close();
        super.dispose();
    }
    ```

| <div style="text-align: left">Tên sự kiện</div> | <div style="text-align: left">Kết quả trả về và thuộc tính</div> | <div style="text-align: left">Đặc tả thuộc tính</div> |
| :--- | :--- | :--- |
| SipEvent.AccountRegistrationStateChanged | body = { <br>&emsp; registrationState: `String`, <br>&emsp; message: `String` <br> } | registrationState: trạng thái kết nối của sip (None/Progress/Ok/Cleared/Failed) <br> message: chuỗi mô tả trạng thái</div> |
| SipEvent.Ring | body = { <br>&emsp; extension: `String`, <br>&emsp; phoneNumber: `String` <br>&emsp; callType: `String` <br> } | extension: máy nhánh <br> phoneNumber: số điện thoại người (gọi/nhận) <br> callType: loại cuộc gọi(inbound/outbound) |
| SipEvent.Up | body = { <br>&emsp; callId: `String` <br> } | callId: mã cuộc gọi
| SipEvent.Hangup | body = { <br>&emsp; duration: `int` <br> } | duration: thời gian đàm thoại (milliseconds)
| SipEvent.Paused | None
| SipEvent.Resuming | None
| SipEvent.Missed | body = { <br>&emsp; phoneNumber: `String`, <br>&emsp; totalMissed: `int` <br> } | phone: số điện thoại người gọi <br> totalMissed: tổng cuộc gọi nhỡ
| SipEvent.Error | body = { <br>&emsp; message: `String` <br> } | message: trạng thái lỗi

## Graph
> • key và security certificate(secert) do `Voip24h` cung cấp
<br> • request api: phương thức, endpoint. data body tham khảo từ docs https://docs-sdk.voip24h.vn/

| <div style="text-aligns: center">Chức năng</div> | <div style="text-aligns: center">Phương thức</div> | <div style="text-aligns: center">Đặc tả tham số </div> | <div style="text-aligns: center">Kết quả trả về</div> | <div style="text-aligns: center">Đặc tả thuộc tính</div> |
| :--- | :--- | :--- | :--- | :--- |
| Lấy access token | Voip24hSdkMobile.graphModule.getAccessToken(apiKey: API_KEY, apiSecert: API_SECERT) | • apiKey: ``String``, <br> • secert: ``String`` | value: `Oauth` <br> error: ``String`` | • Oauth: gồm các thuộc tính (token, createAt, expired, isLongAlive) <br> • error: thông báo lỗi |
| Request API | Voip24hSdkMobile.graphModule.sendRequest(token: token, endpoint: endpoint, body: body) | • method: MethodRequest(MethodRequest.POST, MethodRequest.GET,...) <br> • endpoint: chuỗi cuối của URL request: "call/find", "call/findone",... <br> • token: access token <br> • params: data body dạng object như { "offset": "0", "limit": "25" } | value: `Map<`String`, dynamic>` <br> error: ``String`` | • value: kết quả response dạng key - value <br> • error: mã lỗi |
| Lấy data object | value.getData() <br> (Dạng extension function) | None | object: `Object` | object gồm các thuộc tính được mô tả ở dữ liệu trả về trong docs https://docs-sdk.voip24h.vn/ |
| Lấy danh sách data object | value.getDataList() <br> (Dạng extension function) |  | List`<Object>` | mỗi object gồm các thuộc tính được mô tả ở dữ liệu trả về trong docs https://docs-sdk.voip24h.vn/ |
| Lấy status code | value.statusCode() <br> (Dạng extension function) |  | `int` | mã trạng thái |
| Lấy message | value.message() <br> (Dạng extension function) |  | `String` | chuỗi mô tả trạng thái |
| Lấy limit | value.limit() <br> (Dạng extension function) |  | `int` | giới hạn dữ liệu của dữ liệu tìm được |
| Lấy offset | value.offset() <br> (Dạng extension function) |  | `int` | vị trí bắt đầu của dữ liệu tìm được |
| Lấy total | value.total() <br> (Dạng extension function) |  | `int` | tổng số lượng dữ liệu |
| Lấy kiểu sắp xếp | value.isSort() <br> (Dạng extension function) |  | `String` | kiểu sắp xếp dữ liệu |