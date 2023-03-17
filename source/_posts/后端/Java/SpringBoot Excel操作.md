---
title: SpringBoot Excel操作
date: 2023-01-18 12:52:39
comments: false
author: 8963
tags:
  - Java
  - SpringBoot
categories:
  - 后端
---

# poi

依赖

```xml
<!-- excel -->
        <dependency>
            <groupId>org.xmlunit</groupId>
            <artifactId>xmlunit-core</artifactId>
        </dependency>
        <dependency>
            <groupId>org.apache.poi</groupId>
            <artifactId>poi</artifactId>
            <version>4.0.1</version>
        </dependency>
        <!--    poi对于excel 2007的支持依赖-->
        <dependency>
            <groupId>org.apache.poi</groupId>
            <artifactId>poi-ooxml</artifactId>
            <version>4.0.1</version>
        </dependency>
        <!--    poi对于excel 2007的支持依赖-->
        <dependency>
            <groupId>org.apache.poi</groupId>
            <artifactId>poi-ooxml-schemas</artifactId>
            <version>4.0.1</version>
        </dependency>
```

entity

```java
package com.example.health.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import com.baomidou.mybatisplus.annotation.TableId;

import java.time.LocalDate;
import java.time.LocalDateTime;
import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * <p>
 * 
 * </p>
 *
 * @author 8963
 * @since 2022-06-08
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class Student extends Model {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @TableField("createDate")
    private LocalDateTime createDate;

    private String name;

    @TableField("stuId")
    private String stuId;

    private LocalDate birthday;

    private String age;

    private String sex;

    private String national;

    private String address;

    private String school;

    private String grade;

    @TableField("className")
    private String className;

    private String guardian;

    private String guardianTelephone;

    private String check_status;

    public Student(){}

    public Student(Integer id, LocalDateTime createDate, String name, String stuId, LocalDate birthday, String age, String sex, String national, String address, String school, String grade, String className, String guardian, String guardianTelephone) {
        this.id = id;
        this.createDate = createDate;
        this.name = name;
        this.stuId = stuId;
        this.birthday = birthday;
        this.age = age;
        this.sex = sex;
        this.national = national;
        this.address = address;
        this.school = school;
        this.grade = grade;
        this.className = className;
        this.guardian = guardian;
        this.guardianTelephone = guardianTelephone;
    }
    public Student(LocalDateTime createDate, String name, String stuId, LocalDate birthday, String age, String sex, String national, String address, String school, String grade, String className, String guardian, String guardianTelephone,String check_status) {
        this.createDate = createDate;
        this.name = name;
        this.stuId = stuId;
        this.birthday = birthday;
        this.age = age;
        this.sex = sex;
        this.national = national;
        this.address = address;
        this.school = school;
        this.grade = grade;
        this.className = className;
        this.guardian = guardian;
        this.guardianTelephone = guardianTelephone;
        this.check_status = check_status;
    }

    public Student(Object[] args) {
        /** DecimalFormat 用法
         * https://www.jianshu.com/p/b3699d73142e
         * Integer.valueOf 返回的时包装类  Integer.parseInt() 返回的是int
         */
        //因为传进来的args 的赋值是从1开始的
        this.stuId = args[0].toString();
        this.name = args[1].toString();
        this.sex = args[2].toString();
        this.national = args[3].toString();
        this.school = args[4].toString();
        this.grade = args[5].toString();
        this.className = args[6].toString();
        this.birthday = LocalDate.parse(args[7].toString());
        this.age =  args[8].toString();
        this.address = args[9].toString();
        this.guardian = args[10].toString();
        this.guardianTelephone = args[11].toString();
    }
}
```

controller

