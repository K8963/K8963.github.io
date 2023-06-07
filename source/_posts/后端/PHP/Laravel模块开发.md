---
title: Laravel模块开发
date: 2023-01-31 09:20:25
comments: false
author: 8963
tags:
  - Laravel
  - PHP
categories:
  - 后端
---

Laravel模块开发

<!-- more -->

# 安装Laravel

1. 创建laravel项目
2. 安装模块
3. 发布配置文件

```
composer create-project --prefer-dist laravel/laravel server
cd server
composer require nwidart/laravel-modules
php artisan vendor:publish --provider="Nwidart\Modules\LaravelModulesServiceProvider"
```

生成项目模块

```
php artisan module:make Admin
```

要让模块目录中定义的类可以自动加载，需要配置根目录下的composer.json。

```json
{
  "autoload": {
    "psr-4": {
      "App\\": "app/",
      "Modules\\": "Modules/"
    }
  }
}
```

配置完成后运行以下命令让修改生效。

```
composer dump-autoload
```

如果你使用 `Nginx` ，在你的站点配置中加入以下配置，所有的请求将会引导至`index.php`前端控制器：

```
location / {
    try_files $uri $uri/ /index.php?$query_string;
}
```

![image-20220910151806371](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202305151534497.png)

执行域名加模块名

![image-20220910152632785](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202305151534281.png)

# 数据迁移

拉取组件

默认laravel是没有带添加表注释组件的，这里需要安装zedisdog/laravel-schema-extend包

> 该组件包要求使用大于等于5.0版本的laravel

```
composer require zedisdog/laravel-schema-extend
```

申明依赖

修改`./config/app.php->aliases`

```php
'aliases' => [
    ...
    // 'Schema' => Illuminate\Support\Facades\Schema::class,
    'Schema'    => Jialeo\LaravelSchemaExtend\Schema::class,

],
```

使用：默认创建的migration文件对应的“Schema”还是引用laravel自带的，需要修改为该组件包的引用

```php
 //use Illuminate\\Support\\Facades\\Schema;
 use Jialeo\\LaravelSchemaExtend\\Schema;
Schema::create('users', function (Blueprint $table) {
$table->comment = '用户表';
 });
```

过程

1. 创建迁移文件：

  ```
php artisan module:make-migration  表名 模块名
  ```

  例如：

  ```
php artisan module:make-migration  create_auths_table Admin
php artisan make:migration add_images_to_articles_table --table=articles
  ```

2. 执行迁移文件：

  ```
php artisan module:migrate Admin
  ```

3. 修改表字段：

  ```
php artisan module:make-migration update_moments_table
  ```

4. 重新执行迁移文件：

  ```
php artisan module:migrate-refresh Admin
  ```

5. 创建数据填充文件：

  ```
php artisan module:make-seed  auths_table_seeder AuthAdmin
  ```

6. 执行数据填充文件：

  ```
php artisan module:seed AuthAdmin
  ```

# 路由

https://learnku.com/docs/laravel/8.5/routing/10368

api 接口开发中,路由应当定义在 `api.php`中 , 在请求时需要在 请求地址之后添加一个`api`

如:

![image-20220910155248133](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202305151534443.png)

## 参数

可选参数 \ 默认参数

获取请求的参数

```
Route::get('/test/{id?}', function (Request $request,$id = 666) {
    $data = $request->all();
    $data['id']=$id;
    return $data;
});
```

![image-20220910162930953](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202305151535491.png)

## 请求方式

给一个路由定义多种请求方式

```php
Route::match(['get','post'],'/test/{id?}', function (Request $request,$id = 666) {
    $data = $request->all();
    $data['id']=$id;
    return $data;
});

Route::any('/test/{id?}', function (Request $request,$id = 666) {
    $data = $request->all();
    $data['id']=$id;
    return $data;
});
```



## 分组



```php
Route::prefix('admin')->group(function () {
    Route::get('/test', function () {
        // 匹配 「/admin/users」URL
        return 'admin/test';
    });
});

//Route::prefix('gongzz')->group(function () {
//    Route::get('/test', function () {
//        // 匹配 「/admin/users」URL
//        return 'gongzz/test';
//    });
//});

Route::group(["prefix"=>"gongzz"],function () {
    Route::get('/test', function () {
        // 匹配 「/admin/users」URL
        return 'gongzz/test/ ';
    });
});
```



## 中间件

https://learnku.com/docs/laravel/8.5/middleware/10369

路由中间件

