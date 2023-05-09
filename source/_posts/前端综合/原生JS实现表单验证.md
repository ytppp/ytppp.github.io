---
title: 原生JS实现表单验证
description: 这是系列文章《原生 JS 实现前端常见功能》的第 1 篇，讲述如何通过原生 JS 实现表单验证。
tags:
  - JavaScript
categories:
  - 前端综合
date: 2021-06-15 16:07:40
---

表单验证是 web 开发中的常见功能之一。为了更快地摸鱼，大佬们往往会用`vue`等框架提供的**双向数据绑定**功能结合`async-validator`等验证库来实现。但作为菜鸟的我，现状是：框架越用越熟练，对原生 JS 实现表单验证的方式却越来越模糊。所以今天索性通过**表单注册**这个小 demo 的开发，回味一下原汁原味的表单验证开发。

### 功能描述

当点击登录按钮时，验证：

1. 用户名、邮箱、密码、确认密码是否必填
2. 用户名、邮箱长度是否在限制内
3. 邮箱格式是否正确
4. 两次输入的密码是否一致

### html 和 css

1. html：

```html
<form id="form" class="form">
  <h2>注册</h2>
  <div class="form-control">
    <label for="username">用户名</label>
    <input type="text" id="username" placeholder="请输入用户名" />
    <small>错误信息</small>
  </div>
  <div class="form-control">
    <label for="email">邮箱</label>
    <input type="text" id="email" placeholder="请输入邮箱" />
    <small>错误信息</small>
  </div>
  <div class="form-control">
    <label for="password">密码</label>
    <input type="password" id="password" placeholder="请输入密码" />
    <small>错误信息</small>
  </div>
  <div class="form-control">
    <label for="password2">确认密码</label>
    <input type="password" id="password2" placeholder="请再次输入密码" />
    <small>错误信息</small>
  </div>
  <button type="submit">提交</button>
</form>
```

2. css：

```css
:root {
  --success-color: #2ecc71;
  --error-color: #e74c3c;
}

* {
  box-sizing: border-box;
}

body {
  background-color: #f9fafb;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  margin: 0;
}

.container {
  background-color: #fff;
  border-radius: 5px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  width: 400px;
}

h2 {
  text-align: center;
  margin: 0 0 20px;
}

.form {
  padding: 30px 40px;
}

.form-control {
  margin-bottom: 10px;
  padding-bottom: 20px;
  position: relative;
}

.form-control label {
  color: #777;
  display: block;
  margin-bottom: 5px;
}

.form-control input {
  border: 2px solid #f0f0f0;
  border-radius: 4px;
  display: block;
  width: 100%;
  padding: 10px;
  font-size: 14px;
}

.form-control input:focus {
  outline: 0;
  border-color: #777;
}

.form-control.success input {
  border-color: var(--success-color);
}

.form-control.error input {
  border-color: var(--error-color);
}

.form-control small {
  color: var(--error-color);
  position: absolute;
  bottom: 0;
  left: 0;
  visibility: hidden;
}

.form-control.error small {
  visibility: visible;
}

.form button {
  cursor: pointer;
  background-color: #3498db;
  border: 2px solid #3498db;
  border-radius: 4px;
  color: #fff;
  display: block;
  font-size: 16px;
  padding: 10px;
  margin-top: 20px;
  width: 100%;
}
```

html 和 css 都很简单，就不赘述了。重点说下如何用 JS 实现表单验证。

### 用 JS 实现表单验证与提交

#### 获取 dom 节点。

```javascript
const form = document.getElementById('form');
const username = document.getElementById('username');
const email = document.getElementById('email');
const password = document.getElementById('password');
const password2 = document.getElementById('password2');
```

#### 封装验证提示的公共方法

因为验证提示对于每一个要验证的表单项都会用到，所以这里封装成公用方法。

```javascript
// Show input error message
function showError(input, message) {
  const formControl = input.parentElement;
  formControl.className = 'form-control error';
  const small = formControl.querySelector('small');
  small.innerText = message;
}

// Show success outline
function showSuccess(input) {
  const formControl = input.parentElement;
  formControl.className = 'form-control success';
}
```

这里的实现方法是：

先获取当前表单项的父级节点，在其样式上加入验证是否通过的类样式（这里，通过加上`success`,不通过加上`error`），然后再找到与当前表单项同级的`<small>`标签，用来显示验证是否通过的提示信息。

