---
title:Laravel + Vue
date:2022-09-18 23:10:00
comments:false
author:8963
tags:
  - Laravel
  - Vue
categories:
  - 开发
---

laravel + vue

<!-- more -->

# Laravel

安装 Composer

http://composer.p2hp.com/download/

修改 Composer 源

国内

```cpp
composer config -g repo.packagist composer https://packagist.phpcomposer.com 
```

原来

```cpp
composer config -g repo.packagist composer https://repo.packagist.org
```

其他镜像

| 镜像名                      | 地址                                                         | 赞助商   | 更新频率 | 备注   |
| --------------------------- | ------------------------------------------------------------ | -------- | -------- | ------ |
| 阿里云 Composer 镜像        | [https://mirrors.aliyun.com/composer/](https://links.jianshu.com/go?to=https%3A%2F%2Fmirrors.aliyun.com%2Fcomposer%2F) | 阿里云   | 96 秒    | 推荐   |
| 腾讯云 Composer 镜像        | [https://mirrors.cloud.tencent.com/composer/](https://links.jianshu.com/go?to=https%3A%2F%2Fmirrors.cloud.tencent.com%2Fcomposer%2F) | 腾讯云   | 24 小时  | -      |
| PHP 国内 Composer 镜像      | [https://packagist.phpcomposer.com](https://links.jianshu.com/go?to=https%3A%2F%2Fpackagist.phpcomposer.com) | 仁润股份 | 24 小时  | 不稳定 |
| 华为云 Composer 镜像        | [https://repo.huaweicloud.com/repository/php/](https://links.jianshu.com/go?to=https%3A%2F%2Frepo.huaweicloud.com%2Frepository%2Fphp%2F) | 华为云   | 未知     | 未知   |
| php.cnpkg.org Composer 镜像 | [https://php.cnpkg.org](https://links.jianshu.com/go?to=https%3A%2F%2Fphp.cnpkg.org) | 安畅网络 | 60 秒    | -      |

配置阿里云

```
composer config -g repos.packagist composer https://mirrors.aliyun.com/composer/
```

安装 Laravel 安装器

```
composer global require "laravel/installer"
```

创建项目

```
laravel new projectName
```

创建laravel其他版本项目

```
composer create-project --prefer-dist laravel/laravel 项目名 "5.8.*"
```

Breeze 套件

http://laravel.p2hp.com/cndocs/9.x/starter-kits

```
php artisan breeze:install

npm install
npm run dev
php artisan migrate
```

# 数据迁移

https://learnku.com/docs/laravel/8.5/migrations/10406#introduction

```
php artisan make:migration User
```

迁移文件

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class User extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::create('users',function (Blueprint $table){
            $table->increments('id');
            $table->string('username');
            $table->string('password');
            $table->string('power');
            $table->string('superior');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
}
```

运行迁移

```
php artisan migrate
```

# 数据填充

```
php artisan make:seeder UserSeeder
```

