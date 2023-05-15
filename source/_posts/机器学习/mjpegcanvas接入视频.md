---
title:mjpegcanvas接入视频
date:2021-07-09 15:50:00
comments:false
author:8963
tags:
  - ros
categories:
  - 机器学习
---

# 启动 usb 摄像头

编写 launch 启动摄像头，通过 topic 传输视频流

```xml
<launch>
     <!--
         default 修改摄像头的名称
         与 guvcview -d /dev/video2 测试的名称一致
     -->
     <arg name="video_device" default="/dev/video2" />

 <!--节点的名字叫做usb_cam，然后运行一个叫usb_cam_node的可执行文件，这个文件在ros的lib里面，找不到源码文件，只有这个包装好可执行文件-->
     <node name="usb_cam" pkg="usb_cam" type="usb_cam_node" clear_params="true" output="screen">
         <!-- to="/camera/rgb/image_raw" 映射的topic , 前端通过此topic获取视频  -->
         <remap from="usb_cam/image_raw" to="/camera/rgb/image_raw" />
         <remap from="usb_cam/camera_info" to="/camera/rgb/camera_info" />
         <!-- 摄像头编号类型 -->
         <param name="video_device" value="$(arg video_device)" />
         <!-- 摄像头页面的宽 -->
         <param name="image_width" value="1920" />
         <!-- 摄像头页面的高 -->
         <param name="image_height" value="1020" />
         <!-- 帧率 -->
         <param name="framerate" value="30" />
         <!-- 像素编码，可选值：mjepg、yuyv、uyvy，类型：string -->
         <param name="pixel_format" value="yuyv" />
         <!-- 对比度 -->
         <param name="contrast" value="32" />
         <!-- 亮度 -->
         <param name="brightness" value="32" />
         <!-- 饱和度 -->
         <param name="saturation" value="32" />
         <!-- 自动聚焦 -->
         <param name="autofocus" value="true" />
         <!-- 摄像头坐标系，类型：string -->
         <param name="camera_frame_id" value="camera_link" />
     </node>
 </launch>
```

# 前端接入摄像头

打开前端之前要启动 rosbridge.launch 构建 websoket 连接进行通信

47 行的 topic 就是`launch` 中 11 行 `to=` 的 topic 名称

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <script src="./lib/roslib.js"></script>
    <script type="text/javascript" src="./lib/eventemitter2.min.js"></script>
    <script type="text/javascript" src="./lib/mjpegcanvas.min.js"></script>
  </head>

  <body>
    <div id="videoCanvas" style="display: block;"></div>
    <br />
    <script>
      var ros = new ROSLIB.Ros();
      var serverURL = "ws://127.0.0.1:9090";
      // mjpeg 视频质量
      var videoQuality = 50;
      // 设置视频窗口的宽高
      var videoWidth = Math.round(800);
      var videoHeight = Math.round((videoWidth * 240) / 320);

      ros.connect(serverURL);
      ros.on("error", function (error) {
        console.log(error);
      });

      ros.on("connection", function () {
        console.log("--- 连接成功 ---");
        //
        var videoTopicParam = new ROSLIB.Param({
          ros: ros,
          name: "/robot_gui/videoTopic",
        });

        videoTopicParam.get(function (value) {
          new MJPEGCANVAS.Viewer({
            divID: "videoCanvas",
            host: "127.0.0.1",
            port: "9090",
            width: videoWidth,
            height: videoHeight,
            quality: videoQuality,
            topic: "/camera/rgb/dell",
          });
        });
      });

      ros.on("close", function () {
        console.log("Connection closed.");
      });
    </script>
  </body>
</html>
```

# 同时接入多个摄像头视频

在一个 launch 文件中 启动两个节点

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070921878.png)

launch 文件

```xml
<launch>
    <!-- 戴尔内置摄像头 -->
    <arg name="dell" default="/dev/video0" />
    <node name="usb_cam" pkg="usb_cam" type="usb_cam_node" clear_params="true" output="screen">
        <remap from="usb_cam/image_raw" to="/camera/rgb/dell" />
        <remap from="usb_cam/camera_info" to="/camera/rgb/camera_info_dell" />
        <param name="video_device" value="$(arg dell)" />
        <param name="image_width" value="640" />
        <param name="image_height" value="480" />
        <param name="framerate" value="30" />
        <param name="pixel_format" value="mjpeg" />
        <param name="contrast" value="32" />
        <param name="brightness" value="32" />
        <param name="saturation" value="32" />
        <param name="autofocus" value="true" />
        <param name="camera_frame_id" value="camera_link" />
    </node>

    <!-- 外接摄像头 -->
    <arg name="leopard" default="/dev/video2" />
    <node name="usb_cam1" pkg="usb_cam" type="usb_cam_node" clear_params="true" output="screen">
        <remap from="usb_cam1/image_raw" to="/camera/rgb/leopard" />
        <remap from="usb_cam1/camera_info" to="/camera/rgb/camera_info_leopard" />
        <param name="video_device" value="$(arg leopard)" />
        <param name="image_width" value="1920" />
        <param name="image_height" value="1020" />
        <param name="framerate" value="30" />
        <param name="pixel_format" value="yuyv" />
        <param name="contrast" value="32" />
        <param name="brightness" value="32" />
        <param name="saturation" value="32" />
        <param name="autofocus" value="true" />
        <param name="camera_frame_id" value="camera_link" />
    </node>
</launch>
```

前端部分

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <script src="./js/roslib.js"></script>
    <script type="text/javascript" src="js/eventemitter2.min.js"></script>
    <script type="text/javascript" src="js/mjpegcanvas.min.js"></script>
    <script type="text/javascript" src="js/roslib.min.js"></script>
  </head>

  <body>
    <div id="videoCanvasD" style="display: block;"></div>
    <br />
    <div id="videoCanvasL" style="display: block;"></div>
    <script>
      var ros = new ROSLIB.Ros();
      // 相应地设置rosbridge主机名和端口
      var rosbridgeHost = document.location.hostname;
      var rosbridgePort = "9090";
      var serverURL = "ws://" + rosbridgeHost + ":" + rosbridgePort;
      // 设置相机相关参数
      var mjpegHost = document.location.hostname;
      var mjpegPort = "8080";
      // 默认视频主题（可以在rosbridge启动文件中设置）
      var videoTopic = "/camera/rgb/image_raw";
      // mjpeg 视频质量
      var videoQuality = 50;
      // 设置视频窗口的宽高
      var videoWidth = Math.round(800);
      var videoHeight = Math.round((videoWidth * 240) / 320);
      ros.connect(serverURL);
      ros.on("error", function (error) {
        console.log(error);
      });

      ros.on("connection", function () {
        console.log("--- 连接成功 ---");
        //
        var videoTopicParam = new ROSLIB.Param({
          ros: ros,
          name: "/robot_gui/videoTopic",
        });

        videoTopicParam.get(function (value) {
          if (value != null) {
            videoTopic = value;
            console.log(videoTopic);
          }
          new MJPEGCANVAS.Viewer({
            divID: "videoCanvasD",
            host: mjpegHost,
            port: mjpegPort,
            width: videoWidth,
            height: videoHeight,
            quality: videoQuality,
            topic: "/camera/rgb/dell",
          });
          new MJPEGCANVAS.Viewer({
            divID: "videoCanvasL",
            host: mjpegHost,
            port: mjpegPort,
            width: videoWidth,
            height: videoHeight,
            quality: videoQuality,
            topic: "/camera/rgb/leopard",
          });
        });
      });
      ros.on("close", function () {
        console.log("Connection closed.");
      });
    </script>
  </body>
</html>
```