#### 获取表单项的名字

主要在验证是否通过的提示文本使用，也是一个公用方法，所以先封装一下。

```javascript
// Get fieldname
function getFieldName(input) {
  const formControl = input.parentElement;
  const label = formControl.querySelector('label');
  return label.innerText;
}
```

#### 其他验证

接下来依次实现：邮箱格式验证、必填验证、长度验证、密码是否一致的验证。

1. 邮箱格式验证

```javascript
// Check email is valid
function checkEmail(input) {
  const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  if (re.test(input.value.trim())) {
    showSuccess(input);
  } else {
    showError(input, '邮箱不合法');
  }
}
```

2. 必填验证

```javascript
// Check required fields
function checkRequired(inputArr) {
  let isRequired = false;
  inputArr.forEach(function(input) {
    if (input.value.trim() === '') {
      showError(input, `${getFieldName(input)}必填`);
      isRequired = true;
    } else {
      showSuccess(input);
    }
  });

  return isRequired;
}
```

3. 长度验证

```javascript
// Check input length
function checkLength(input, min, max) {
  if (input.value.length < min) {
    showError(input, `${getFieldName(input)}至少 ${min} 个字符`);
  } else if (input.value.length > max) {
    showError(input, `${getFieldName(input)}至多 ${max} 个字符`);
  } else {
    showSuccess(input);
  }
}
```

4. 密码是否一致的验证

```javascript
// Check passwords match
function checkPasswordsMatch(input1, input2) {
  if (input1.value !== input2.value) {
    showError(input2, '密码不匹配');
  }
}
```

#### 提交

```javascript
form.addEventListener('submit', function(e) {
  e.preventDefault();

  if (!checkRequired([username, email, password, password2])) {
    checkLength(username, 3, 15);
    checkLength(password, 6, 25);
    checkEmail(email);
    checkPasswordsMatch(password, password2);
  }
});
```

### JS 部分整体代码

```javascript
const form = document.getElementById('form');
const username = document.getElementById('username');
const email = document.getElementById('email');
const password = document.getElementById('password');
const password2 = document.getElementById('password2');

// Show input error message
function showError(input, message) {
  const formControl = input.parentElement;
  formControl.className = 'form-control error';
  const small = formControl.querySelector('small');
  small.innerText = message;
}

// Show success outline
function showSuccess(input) {
  const formControl = input.parentElement;
  formControl.className = 'form-control success';
}

// Check email is valid
function checkEmail(input) {
  const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  if (re.test(input.value.trim())) {
    showSuccess(input);
  } else {
    showError(input, '邮箱不合法');
  }
}

// Check required fields
function checkRequired(inputArr) {
  let isRequired = false;
  inputArr.forEach(function(input) {
    if (input.value.trim() === '') {
      showError(input, `${getFieldName(input)}必填`);
      isRequired = true;
    } else {
      showSuccess(input);
    }
  });

  return isRequired;
}

// Check input length
function checkLength(input, min, max) {
  if (input.value.length < min) {
    showError(input, `${getFieldName(input)}至少 ${min} 个字符`);
  } else if (input.value.length > max) {
    showError(input, `${getFieldName(input)}至多 ${max} 个字符`);
  } else {
    showSuccess(input);
  }
}

// Check passwords match
function checkPasswordsMatch(input1, input2) {
  if (input1.value !== input2.value) {
    showError(input2, '密码不匹配');
  }
}

// Get fieldname
function getFieldName(input) {
  const formControl = input.parentElement;
  const label = formControl.querySelector('label');
  return label.innerText;
}

// Event listeners
form.addEventListener('submit', function(e) {
  e.preventDefault();

  if (!checkRequired([username, email, password, password2])) {
    checkLength(username, 3, 15);
    checkLength(password, 6, 25);
    checkEmail(email);
    checkPasswordsMatch(password, password2);
  }
});
```

以上就是原生 JS 实现表单验证的全部功能，感兴趣的大佬可以在这个小小 demo 上再进行扩展，相信一定会有更多的收获哦。

> 最后，这个系列项目的 github 地址：[native-web-projects](https://github.com/ytppp/native-web-projects)，欢迎大家 star。我的个人网站：[yangtp.com](https://www.yangtp.com/)，欢迎大家空闲时候来串串门呀。

