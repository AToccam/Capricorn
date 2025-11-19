<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录 - 任务看板</title>
</head>
<body>
<h2>用户登录</h2>
<p style="color: red;">${errorMsg}</p>
<p style="color: green;">${msg}</p>

<form action="${pageContext.request.contextPath}/login" method="post">
    用户名：<input type="text" name="username"><br><br>
    密　码：<input type="password" name="password"><br><br>
    <input type="submit" value="登录">
    <a href="${pageContext.request.contextPath}/register">去注册</a>
</form>
</body>
</html>