```java
@ApiOperation("下载")
    @GetMapping("/studentDown")
    public void downExcel(@RequestParam("school") String school,HttpServletResponse response) throws IOException{
        HSSFWorkbook workbook = new HSSFWorkbook();//创建HSSFWorkbook对象,  excel的文档对象
        HSSFSheet sheet = workbook.createSheet("学生学籍表"); //excel的表单
        QueryWrapper<Student> wrapper = new QueryWrapper();
        if(school!=""&& school!=null){
            wrapper.eq("school",school);
        }
        List<Student> list = iStudentService.list(wrapper);
//        List<Student> list = iStudentService.list();
        String fileName = "StudentInfo.xls";
        System.out.println(fileName);
        int rowNum = 1;
        String[] headers = { "学号", "姓名","性别","民族", "学校", "年级","班级","生日","年龄","家庭地址","联系人","联系人电话"};
        //headers表示excel表中第一行的表头
        HSSFRow row = sheet.createRow(0);
        //在excel表中添加表头
        for(int i=0;i<headers.length;i++){
            HSSFCell cell = row.createCell(i);
            HSSFRichTextString text = new HSSFRichTextString(headers[i]);
            cell.setCellValue(text);
        }
        //在表中存放查询到的数据放入对应的列
        for (Student student : list) {
            HSSFRow row1 = sheet.createRow(rowNum);
            row1.createCell(0).setCellValue(student.getStuId());
            row1.createCell(1).setCellValue(student.getName());
            row1.createCell(2).setCellValue(student.getSex());
            row1.createCell(3).setCellValue(student.getNational());
            row1.createCell(4).setCellValue(student.getSchool());
            row1.createCell(5).setCellValue(student.getGrade());
            row1.createCell(6).setCellValue(student.getClassName());
            row1.createCell(7).setCellValue(String.valueOf(student.getBirthday()));
            row1.createCell(8).setCellValue(student.getAge());
            row1.createCell(9).setCellValue(student.getAddress());
            row1.createCell(10).setCellValue(student.getGuardian());
            row1.createCell(11).setCellValue(student.getGuardianTelephone());
            rowNum++;
        }
        response.setContentType("application/octet-stream;charset=utf-8");
        response.setHeader("Content-disposition", "attachment;filename=" + fileName);
        response.flushBuffer();
        workbook.write(response.getOutputStream());
    }

    @ApiOperation("导入")
    @PostMapping("/upload")
    public Response upload(@RequestParam(name = "file") MultipartFile file) throws IOException {
        Workbook wb = new HSSFWorkbook(file.getInputStream());
        Sheet sheet = wb.getSheetAt(0);
        List<Student> list = new ArrayList<>();
        System.out.println("最后一行的下标 :" + sheet.getLastRowNum());
        for (int rowNum = 1; rowNum <= sheet.getLastRowNum(); rowNum++) {
            Row row = sheet.getRow(rowNum);//根据索引获取每一个行
            Object[] values = new Object[row.getLastCellNum()];
            for (int cellNum = 0; cellNum < row.getLastCellNum(); cellNum++) {
                Cell cell = row.getCell(cellNum);
                Object value = getCellValue(cell);
                values[cellNum] = value;
            }
            Student stu = new Student(values);
            list.add(stu);
        }
        //3.批量保存用户
        for (Student item: list) {
            item.setCheck_status("0");
            item.setCreateDate(LocalDateTime.now());
            System.out.println(item.toString());
            if (iStudentService.save(item)){
                addStuUser(item);
            }
        }
        return Response.ok("导入成功");
    }

//    添加学生用户
    private void addStuUser(Student student){
        QueryWrapper<Student> wrapper = new QueryWrapper();
        String name = student.getName()+student.getStuId();
        String password = student.getStuId();
        String grade = student.getSchool()+student.getGrade()+student.getClassName();
        String unit = student.getSchool();
        User u = new User(name,password,"学生","student",grade,"3",LocalDateTime.now(),unit);
        if (iUserService.save(u)){
            System.out.println("添加成功");
        }else {
            System.out.println("添加失败");
        }
    }

    public static Object getCellValue(Cell cell) {
        //1.获取到单元格的属性类型
        CellType cellType = cell.getCellType();
        //2.根据单元格数据类型获取数据
        Object value = null;
        switch (cellType) {
            case STRING:
                value = cell.getStringCellValue();
                break;
            case BOOLEAN:
                value = cell.getBooleanCellValue();
                break;
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    //日期格式
                    value = cell.getDateCellValue();
                } else {
                    //数字
                    value = cell.getNumericCellValue();
                }
                break;
            case FORMULA: //公式
                value = cell.getCellFormula();
                break;
            default:
                break;
        }
        return value;
    }
```