```php
Route::group(["prefix"=>"gongzz","middleware"=>"AdminApiAuth"],function () {
    Route::get('/test', function () {
        return 'gongzz/test/ ';
    });
});
```

新建中间件文件`Modules\Admin\Http\Middleware\AdminApiAuth.php`

```php
<?php
/**
 * @name 后台权限中间件
 * @Auther 8963
 * @Date 2022/9/10 18:06
 * @Description
 */

namespace Modules\Admin\Http\Middleware;
use Closure;

class AdminApiAuth
{
    public function handle($request, Closure $next)
    {
        exit("中间件生效");
        return $next($request);
    }
}
```

注册中间件`app\Http\Kernel.php`

```php
protected $routeMiddleware = [
  'AdminApiAuth' => \Modules\Admin\Http\Middleware\AdminApiAuth::class
];
```

![image-20220910182102180](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202305151535042.png)



## v1

新建控制器`Modules\Admin\Http\Controllers\v1\IndexController.php`

```php
<?php
/**
 * @name
 * @Auther 8963
 * @Date 2022/9/11 09:39
 * @Description
 */

namespace Modules\Admin\Http\Controllers\v1;


use Illuminate\Routing\Controller;

class IndexController extends Controller
{
    public function test(){
        return "This is v1";
    }
}
```

`Modules\Admin\Routes\api.php`

```php
Route::group(["prefix"=>"v1/gongzz","middleware"=>"AdminApiAuth"],function () {
    Route::get("test", "v1\IndexController@test");
});
```



# 验证器

https://learnku.com/docs/laravel/8.5/validation/10378

在控制器中`Modules\Admin\Http\Controllers\v1\IndexController.php`

```php
<?php
/**
 * @name
 * @Auther 8963
 * @Date 2022/9/11 09:39
 * @Description
 */

namespace Modules\Admin\Http\Controllers\v1;


use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Validator;

class IndexController extends Controller
{
    public function test(Request $request){
        $validated = Validator::make($request->all(), [
            'title' => 'required',
            'body' => 'required',
        ],[
            'title.required' => '666666',
        ]);
//        打印错误信息
        return $validated->errors()->messages()['title'][0];
        if($validated->fails()){
            return 111;
        }
        return "This is v1";
    }
}
```

## 验证文件

创建验证文件

```
php artisan make:request TestRequest
```

创建模块化验证文件

```
php artisan modul:make-request TestRequest 模块名称
```

`/Modules/Admin/Http/Requests/TestRequest.php`

```php
<?php

namespace Modules\Admin\Http\Requests;

use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;

class TestRequest extends FormRequest
{
//    用户验证权限
    public function authorize()
    {
        return true;
    }
//    验证规则
    public function rules()
    {
        return [
            'title' => 'required',
            'body' => 'required',
        ];
    }
//    定义验证信息
    public function messages()
    {
        return [
            'title.required' => '666666',
        ];
    }
//    输出验证信息
    protected function failedValidation(Validator $validator)
    {
        dd($validator->errors()->messages());
    }
}
```

使用:在控制器中

```php
<?php
/**
 * @name
 * @Auther 8963
 * @Date 2022/9/11 09:39
 * @Description
 */

namespace Modules\Admin\Http\Controllers\v1;


use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Validator;
use Modules\Admin\Http\Requests\TestRequest;

class IndexController extends Controller
{
    public function test(TestRequest $request){
        return "This is v1";
    }
}
```



# 异常处理

先将验证文件中显示验证信息方法注释

![image-20220911121000397](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202305151535221.png)

`app\Exceptions\Handler.php`

将异常处理抽离到模块中,新建文件`Modules\Common\Exceptions\Handler.php`

修改配置`bootstrap\app.php`

```php
//$app->singleton(
//    Illuminate\Contracts\Debug\ExceptionHandler::class,
//    App\Exceptions\Handler::class
//);
$app->singleton(
    Illuminate\Contracts\Debug\ExceptionHandler::class,
    Modules\Common\Exceptions\Handler::class
);
```



# 用户模块 - 示例

## 数据迁移

生成模块

```
php artisan module:make Admin
```

创建迁移文件

> 创建权限相关表

```
php artisan module:make-migration  create_auths_table Admin
```

管理员表\工作站表

