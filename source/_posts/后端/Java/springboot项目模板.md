---
title: Springboot项目
date: 2023-01-18 12:52:39
comments: false
author: 8963
tags:
  - Java
  - SpringBoot
categories:
  - 后端
---


springboot项目模板

<!-- more -->

# 创建项目

![image-20221116104212647](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202303171306433.png)

![image-20221116104353934](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202303171306049.png)

![image-20221116104424473](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202303171306036.png)

选择项目位置，完成

# 跨域

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class CorsConfig {
    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        //允许所有域名进行跨域调用
        config.addAllowedOriginPattern("*");//替换这个
        //允许跨越发送cookie
        config.setAllowCredentials(true);
        //放行全部原始头信息
        config.addAllowedHeader("*");
        //允许所有请求方法跨域调用
        config.addAllowedMethod("*");
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);

    }
}
```



# mybatis-plu

## 分页插件

```java
import org.springframework.context.annotation.Bean;
import com.baomidou.mybatisplus.extension.plugins.PaginationInterceptor;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MybatisPlusConfig {
    /**
     * mybatis-plus.分页插件
     * @return
     */
    @Bean
    public PaginationInterceptor paginationInterceptor() {
        return new PaginationInterceptor();
    }
}

```

## 自动填充时间

```java
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Slf4j
@Primary
@Component
public class MyMetaObjectHandler implements MetaObjectHandler {
    /**
     * 插入元对象字段填充（用于插入时对公共字段的填充）
     *
     * @param metaObject 元对象
     */
    @Override
    public void insertFill(MetaObject metaObject) {
        this.setFieldValByName("createAt", LocalDateTime.now(), metaObject);
        this.setFieldValByName("updateAt", LocalDateTime.now(), metaObject);
    }

    /**
     * 更新元对象字段填充（用于更新时对公共字段的填充）
     *
     * @param metaObject 元对象
     */
    @Override
    public void updateFill(MetaObject metaObject) {
        this.setFieldValByName("updateTime", LocalDateTime.now(), metaObject);
    }
}
```

在实体中配置

```java
import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import com.baomidou.mybatisplus.annotation.TableId;
import java.time.LocalDateTime;
import com.baomidou.mybatisplus.annotation.TableField;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * <p>
 * 用户表
 * </p>
 *
 * @author chq
 * @since 2022-11-17
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Accessors(chain = true)
public class SysUser extends Model {

    private static final long serialVersionUID = 1L;

    /**
     * 主键
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 用户名
     */
    private String username;

    /**
     * 密码
     */
    private String password;

    /**
     * 创建时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @TableField(value = "createdAt", fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /**
     * 更新时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @TableField(value = "updatedAt", fill = FieldFill.UPDATE)
    private LocalDateTime updatedAt;
}
```



# jwt

安装依赖

```xml
<dependency>
	<groupId>com.auth0</groupId>
	<artifactId>java-jwt</artifactId>
	<version>3.8.3</version>
</dependency>
```

拦截器

```java
import java.lang.annotation.*;

@Documented
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface PassToken {
    boolean value() default true;
}
```



```java
import com.alibaba.fastjson.JSON;
import com.auth0.jwt.exceptions.AlgorithmMismatchException;
import com.auth0.jwt.exceptions.InvalidClaimException;
import com.auth0.jwt.exceptions.SignatureVerificationException;
import com.auth0.jwt.exceptions.TokenExpiredException;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;

/**
 * 添加拦截器
 */
@Component
public class TokenInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
//        System.out.println("preHandle");
        //如果不是映射到方法直接放行
        if(!(handler instanceof HandlerMethod)){
            return true;
        }
        HandlerMethod handlerMethod = (HandlerMethod)handler;
        Method method = handlerMethod.getMethod();
        if (method.isAnnotationPresent(PassToken.class)) { //方法上面是否有注解？
            PassToken passToken = method.getAnnotation(PassToken.class);
            if (passToken.value()){
                return true;
            }else {
                String token = request.getHeader("Authorization");
                Response res;
                try {
                    JWTUtils.verifyToken(token);
                    return true;
                }catch (SignatureVerificationException e){
                    e.printStackTrace();
                    res = Response.errorAuth("签名不一致");
                }catch (TokenExpiredException e){
                    e.printStackTrace();
                    res = Response.errorAuth("令牌过期异常");
                }catch (AlgorithmMismatchException e) {
                    e.printStackTrace();
                    res = Response.errorAuth("算法不匹配异常");
                }catch (InvalidClaimException e){
                    e.printStackTrace();
                    res = Response.errorAuth("失效的claim异常");
                }catch (Exception e){
                    e.printStackTrace();
                    res = Response.errorAuth("token无效");
                }
                String resultJson = JSON.toJSONString(res);
                response.setContentType("application/json;charset=utf-8");
                response.getWriter().print(resultJson);
                return false;
            }
        }
        Response res;
        String token = request.getHeader("Authorization");
        try {
            JWTUtils.verifyToken(token);
            return true;
        }catch (SignatureVerificationException e){
            e.printStackTrace();
            res = Response.errorAuth("签名不一致");
        }catch (TokenExpiredException e){
            e.printStackTrace();
            res = Response.errorAuth("令牌过期异常");
        }catch (AlgorithmMismatchException e) {
            e.printStackTrace();
            res = Response.errorAuth("算法不匹配异常");
        }catch (InvalidClaimException e){
            e.printStackTrace();
            res = Response.errorAuth("失效的claim异常");
        }catch (Exception e){
            e.printStackTrace();
            res = Response.errorAuth("token无效");
        }
        String resultJson = JSON.toJSONString(res);
        response.setContentType("application/json;charset=utf-8");
        response.getWriter().print(resultJson);
        return false;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
                           ModelAndView modelAndView) throws Exception {
//        System.out.println("postHandle");
        HandlerInterceptor.super.postHandle(request, response, handler, modelAndView);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) throws Exception {
//        System.out.println("afterCompletion");
        HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
    }
}

