---
title: layui 下拉搜索框异步获取数据
date: 2021-01-27 12:55:25
comments: false 
tags:
  - Layui
  - jQuery
categories:
  - 前端
---

layui 下拉搜索框异步获取数据

<!-- more -->

从后台获取数据之后，由于layui没有双向绑定机制，需要`layui.form.render()` 进行重新渲染，重新渲染表单之后需要为 `input` 重新绑定事件使用jQuery的事件委托方法`on` , 给 input 的父元素绑定，这样重新渲染元素的时候可以重新绑定事件。

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Document</title>
  <link rel="stylesheet" href="./layui/css/layui.css">
</head>
<style>
  form {
    width: 500px;
    margin: 20px;
  }
</style>

<body>
  <form action="" class="layui-form" lay-filter="test">
    <label for="" class="layui-form-label">请选择</label>
    <div class="layui-inline" id="selSear">
      <select name="city" id="selectCity" lay-search>
        <option value="">请选择城市</option>
      </select>
    </div>
  </form>
  <script src="./layui/layui.all.js"></script>
  <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script>
    layui.use('form', function () {
      let form = layui.form;
      let ss = $("#selSear .layui-form-select .layui-select-title input");
      let selectCity = $("#selectCity")[0];
      let lessons = '';
      let fu = $("#selSear")

      fu.on('input porpertychange', 'input', function () {
        let searchV = $("#selSear input")[0].value;
        $.ajax({
          url: "data.json",
          data: searchV,
          type: "GET",
          dataType: "json",
          success: function (res) {
            $.each(res.data.city, (index, item) => {
              if (searchV != '') {
                let findV = item.cityName.indexOf(searchV)
                if (findV != -1) {
                  lessons += '<option value=' + item.value + '>' + item.cityName + '</option>';
                  selectCity.innerHTML = lessons;
                  layui.form.render('select');
                  console.log(selectCity.innerHTML);
                }
              }
            })
            lessons = '<option value="">请选择城市</option>';
          }
        })
      });
    })
  </script>
</body>

</html>
```