```php
<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateAuthsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        /**
         * 管理员表
         */
        Schema::create('auth_admins', function (Blueprint $table) {
            $table->comment = '管理员表';
            $table->increments('id')->comment('管理员ID');
            $table->string('name',100)->default('')->comment('名称');
            $table->string('password')->default('')->comment('密码');
            $table->integer('group_id')->nullable()->comment('工作站ID');
            $table->tinyInteger('status')->default(1)->comment('状态:0=禁用,1=启用');
            $table->timestamp('created_at')->nullable()->comment('创建时间');
            $table->timestamp('updated_at')->nullable()->comment('更新时间');
        });
        /**
         * 工作站表
         */
        Schema::create('auth_groups', function (Blueprint $table) {
            $table->comment = '工作站表';
            $table->increments('id')->comment('工作站ID');
            $table->string('name',100)->unique()->default('')->comment('工作站名称');
            $table->integer('image_id')->nullable()->comment('图片id');
            $table->string('content',500)->nullable()->default('')->comment('介绍');
            $table->tinyInteger('status')->default(1)->comment('状态:0=禁用,1=启用');
            $table->timestamp('created_at')->nullable()->comment('创建时间');
            $table->timestamp('updated_at')->nullable()->comment('更新时间');
        });
    }
}
```

执行迁移文件

```
php artisan module:migrate Admin
```

## 数据填充

填充文件

```php
class AuthsTableSeederTableSeeder extends Seeder
{
    public function run(){
        $image_id1 = DB::table('auth_images')->insertGetId([
            'url' => '/upload/images/common/logo.png',
            'open' => 1,
            'status'=>1,
            'created_at'=>date('Y-m-d H:i:s')
        ]);
        DB::table('auth_configs')->insert([
            'name' => '名医工作站管理系统',
            'image_status' => 1,
            'logo_id' => $image_id1,
            'about_us' => '1',
            'created_at'=>date('Y-m-d H:i:s')
        ]);
        $group_id = DB::table('auth_groups')->insertGetId([
            'name' => '工作站1',
            'image_id'=>1,
            'content'=>'介绍',
            'created_at'=>date('Y-m-d H:i:s')]);
        DB::table('auth_admins')->insert([
            'username' => 'admin',
            'password' => bcrypt('123456'),
            'group_id' => 0,
            'created_at'=>date('Y-m-d H:i:s')
        ]);
        DB::table('auth_admins')->insert([
            'username' => 'gzz1',
            'password' => bcrypt('123456'),
            'group_id' => $group_id,
            'created_at'=>date('Y-m-d H:i:s')
        ]);


    }
}
```

执行数据填充

```
php artisan module:seed Admin
```



## 登录

### 路由

路由`Modules\Admin\Routes\api.php`

```php
Route::group(["prefix"=>"v1/admin","middleware"=>"AdminApiAuth"],function () {
    //登录
    Route::post('login/login', 'v1\LoginController@login');
});
```

### 中间件

`Modules\Admin\Http\Middleware\AdminApiAuth.php`

```php
<?php
/**
 * @name    后台权限验证中间件
 * @Auther 8963
 * @Date 2022/9/11 16:14
 * @Description
 */

namespace Modules\Admin\Http\Middleware;


use Closure;
use Modules\Admin\Services\log\OperationLogService;
use Modules\Common\Exceptions\ApiException;
use Modules\Common\Exceptions\MessageData;
use Modules\Common\Exceptions\StatusData;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Exceptions\TokenBlacklistedException;
use JWTAuth;
class AdminApiAuth
{

    public function handle($request, Closure $next)
    {
        \Config::set('auth.defaults.guard', 'auth_admin');
        \Config::set('jwt.ttl', 60);
        $route_data = $request->route();
        $url = str_replace($route_data->getAction()['prefix'] . '/',"",$route_data->uri);
        $url_arr = ['login/login','index/getMain','index/refreshToken'];
        $api_key = $request->header('apikey');
        if($api_key != config('admin.api_key')){
            throw new ApiException(['status'=>StatusData::TOKEN_ERROR_KEY,'message'=>MessageData::TOKEN_ERROR_KEY]);
            return $next();
        }
        if(in_array($url,$url_arr)){
            return $next($request);
        }
        try {
            if (! $user = JWTAuth::parseToken()->authenticate()) {  //获取到用户数据，并赋值给$user   'msg' => '用户不存在'
                throw new ApiException(['status'=>StatusData::TOKEN_ERROR_SET,'message'=>MessageData::TOKEN_ERROR_SET]);
                return $next();
            }

        }catch (TokenBlacklistedException $e) {
            // 这个时候是老的token被拉到黑名单了
            throw new ApiException(['status'=>StatusData::TOKEN_ERROR_BLACK,'message'=>MessageData::TOKEN_ERROR_BLACK]);
            return $next();
        } catch (TokenExpiredException $e) {
            //token已过期
            throw new ApiException(['status'=>StatusData::TOKEN_ERROR_EXPIRED,'message'=>MessageData::TOKEN_ERROR_EXPIRED]);
            return $next();
        } catch (TokenInvalidException $e) {
            //token无效

            throw new ApiException(['status'=>StatusData::TOKEN_ERROR_JWT,'message'=>MessageData::TOKEN_ERROR_JWT]);

            return $next();
        } catch (JWTException $e) {
            //'缺少token'
            throw new ApiException(['status'=>StatusData::TOKEN_ERROR_JTB,'message'=>MessageData::TOKEN_ERROR_JTB]);
            return $next();
        }
        // 写入日志
        (new OperationLogService())->store($user['id']);
//        if(!in_array($url,['auth/index/refresh','auth/index/logout'])){
//            if($user['id'] != 1 && $id = AuthRuleModel::where(['href'=>$url])->value('id')){
//                $rules = AuthGroupModel::where(['id'=>$user['group_id']])->value('rules');
//                if(!in_array($id,explode('|',$rules))){
//                    throw new ApiException(['code'=>6781,'msg'=>'您没有权限！']);
//                }
//            }
//        }
        return $next($request);
    }
}
```

