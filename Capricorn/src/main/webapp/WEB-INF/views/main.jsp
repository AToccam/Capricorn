<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>我的项目</title>
  <style>
    /* 简单的卡片样式，让你感觉稍微 "高大上" 一点 */
    .project-card {
      border: 1px solid #ddd;
      padding: 20px;
      margin: 10px;
      width: 200px;
      display: inline-block;
      border-radius: 8px;
      background-color: #f9f9f9;
      text-align: center;
      cursor: pointer;
      transition: 0.3s;
    }
    .project-card:hover {
      background-color: #eef;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
  </style>
</head>
<body>
<h1>${currentUser.username} 的项目列表</h1>
<hr/>

<c:forEach items="${projects}" var="p">
  <div class="project-card" onclick="location.href='${pageContext.request.contextPath}/board?projectId=${p.projectId}&projectName=${p.projectName}'">
    <h3>${p.projectName}</h3>
    <p>点击进入看板</p>
  </div>
</c:forEach>

<c:if test="${empty projects}">
  <p>你还没有创建任何项目。</p>
</c:if>
</body>
</html>