```

配置拦截

```java
import com.chq.club.common.TokenInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


//配置拦截事件
@Configuration
public class TokenWebMvcConfigurer implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new TokenInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns("/user/login");
    }
}

```



# 参数效验

安装依赖

```xml
<dependency>
    <groupId>org.hibernate.validator</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>6.0.20.Final</version>
</dependency>
```

## 单个类参数校验

定义要校验参数的实体类，在属性前添加注解

```java
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableField;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotBlank;

@Data
@EqualsAndHashCode(callSuper = true)
@Accessors(chain = true)
public class SysUser extends Model {

    private static final long serialVersionUID = 1L;

    /**
     * 主键
     */
    @ApiModelProperty(value = "id")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 用户名
     */
    @ApiModelProperty(value = "用户名")
    @NotBlank(message = "用户名不能为空")
    private String username;

    /**
     * 密码
     */
    @ApiModelProperty(value = "密码")
    @NotBlank(message = "密码不能为空")
    private String password;
}
```

在控制器中添加效验注解`@Validated`

```java
@ApiOperation(value = "添加",  notes = "添加")
@PostMapping("/add")
public ResultInfo add(@Validated SysUser entity){
	iSysUserService.add(entity);
	return ResultInfo.ok("添加成功");
}
```

内置校验注解：

```
@AssertFalse	必须是false
@AssertTrue	必须是true
@DecimalMax	小于等于给定的值
@DecimalMin	大于等于给定的值
@Digits	可设定最大整数位数和最大小数位数
@Email	校验是否符合Email格式
@Future	必须是将来的时间
@FutureOrPresent	当前或将来时间
@Max	最大值
@Min	最小值
@Negative	负数（不包括0）
@NegativeOrZero	负数或0
@NotBlank	不为null并且包含至少一个非空白字符
@NotEmpty	不为null并且不为空
@NotNull	不为null
@Null	为null
@Past	必须是过去的时间
@PastOrPresent	必须是过去的时间，包含现在
@PositiveOrZero	正数或0
@Size	校验容器的元素个数
```



## 对单个参数进行校验

在控制器中

```java
@ApiOperation(value = "登录",  notes = "用户登录")
@PostMapping("/login")
public ResultInfo login(@RequestParam (value = "username") @NotBlank(message = "用户名不能为空") String username,@RequestParam (value = "password")  @NotBlank(message = "密码不能为空") String password)  throws SystemException {
	JSONObject res = iSysUserService.login(username,password);
	if(res.isEmpty()){
			return ResultInfo.error("密码错误");
		}else{
    	return ResultInfo.ok("登录成功",res);
		}
}
```

# 全局异常处理

定义抛出异常类

```java
public interface BaseError {

    /**
     * 获取错误码
     * @return
     */
    int getErrorCode();

    /**
     * 获取错误信息
     * @return
     */
    String getErrorMsg();


    /**
     * 设置错误信息
     * @param message
     * @return
     */
    BaseError setErrorMsg(String message);
}


