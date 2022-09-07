---
title: Laravel-数据表迁移与填充
date: 2020-09-7 11:02:25
comments: false 
tags:
  - Laravel
  - PHP
categories:
  - 后端
---

Laravel-数据表迁移与填充
<!-- more -->

创建模型与填充文件：

例如：创建一个文章数据表

```javascript
php artisan make:model Article -m
```

-m 是 --migration 的缩写，告知 Artisan 在创建模型同时创建与之对应的迁移文件

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070830770.png)

迁移文件位置   `项目根目录\database\migrations`

```php
<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateArticlesTable extends Migration
{
  /**
   * Run the migrations.
   *
   * @return void
   */
  public function up()
  {
    Schema::create('articles', function (Blueprint $table) {
      $table->increments('id'); //id
      $table->string('title');	//文章标题
      $table->string('outline');//概要
      $table->string('author');//作者
      $table->text('content'); //内容
      $table->text('html');		//html内容
      $table->string('category');	//类别
      $table->string('tag');	//标签
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
    Schema::dropIfExists('articles');
  }
}

```

列类型可[查看](https://blog.csdn.net/weixin_36934930/article/details/100693183)

执行迁移文件

```php
php artisan migrate
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070830773.png)

模型：

```php
<?php

namespace App\Admin;

use Illuminate\Database\Eloquent\Model;

class Article extends Model
{
    //定义模型关联的数据表 文章表
    protected $table = 'articles';
    //定义主键
    protected $primaryKey = 'id';
    //定义禁止操作时间
    public $timestamps = false;
    //定义允许写入的数据字段
    protected $fillable = [
    'id', 
    'title',
    'author',
    'outline', 
    'content',
    'html',
    'category',
    'tag',
    'created_at', 
    'updated_at'];
}
```

创建填充器，生成随机测试数据

```php
php artisan make:seeder ArticlesTableSeeder
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070830192.png)

填充器位置：`项目根目录下\database\seeds`

使用faker库快速填充数据，[
可查看](https://www.cnblogs.com/jxl1996/p/10335920.html)

```php
<?php

use Illuminate\Database\Seeder;
use App\Article;

class ArticlesTableSeeder extends Seeder
{
  /**
   * Run the database seeds.
   *
   * @return void
   */
  public function run()
  {
    // Let's truncate our existing records to start from scratch.
    Article::truncate();

    $faker = \Faker\Factory::create();
    $categoryList = ['前端', '后端', '网络'];
    $tagList = ['JAVA', 'PHP', 'Mysql', 'Javascript', 'Python'];

    // And now, let's create a few articles in our database:
    for ($i = 0; $i < 20; $i++) {
      Article::create([
        'title' => $faker->sentence,
        'outline' => $faker->sentence,
        'author' => '8963',
        'content' => $faker->paragraph,
        'html' => $faker->paragraph,
        'category' => $faker->randomElement($categoryList),
        'tag' => $faker->randomElement($tagList),
      ]);
    }
  }
}
```

执行数据填充命令，生成数据

```php
php artisan db:seed --class=ArticlesTableSeeder
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070831552.png)