注册中间件

在 App\Http\Kernel 类中

```php
protected $routeMiddleware = [
        'AdminApiAuth'=> \Modules\Admin\Http\Middleware\AdminApiAuth::class,
        'BlogApiAuth'=> \Modules\BlogApi\Http\Middleware\BlogApiAuth::class,
        'HomeApiAuth'=> \Modules\Home\Http\Middleware\HomeApiAuth::class
    ];
```



### 控制器

#### 控制器基类

`Modules\Admin\Http\Controllers\v1\BaseApiController.php`

```php
<?php
/**
 * @name 当前模块控制器基类
 * @Auther 8963
 * @Date 2022/9/11 16:10
 * @Description
 */

namespace Modules\Admin\Http\Controllers\v1;


use Modules\Common\Controllers\BaseController;

class BaseApiController extends BaseController
{
    public function __construct(){
        parent::__construct();
    }
}
```

公共库 - 控制器基类

`Modules\Common\Controllers\BaseController.php`

```php
<?php

/**
 * @Name 控制器基类
 * @Description
 */

namespace Modules\Common\Controllers;
use Illuminate\Routing\Controller;

class BaseController extends Controller
{
    public function __construct(){

    }
}
```



#### 验证器

`Modules\Admin\Http\Requests\LoginRequest.php`

```php
<?php
/**
 * @name
 * @Auther 8963
 * @Date 2022/9/11 16:22
 * @Description
 */

namespace Modules\Admin\Http\Requests;


use Illuminate\Foundation\Http\FormRequest;

class LoginRequest extends FormRequest
{
    /**
     * php artisan module:make-request LoginRequest AuthAdmin
     */


    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }
    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'username' => 'required',
            'password'  => 'required'
        ];
    }
    public function messages(){
        return [
            'username.required' => '请输入账号！',
            'password.required' => '请输入密码！',
        ];
    }

}
```



#### Service

##### LoginService

`Modules\Admin\Services\auth\LoginService.php`

```php
<?php
/**
 * @name
 * @Auther 8963
 * @Date 2022/9/11 16:33
 * @Description
 */

namespace Modules\Admin\Services\auth;


use Modules\Admin\Services\BaseApiService;
use Modules\Admin\Models\AuthAdmin as AuthAdminModel;
class LoginService extends BaseApiService
{
    /**
     * @name 用户登录
     * @description
     * @param data  Array 用户信息
     * @param data.username String 账号
     * @param data.password String 密码
     * @return JSON
     **/
    public function login(array $data){
        if (true == \Auth::guard('auth_admin')->attempt($data)) {
            $userInfo = AuthAdminModel::where(['username'=>$data['username']])->select('id','username')->first();
            if($userInfo){
                $user_info = $userInfo->toArray();
                $user_info['password'] = $data['password'];
                $token = (new TokenService())->setToken($user_info);
                return $this->apiSuccess('登录成功！',$token);
            }
        }
        $this->apiError('账号或密码错误！');
    }
}
```

##### TokenService

`Modules\Admin\Services\auth\TokenService.php`