```

```java
public enum SystemCodeEnum  implements BaseError {
    PARAMETER_ERROR(50000,"参数不合法"),
    TOKEN_ERROR(50001,"用户未认证")
            ;

    /** 错误码 */
    private int errorCode;

    /** 错误描述 */
    private String errorMsg;

    SystemCodeEnum(int errorCode, String errorMsg) {
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
    }

    @Override
    public int getErrorCode() {
        return this.errorCode;
    }

    @Override
    public String getErrorMsg() {
        return this.errorMsg;
    }

    @Override
    public BaseError setErrorMsg(String errorMsg) {
        this.errorMsg=errorMsg;
        return this;
    }
}
```

```java
public class SystemException extends Exception implements BaseError{
    //所有实现了BaseError的ErrorEnum.
    private BaseError baseError;

    //直接构造错误消息的构造异常
    public SystemException(BaseError baseError){
        super(baseError.getErrorMsg());
        this.baseError=baseError;
    }

    //自定义错误消息的构造异常
    public SystemException(BaseError baseError,String customErrorMessage){
        super(customErrorMessage);
        this.baseError=baseError;
        this.baseError.setErrorMsg(customErrorMessage);
    }

    @Override
    public int getErrorCode() {
        return this.baseError.getErrorCode();
    }

    @Override
    public String getErrorMsg() {
        return this.baseError.getErrorMsg();
    }

    @Override
    public BaseError setErrorMsg(String message) {
        this.baseError.setErrorMsg(message);
        return this;
    }
}
```

全局异常处理

```java
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;



@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);
    private static final String BAD_REQUEST_MSG = "参数检验不通过";

    //  处理单个参数校验失败抛出的异常
    @ExceptionHandler(ConstraintViolationException.class)
    public ResultInfo constraintViolationExceptionHandler(ConstraintViolationException e) {
        Set<ConstraintViolation<?>> constraintViolations = e.getConstraintViolations();
        List<String> collect = constraintViolations.stream().map(o -> o.getMessage()).collect(Collectors.toList());
        return new ResultInfo().info(HttpStatus.BAD_REQUEST.value(), BAD_REQUEST_MSG, collect);
    }

    //处理 form data方式调用接口校验失败抛出的异常
    @ExceptionHandler(BindException.class)
    public ResultInfo bindExceptionHandler(BindException e) {
        List<FieldError> fieldErrors = e.getBindingResult().getFieldErrors();
        List<String> collect = fieldErrors.stream().map(o -> o.getDefaultMessage()).collect(Collectors.toList());
        return new ResultInfo().info(HttpStatus.BAD_REQUEST.value(), BAD_REQUEST_MSG, collect);
    }

    //  处理 json 请求体调用接口校验失败抛出的异常
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResultInfo methodArgumentNotValidExceptionHandler(MethodArgumentNotValidException e) {
        List<FieldError> fieldErrors = e.getBindingResult().getFieldErrors();
        List<String> collect = fieldErrors.stream().map(o -> o.getDefaultMessage()).collect(Collectors.toList());
        return new ResultInfo().info(HttpStatus.BAD_REQUEST.value(), BAD_REQUEST_MSG, collect);
    }

    // 处理以上处理不了的其他异常
    @ExceptionHandler(Exception.class)
    public ResultInfo exceptionHandler(Exception e) {
        return new ResultInfo().info(HttpStatus.BAD_REQUEST.value(), BAD_REQUEST_MSG, e.getMessage());
    }
}

```

使用举例`UserServiceImpl`

```java
@Override
public JSONObject login(String username, String password)  throws SystemException {
	// 查询用户
	SysUser u = findUserByName(username);
	if(u != null){
    // 用户存在操作
	}else {
		throw new SystemException(SystemCodeEnum.PARAMETER_ERROR,"用户不存在");
	}
}
```

返回

![image-20221119001421447](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202303171305784.png)

# 通用返回



```java
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResultInfo<T> {
    private Integer code;
    private String msg;
    private T data;

    public ResultInfo(Integer code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public static <E>ResultInfo<E> info(Integer code,String msg,E t){
        return new ResultInfo(code,msg,t);
    }

    public static <E>ResultInfo<E> ok(String msg){
        return new ResultInfo(1,msg);
    }
    public static <E>ResultInfo<E> ok(String msg,E t){
        return new ResultInfo(1,msg,t);
    }
    public static <E>ResultInfo<E> error(String msg){
        return new ResultInfo(0,msg);
    }
}
```

