<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>注册 - 任务看板</title>
</head>
<body>
<h2>用户注册</h2>
<p style="color: red;">${errorMsg}</p>

<form action="${pageContext.request.contextPath}/register" method="post">
    用户名：<input type="text" name="username"><br><br>
    密　码：<input type="password" name="password"><br><br>
    <input type="submit" value="注册">
</form>
</body>
</html>