```php
<?php
/**
 * @name
 * @Auther 8963
 * @Date 2022/9/11 16:39
 * @Description
 */

namespace Modules\Admin\Services\auth;


use Modules\Admin\Services\BaseApiService;
use Modules\Common\Exceptions\ApiException;
use Modules\Common\Exceptions\MessageData;
use Modules\Common\Exceptions\StatusData;
use Tymon\JWTAuth\Exceptions\TokenBlacklistedException;
use Tymon\JWTAuth\Facades\JWTAuth;

class TokenService extends BaseApiService
{
    /**
     * @name 设置token 生成机制
     * @description
     * @return JSON
     **/
    public function __construct()
    {
        \Config::set('auth.defaults.guard', 'auth_admin');
        \Config::set('jwt.ttl', 60);
    }
    /**
     * @name 设置token
     * @description
     * @param data  Array 用户信息
     * @param data.username String 账号
     * @param data.password String 密码$
     * @return JSON | Array
     **/
    public function setToken($data){
        if (! $token = JWTAuth::attempt($data)){
            $this->apiError('token生成失败');
        }
        return $this->respondWithToken($token);
    }
    /**
     * @name 刷新token
     * @description
     * @return JSON
     **/
    public function refreshToken()
    {
        try {
            $oldToken = JWTAuth::getToken();
            $token = JWTAuth::refresh($oldToken);
        }catch (TokenBlacklistedException $e) {
            // 这个时候是老的token被拉到黑名单了
            throw new ApiException(['status'=>StatusData::TOKEN_ERROR_BLACK,'message'=>MessageData::TOKEN_ERROR_BLACK]);
        }
        return $this->apiSuccess('', $this->respondWithToken($token));
    }
    /**
     * @name 管理员信息
     * @description
     * @return Array
     **/
    public function my():Object
    {
        return JWTAuth::parseToken()->touser();
    }
    /**
     * @name
     * @description
     * @method  GET
     * @param
     * @return JSON
     **/
    public function info()
    {
        $data = $this->my();
        return $this->apiSuccess('',['username'=>$data['username']]);
    }
    /**
     * @name 退出登录
     * @description
     * @return JSON
     **/
    public function logout()
    {
        JWTAuth::parseToken()->invalidate();
        return $this->apiSuccess('退出成功！');
    }

    /**
     * @name 组合token数据
     * @description
     * @return Array
     **/
    protected function respondWithToken($token):Array
    {
        return [
            'token' => $token,
            'token_type' => 'bearer',
            'expires_in' => JWTAuth::factory()->getTTL() * 60
        ];
    }
}
```

##### BaseApiService

`Modules\Admin\Services\BaseApiService.php`

```php
<?php
/**
 * @name 当前模块服务基类
 * @Auther 8963
 * @Date 2022/9/11 16:24
 * @Description
 */

namespace Modules\Admin\Services;


use Modules\Common\Services\BaseService;

class BaseApiService extends BaseService
{

}
```

`Modules\Common\Services\BaseService.php`

