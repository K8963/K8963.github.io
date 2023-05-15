---
title:Roslibjs应用库
date:2021-06-19 11:59:00
comments:false
author:8963
tags:
  - ros
categories:
  - 机器学习
---

Roslibjs - js 与 ros 交互核心库

<!-- more -->

# JS 应用库

- [roslibjs](http://wiki.ros.org/roslibjs) 教程

\> 是 JavaScript 的核心库，用于与浏览器中的 ROS 进行交互。它使用 websocket 连接 rossbridge，并提供发布、订阅、服务调用、 actionlib、 TF、 URDF 解析和其他基本的 ROS 功能。Roslibjs 是 Robot Web Tools 的一部分。

- [roslibjs 源码](https://github.com/RobotWebTools/roslibjs)

## 运行 Demo

下载 [roslibjs 源码](https://github.com/RobotWebTools/roslibjs)

浏览器打开 Demo 目录下的 examples/simple.html 可以看到

```
Simple roslib Example
Run the following commands in the terminal then refresh this page. Check the JavaScript console for the output.
在终端中运行以下命令，然后刷新此页。检查JavaScript控制台的输出。

1.roscore
2.rostopic pub /listener std_msgs/String "Hello, World"
3.rostopic echo /cmd_vel
4.rosrun rospy_tutorials add_two_ints_server
5.roslaunch rosbridge_server rosbridge_websocket.launch

Error in the backend! Connection closed.
链接关闭
```

第一步, 执行 roscore

2,3 步的命令用于监视 rostopic 话题

运行 4,5 便可以看到实际效果

后端同步运行 , 可以看到发送的消息

```
rostopic echo topic的名称
```

其他常用命令:

```
rostopic list 列出所有的topic

rostopic echo topic名称 显示topic上发布的message

rostopic type topic名称 查看topic的message类型

rosmsg show message名称 查看message数据结构
```

## 详解 simple.html

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <!-- 导入应用程序所需的所有 JavaScript 文件 -->
    <script src="https://static.robotwebtools.org/EventEmitter2/current/eventemitter2.min.js"></script>
    <script src="../build/roslib.js"></script>

    <script>
      // 创建一个 Ros 节点对象来与 rosbridge v2.0服务器通信
      var ros = new ROSLIB.Ros();
      ros.connect("ws://localhost:9090");
      // 监视 rosbridge 服务器的连接。,监听连接状态:error,connection,close
      ros.on("error", function (error) {
        // 操作消息状态的显示
        document.getElementById("connecting").style.display = "none";
        document.getElementById("connected").style.display = "none";
        document.getElementById("closed").style.display = "none";
        // 当前为error
        document.getElementById("error").style.display = "inline";
        console.log(error);
      });

      ros.on("connection", function () {
        console.log("Connection made!");
        document.getElementById("connecting").style.display = "none";
        document.getElementById("error").style.display = "none";
        document.getElementById("closed").style.display = "none";
        document.getElementById("connected").style.display = "inline";
      });

      ros.on("close", function () {
        console.log("Connection closed.");
        document.getElementById("connecting").style.display = "none";
        document.getElementById("connected").style.display = "none";
        document.getElementById("closed").style.display = "inline";
      });

      // 新建一个 topic 话题 http://robotwebtools.org/jsdoc/roslibjs/current/Topic.html
      // 话题声明话题名称、消息类型，并传递前面的 ROS 对象
      var cmdVel = new ROSLIB.Topic({
        ros: ros,
        // 话题名称
        name: "/cmd_vel",
        // 消息类型, Twist - 线速度角速度
        messageType: "geometry_msgs/Twist",
      });
      // 创建一个新的 ROSLIB.Message
      var twist = new ROSLIB.Message({
        linear: {
          x: 0.1,
          y: 0.2,
          z: 0.3,
        },
        angular: {
          x: -0.1,
          y: -0.2,
          z: -0.3,
        },
      });

      // cmdVel是一个话题的名称,通过cmdVel调用topic方法 pulish()
      // pulish(一个 ROSLIB.Message 对象) 发布消息,
      cmdVel.publish(twist);

      // 新建一个监听器话题
      var listener = new ROSLIB.Topic({
        ros: ros,
        name: "/listener",
        // 消息类型
        messageType: "std_msgs/String",
      });
      /* 通过对listener话题调用 subscribe ()并传入回调，就可以进行订阅。
     无论何时 ROS 在“/listener”主题上发布消息，rosbridge 都会将该消息转发给浏览器，
     并使用该消息调用回调函数。
  */
      listener.subscribe(function (message) {
        // 打印收到的消息
        console.log(
          "Received message on " + listener.name + ": " + message.data
        );

        // 取消订阅话题
        listener.unsubscribe();
      });

      // 创建一个 ROSLIB.Service 对象
      // 它类似于上面的 ROSLIB.Topic 对象，因为它负责与 ROS 服务的所有交互。
      var addTwoIntsClient = new ROSLIB.Service({
        ros: ros,
        name: "/add_two_ints",
        //
        serviceType: "rospy_tutorials/AddTwoInts",
      });
      // 发起请求,调用服务,并传递参数
      var request = new ROSLIB.ServiceRequest({
        a: 1,
        b: 2,
      });
      // ROSLIB.Service的方法
      // callService(request, callback, failedCallback)
      // request  要发送的 ROSLIB.ServiceRequest
      addTwoIntsClient.callService(request, function (result) {
        // 结果,打印服务的名字和结果数量
        console.log(
          "Result for service call on " +
            addTwoIntsClient.name +
            ": " +
            result.sum
        );
      });

      // 新建一个 获取和设置 ROS 参数 的对象
      var setBoolServer = new ROSLIB.Service({
        ros: ros,
        name: "/set_bool",
        serviceType: "std_srvs/SetBool",
      });
      // 新建一个广播
      setBoolServer.advertise(function (request, response) {
        // 打印收到的服务请求
        console.log(
          "Received service request on " +
            setBoolServer.name +
            ": " +
            request.data
        );
        // 响应消息
        response["success"] = true;
        response["message"] = "Set successfully";
        return true;
      });
      // 获取参数
      ros.getParams(function (params) {
        // 打印参数
        console.log(params);
      });
      // 新建一个 Param (操作参数)
      var maxVelX = new ROSLIB.Param({
        ros: ros,
        name: "max_vel_y",
      });
      // 使用简单的 param.set (value)来设置参数
      maxVelX.set(0.8);
      // 获取参数
      maxVelX.get(function (value) {
        console.log("MAX VAL: " + value);
      });

      // 新建 Param (操作参数)
      var favoriteColor = new ROSLIB.Param({
        ros: ros,
        name: "favorite_color",
      });
      // 设置参数
      favoriteColor.set("red");
      // 获取参数
      favoriteColor.get(function (value) {
        console.log("My robot's favorite color is " + value);
      });
    </script>
  </head>

  <body>
    <h1>Simple roslib Example</h1>
    <p>
      Run the following commands in the terminal then refresh this page. Check
      the JavaScript console for the output.
    </p>
    <ol>
      <li><tt>roscore</tt></li>
      <li><tt>rostopic pub /listener std_msgs/String "Hello, World"</tt></li>
      <li><tt>rostopic echo /cmd_vel</tt></li>
      <li><tt>rosrun rospy_tutorials add_two_ints_server</tt></li>
      <li><tt>roslaunch rosbridge_server rosbridge_websocket.launch</tt></li>
    </ol>
    <div id="statusIndicator">
      <p id="connecting">Connecting to rosbridge...</p>
      <p id="connected" style="color:#00D600; display:none">Connected</p>
      <p id="error" style="color:#FF0000; display:none">
        Error in the backend!
      </p>
      <p id="closed" style="display:none">Connection closed.</p>
    </div>
  </body>
</html>
```

整理一下,这个 Demo 中

1. 新建一个 Ros 节点对象并设置地址端口号 , 来与 rosbridge 服务通信

```
   var ros = new ROSLIB.Ros();
   ros.connect('ws://localhost:9090');
```

1. 监听 rosbridge 服务器的链接状态 , error\connection\close
2. 新建话题 cmdVel 用于传递消息

新建消息 twist

使用 cmdVel 传递 twist 消息

```
   cmdVel.publish(twist);
```

1. 话题监听器 listener

```
   listener.subscribe()
```

使用此方法接收监听到的消息

1. 新建 service

新建请求

```
   new ROSLIB.ServiceRequest()
```

调用服务请求

```
   new ROSLIB.Service().callService(request, callback, failedCallback)
```

1. 新建一个服务,用于获取和设置参数

新建广播 , 对于在此服务上发出的每个请求，都将调用该回调

```
   new ROSLIB.Service().advertise()
```

获取参数

```
   new ROSLIB.Param().get()
```

设置参数

```
   new ROSLIB.Param().set()
```

# 自己的 Demo

查看官方 Demo 之后,自己尝试与 ros 交互

## 创建节点

引入包 , EventEmitter2 和 roslibjs

创建一个 Ros 节点对象来与 rosbridge v2.0 服务器通信

```
    var ros = new ROSLIB.Ros();
    ros.connect('ws://localhost:9090');

    ros.on('error', function (error) {
      console.log(error);
    })
    ros.on('connection', function () {
      console.log("-----------连接成功-----------");
    })
    ros.on('close', function () {
      console.log("-----------连接断开-----------");
    })
```

## 前端向 ros 发送消息

```javascript
var oneTopic = new ROSLIB.Topic({
  ros: ros,
  name: "/oneTopic",
  messageType: "std_msgs/String",
});
var oneMes = new ROSLIB.Message({
  data: "hello word!",
});

oneTopic.publish(oneMes);
```

打开终端,通过此命令可以查看已经发送成功

```
rostopic echo /oneTopic
```

## 前端接收 ros 的消息

```javascript
// 前端接收ros的消息
var receiveTopic = new ROSLIB.Topic({
  ros: ros,
  name: "/receiveTopic",
  messageType: "std_msgs/String",
});
receiveTopic.subscribe(function (message) {
  console.log(message.data);
  receiveTopic.unsubscribe();
});
```

终端运行

rostopic pub topic 的名称 消息类型 消息内容

```
rostopic pub /receiveTopic std_msgs/String "Hello,Ros"
```

之后便可以看到控制台打印消息