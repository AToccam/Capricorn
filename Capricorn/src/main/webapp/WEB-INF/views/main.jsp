<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>主页</title>
</head>
<body>
<h1>欢迎你, ${currentUser.username}!</h1>
<h3>这是我们的任务看板系统（开发中...）</h3>
<a href="${pageContext.request.contextPath}/logout">退出登录</a>
</body>
</html>