```php
<?php
/**
 * @Name  服务基类
 * @Description
 */

namespace Modules\Common\Services;


use Modules\Common\Exceptions\ApiException;
use Modules\Common\Exceptions\CodeData;
use Modules\Common\Exceptions\MessageData;
use Modules\Common\Exceptions\StatusData;

class BaseService
{
    public function __construct()
    {
    }

    /**
     * @name 查询条件
     * @description
     * @method  GET
     * @param model Model 模型
     * @param params Array 查询参数
     * @param key String 模糊查询参数
     * @return Object
     **/
    function queryCondition(object $model,array $params,string $key="username"):Object
    {
        if (!empty($params['created_at'])){
            $model = $model->whereBetween('created_at',$params['created_at']);
        }
        if (!empty($params['updated_at'])){
            $model = $model->whereBetween('updated_at',$params['updated_at']);
        }
        if (!empty($params[$key])){
            $model = $model->where($key,'like','%' . $params[$key] . '%');
        }
        if (isset($params['status']) && $params['status'] != ''){
            $model = $model->where('status',$params['status']);
        }
        return $model;
    }
    /**
     * @name  成功返回
     * @description  用于所有的接口返回
     * @param status Int 自定义状态码
     * @param message String 提示信息
     * @param data Array 返回信息
     * @return JSON
     **/
    public function apiSuccess(string $message = '',array $data = array(),int $status = StatusData::Ok){
        if($message == ''){
            $message = MessageData::Ok;
        }
        return response()->json([
            'status' => $status,
            'message'=> $message,
            'data'=>$data
        ],CodeData::OK);
    }

    /**
     * @name 失败返回
     * @description 用于所有的接口返回
     * @param status Int 自定义状态码
     * @param message String 提示信息
     * @return JSON
     **/
    public function apiError(string $message = MessageData::API_ERROR_EXCEPTION,int $status = StatusData::BAD_REQUEST){
        throw new ApiException([
            'status' => $status,
            'message'=> $message
        ]);
    }
    /**
     * @name 添加公共方法
     * @description
     * @param model Model  当前模型
     * @param data array 添加数据
     * @param successMessage string 成功返回数据
     * @param errorMessage string 失败返回数据
     * @return JSON
     **/
    public function commonCreate($model,array $data = [],string $successMessage = MessageData::ADD_API_SUCCESS,string $errorMessage = MessageData::ADD_API_ERROR){
        $data['created_at'] = date('Y-m-d H:i:s');
        if ($model->insert($data)){
            return $this->apiSuccess($successMessage);
        }
        $this->apiError($errorMessage);
    }
    /**
     * @name 编辑公共方法
     * @description
     * @param model Model  当前模型
     * @param id   Int  修改id
     * @param data array 添加数据
     * @param successMessage string 成功返回数据
     * @param errorMessage string 失败返回数据
     * @return JSON
     **/
    public function commonUpdate($model,$id,array $data = [],string $successMessage = MessageData::UPDATE_API_SUCCESS,string $errorMessage = MessageData::UPDATE_API_ERROR){
        $data['updated_at'] = date('Y-m-d H:i:s');
        if ($model->where('id',$id)->update($data)){
            return $this->apiSuccess($successMessage);
        }
        $this->apiError($errorMessage);
    }
    /**
     * @name 调整公共方法
     * @description
     * @param model Model  当前模型
     * @param id   Int  修改id
     * @param data array 添加数据
     * @param successMessage string 成功返回数据
     * @param errorMessage string 失败返回数据
     * @return JSON
     **/
    public function commonStatusUpdate($model,$id,array $data = [],string $successMessage = MessageData::STATUS_API_SUCCESS,string $errorMessage = MessageData::STATUS_API_ERROR){
        if ($model->where('id',$id)->update($data)){
            return $this->apiSuccess($successMessage);
        }
        $this->apiError($errorMessage);
    }
    /**
     * @name 排序公共方法
     * @description
     * @param model Model  当前模型
     * @param id   Int  修改id
     * @param data array 添加数据
     * @param successMessage string 成功返回数据
     * @param errorMessage string 失败返回数据
     * @return JSON
     **/
    public function commonSortsUpdate($model,$id,array $data = [],string $successMessage = MessageData::STATUS_API_SUCCESS,string $errorMessage = MessageData::STATUS_API_ERROR){
        if ($model->where('id',$id)->update($data) !== false){
            return $this->apiSuccess($successMessage);
        }
        $this->apiError($errorMessage);
    }
    /**
     * @name 真删除公共方法
     * @description
     * @param model Model  当前模型
     * @param ArrId Array  删除id
     * @param successMessage string 成功返回数据
     * @param errorMessage string 失败返回数据
     * @return JSON
     **/
    public function commonDestroy($model,array $ArrId,string $successMessage = MessageData::DELETE_API_SUCCESS,string $errorMessage = MessageData::DELETE_API_ERROR){
        if ($model->whereIn('id',$ArrId)->delete()){
            return $this->apiSuccess($successMessage);
        }
        $this->apiError($errorMessage);
    }
    /**
     * @name 假删除公共方法
     * @description
     * @param model Model  当前模型
     * @param idArr Array  删除id
     * @param successMessage string 成功返回数据
     * @param errorMessage string 失败返回数据
     * @return JSON
     **/
    public function commonIsDelete($model,array $idArr,string $successMessage = MessageData::DELETE_API_SUCCESS,string $errorMessage = MessageData::DELETE_API_ERROR){
        if ($model->whereIn('id',$idArr)->update(['is_delete'=>1,'deleted_at'=>date('Y-m-d H:i:s')])){
            return $this->apiSuccess($successMessage);
        }
        $this->apiError($errorMessage);
    }
    /**
     * @name 假删除恢复公共方法
     * @description
     * @param model Model  当前模型
     * @param idArr Array  删除id
     * @param successMessage string 成功返回数据
     * @param errorMessage string 失败返回数据
     * @return JSON
     **/
    public function commonRecycleIsDelete($model,array $idArr,string $successMessage = MessageData::DELETE_RECYCLE_API_SUCCESS,string $errorMessage = MessageData::DELETE_RECYCLE_API_ERROR){
        if ($model->whereIn('id',$idArr)->update(['is_delete'=>0])){
            return $this->apiSuccess($successMessage);
        }
        $this->apiError($errorMessage);
    }
    /**
     * @name 获取当前域名
     * @description
     * @return String
     **/
    public function getHttp():String
    {
        $http = ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')) ? 'https://' : 'http://';
        return $http.$_SERVER['HTTP_HOST'];
    }
    /**
     * @name 将编辑器的content的图片转换为相对路径
     * @description
     * @param content String 内容
     * @return string
     **/
    public function getRemvePicUrl(string $content = ''):String
    {
        $con = $this->getHttp();
        if ($content){
            //提取图片路径的src的正则表达式 并把结果存入$matches中
            preg_match_all("/<[img|IMG].*?src=[\'|\"](.*?(?:[\.gif|\.jpg|\.png]))[\'|\"].*?[\/]?>/",$content,$matches);
            $img = "";
            if(!empty($matches)) {
                //注意，上面的正则表达式说明src的值是放在数组的第三个中
                $img = $matches[1];
            }else {
                $img = "";
            }
            if (!empty($img)) {
                $patterns= array();
                $replacements = array();
                //$default = config('filesystems.disks.qiniu.domains.default');
                foreach($img as $imgItem){
                    //if (strpos($imgItem, $default) !== false) {
                    //    $final_imgUrl = $imgItem;
                   // } else {
                        $final_imgUrl = str_replace($con,"",$imgItem);
                    //}
                    $replacements[] = $final_imgUrl;
                    $img_new = "/".preg_replace("/\//i","\/",$imgItem)."/";
                    $patterns[] = $img_new;
                }
                //让数组按照key来排序
                ksort($patterns);
                ksort($replacements);
                //替换内容
                $content = preg_replace($patterns, $replacements, $content);
            }
        }
        return $content;
    }
    /**
     * @name 将编辑器的content的图片转换为绝对路径
     * @description
     * @param  content string 内容
     * @return String
     **/
    public function getReplacePicUrl(string $content = ''):String
    {
        $con = $this->getHttp();
        if ($content){
            //提取图片路径的src的正则表达式 并把结果存入$matches中
            preg_match_all("/<[img|IMG].*?src=[\'|\"](.*?(?:[\.gif|\.jpg|\.png]))[\'|\"].*?[\/]?>/",$content,$matches);
            $img = "";
            if(!empty($matches)) {
                //注意，上面的正则表达式说明src的值是放在数组的第三个中
                $img = $matches[1];
            }else {
                $img = "";
            }
            if (!empty($img)) {
                $patterns= array();
                $replacements = array();
                //$default = config('filesystems.disks.qiniu.domains.default');
                foreach($img as $imgItem){
                    //if (strpos($imgItem, $default) !== false) {
                    //    $final_imgUrl = $imgItem;
                    //} else {
                        $final_imgUrl = $con.$imgItem;
                    //}
                    $replacements[] = $final_imgUrl;
                    $img_new = "/".preg_replace("/\//i","\/",$imgItem)."/";
                    $patterns[] = $img_new;
                }
                //让数组按照key来排序
                ksort($patterns);
                ksort($replacements);
                //替换内容
                $content = preg_replace($patterns, $replacements, $content);
            }
        }
        return $content;
    }
    /**
     * @name 生成随机字符串
     * @description
     * @param length Int 生成字符串长度
     * @return String
     **/
    public function GetRandStr(int $length = 11):String
    {
        //字符组合
        $str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        $len = strlen($str)-1;
        $randstr = '';
        for ($i=0;$i<$length;$i++) {
            $num=mt_rand(0,$len);
            $randstr .= $str[$num];
        }
        return $randstr;
    }
    /**
     * @name  处理二维数组转为json字符串乱码问题
     * @description
     * @param data Array  需要转为json字符串的数组
     * @return String
     **/
    public function setJsonEncodes($data):String
    {
        $count = count($data);
        for($k=0;$k<$count;$k++){
            foreach($data[$k] as $key => $value){
                $data[$k][$key] = urlencode($value);
            }
        }
        return urldecode(json_encode($data));
    }

    /**
     * @name 传入时间戳,计算距离现在的时间
     * @description
     * @param theTime Int 时间戳
     * @return String
     **/
    public function format_time(int $theTime = 0):String
    {
        $nowTime = time();
        $dur = $nowTime - $theTime;
        if ($dur < 0) {
            return $theTime;
        } else {
            if ($dur < 60) {
                return $dur . '秒前';
            } else {
                if ($dur < 3600) {
                    return floor($dur / 60) . '分钟前';
                } else {
                    if ($dur < 86400) {
                        return floor($dur / 3600) . '小时前';
                    } else {//昨天
                        //获取今天凌晨的时间戳
                        $day = strtotime(date('Y-m-d', time()));
                        //获取昨天凌晨的时间戳
                        $pday = strtotime(date('Y-m-d', strtotime('-1 day')));
                        if ($theTime > $pday && $theTime < $day) {//是否昨天
                            return $t = '昨天 ' . date('H:i', $the_time);
                        } else {
                            if ($dur < 172800) {
                                return floor($dur / 86400) . '天前';
                            } else {
                                return date('Y-m-d H:i', $the_time);
                            }
                        }
                    }
                }
            }
        }
    }
    /**
     * @name 处理递归数据
     * @description
     * @param array Array  总数据
     * @param pid Int  父级id
     * @return Array
     **/
    public function tree(array $array,int $pid=0):Array
    {
        $tree = array();
        foreach ($array as $key => $value) {
            if ($value['pid'] == $pid) {
                $value['children'] = $this->tree($array, $value['id']);
                if (!$value['children']) {
                    unset($value['children']);
                }
                $tree[] = $value;
            }
        }
        return $tree;
    }
    /**
     * @name 获取用户真实 ip
     * @description
     * @return array|false|mixed|string
     **/
    public function getClientIp()
    {
        if (getenv('HTTP_CLIENT_IP')) {
            $ip = getenv('HTTP_CLIENT_IP');
        }
        if (getenv('HTTP_X_REAL_IP')) {
            $ip = getenv('HTTP_X_REAL_IP');
        } elseif (getenv('HTTP_X_FORWARDED_FOR')) {
            $ip = getenv('HTTP_X_FORWARDED_FOR');
            $ips = explode(',', $ip);
            $ip = $ips[0];
        } elseif (getenv('REMOTE_ADDR')) {
            $ip = getenv('REMOTE_ADDR');
        } else {
            $ip = '0.0.0.0';
        }
        if(!$ip){
            return '';
        }
        return $ip;
    }
    /**
     * @name PHP格式化字节大小
     * @description
     * @param size Int  字节数
     * @param delimiter string  数字和单位分隔符
     * @return String 格式化后的带单位的大小
     **/
    public function formatBytes(int $size,string $delimiter = ''):String
    {
        $units = array('B', 'KB', 'MB', 'GB', 'TB', 'PB');
        for ($i = 0; $size >= 1024 && $i < 5; $i++) $size /= 1024;
        return round($size, 2) . $delimiter . $units[$i];
    }
}
```



#### models

`Modules\Admin\Models\AuthAdmin.php`

```php
<?php
/**
 * @name
 * @Auther 8963
 * @Date 2022/9/11 16:34
 * @Description
 */

namespace Modules\Admin\Models;
use DateTimeInterface;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
class AuthAdmin extends Authenticatable implements JWTSubject
{
    use Notifiable;
    protected $guard = 'auth_admin';
    protected $hidden = [
        'password'
    ];
    /**
     * @name jwt标识
     * @description
     **/
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }
    /**
     * @name jwt自定义声明
     * @description
     **/
    public function getJWTCustomClaims()
    {
        return [];
    }
    /**
     * @name 更新时间为null时返回
     * @description
     **/
    public function getUpdatedAtAttribute($value)
    {
        return $value?$value:'';
    }
    /**
     * @name  关联权限组表   多对一
     * @description
     **/
    public function auth_groups()
    {
        return $this->belongsTo('Modules\Admin\Models\AuthGroup','group_id','id');
    }
    /**
     * @name  关联平台项目表   多对一
     * @description
     **/
    public function auth_projects()
    {
        return $this->belongsTo('Modules\Admin\Models\AuthProject','project_id','id');
    }
    /**
     * @name 时间格式传唤
     * @description
     **/
    protected function serializeDate(DateTimeInterface $date)
    {
        return $date->format('Y-m-d H:i:s');
    }
}
```



#### LoginController

`Modules\Admin\Http\Controllers\v1\LoginController.php`

```php
<?php
/**
 * @name
 * @Auther 8963
 * @Date 2022/9/11 16:08
 * @Description
 */

namespace Modules\Admin\Http\Controllers\v1;
use Modules\Admin\Http\Requests\LoginRequest;
use Modules\Admin\Services\auth\LoginService;

class LoginController extends BaseApiController
{
    /**
     * @name 用户登录
     * @description
     * @method  POST
     * @param username String 账号
     * @param password String 密码
     * @return JSON
     **/
    public function login(LoginRequest $request)
    {
        return (new LoginService())->login($request->only(['username','password']));
    }
}
```



## 请求

![image-20220912100925701](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202305151535406.png)