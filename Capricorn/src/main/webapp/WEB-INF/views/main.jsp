<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>我的看板列表</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    /* --- 全局基础样式 --- */
    body {
      font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
      background-color: #0079bf;
      margin: 0;
      padding: 0;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      background-size: cover;
      background-position: center;
      background-attachment: fixed;
      transition: background-image 0.5s ease-in-out;
    }

    /* --- 标题区域 --- */
    .header-section {
      text-align: center;
      margin-top: 60px;
      margin-bottom: 40px;
      color: white;
      text-shadow: 0 2px 5px rgba(0,0,0,0.3);
    }
    .header-section h1 { font-size: 2.5rem; margin: 0; font-weight: 300; }
    .header-section p { font-size: 1.1rem; opacity: 0.9; margin-top: 10px; }

    /* --- 项目网格布局 --- */
    .projects-grid {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 30px;
      width: 85%;
      max-width: 1200px;
      padding-bottom: 50px;
    }

    /* --- 1. 普通项目卡片 (磨砂玻璃风格) --- */
    .project-card {
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(10px);
      width: 260px;
      height: 150px;
      border-radius: 12px;
      padding: 20px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
      transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      position: relative;
      text-decoration: none;
      color: #333;
      cursor: pointer;
      border: 1px solid rgba(255,255,255,0.5);
    }
    .project-card:hover {
      transform: translateY(-5px);
      background: #fff;
      box-shadow: 0 15px 30px rgba(0,0,0,0.2);
    }

    .project-title {
      font-size: 1.4rem;
      font-weight: bold;
      color: #172b4d;
      margin-bottom: 10px;
      /* 限制两行显示，超出省略 */
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .enter-text {
      font-size: 0.9rem;
      color: #5e6c84;
      align-self: flex-end;
      font-weight: 500;
    }

    /* 卡片右上角操作按钮 */
    .card-actions {
      position: absolute;
      top: 15px;
      right: 15px;
      opacity: 0; /* 默认隐藏 */
      transition: opacity 0.2s;
      background: rgba(255,255,255,0.8);
      padding: 2px 5px;
      border-radius: 4px;
    }
    .project-card:hover .card-actions { opacity: 1; } /* 悬浮显示 */

    .action-btn { margin-left: 8px; color: #6b778c; font-size: 16px; transition: color 0.2s; }
    .action-btn:hover { color: #0079bf; }
    .action-btn.delete:hover { color: #c00; }

    /* --- 2. 新建看板卡片 (虚线框) --- */
    .create-card {
      width: 260px;
      height: 150px;
      border-radius: 12px;
      padding: 20px;
      background: rgba(255, 255, 255, 0.15);
      border: 2px dashed rgba(255, 255, 255, 0.6);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s;
      color: white;
      box-sizing: content-box; /* 保持大小一致 */
    }
    .create-card:hover {
      background: rgba(255, 255, 255, 0.3);
      border-color: #fff;
      transform: scale(1.02);
    }
    .create-icon { font-size: 40px; margin-bottom: 10px; line-height: 1; }
    .create-text { font-size: 1.2rem; font-weight: bold; }

    /* --- 侧边栏 & 皮肤按钮 --- */
    .skin-toggle-btn {
      position: fixed; top: 20px; right: 20px; width: 40px; height: 40px;
      background: rgba(255,255,255,0.25); border-radius: 50%;
      display: flex; justify-content: center; align-items: center;
      padding-bottom: 3px; box-sizing: border-box; font-size: 22px;
      cursor: pointer; z-index: 2000; color: white;
      border: 1px solid rgba(255,255,255,0.4);
      backdrop-filter: blur(5px);
      transition: background 0.3s;
    }
    .skin-toggle-btn:hover { background: rgba(255,255,255,0.5); }

    .skin-drawer {
      position: fixed; top: 0; right: -280px; width: 260px; height: 100%;
      background: #f4f5f7; z-index: 1999; transition: right 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      padding: 70px 20px; box-sizing: border-box; box-shadow: -5px 0 15px rgba(0,0,0,0.1);
    }
    .skin-drawer.open { right: 0; }
    .bg-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
    .bg-item {
      width: 100%; height: 70px; border-radius: 6px; cursor: pointer;
      background-size: cover; background-position: center;
      border: 2px solid transparent; transition: transform 0.2s;
    }
    .bg-item:hover { border-color: #0079bf; transform: scale(1.05); }

  </style>
</head>
<body>

<div class="skin-toggle-btn" id="skin-btn" title="更换主题">👕</div>

<div class="header-section">
  <h1>欢迎回来，${currentUser.username}</h1>
  <p>选择一个看板开始工作，或者创建一个新的</p>
</div>

<div class="projects-grid" id="projectsGrid">

  <c:forEach items="${projects}" var="p">
    <div class="project-card" id="project-card-${p.projectId}" onclick="location.href='${pageContext.request.contextPath}/board?projectId=${p.projectId}&projectName=${p.projectName}'">

      <div class="project-title" id="title-${p.projectId}">${p.projectName}</div>

      <div class="card-actions" onclick="event.stopPropagation();">
        <span class="action-btn" onclick="renameProject(event, ${p.projectId})" title="重命名">✏️</span>
        <span class="action-btn delete" onclick="deleteProject(event, ${p.projectId})" title="删除看板">🗑️</span>
      </div>

      <span class="enter-text">点击进入 &rarr;</span>
    </div>
  </c:forEach>

  <div class="create-card" id="createCardBtn" onclick="createNewProject()">
    <div class="create-icon">+</div>
    <div class="create-text">新建看板</div>
  </div>
</div>

<div class="skin-drawer" id="skin-drawer">
  <h3 style="margin-top:0; border-bottom:1px solid #ddd; padding-bottom:10px;">背景风格</h3>
  <p style="font-size:12px; color:#666;">点击图片切换背景</p>
  <div class="bg-grid">
    <div class="bg-item" style="background-image: url('${pageContext.request.contextPath}/images/bg1.jpg');" data-img="${pageContext.request.contextPath}/images/bg1.jpg"></div>
    <div class="bg-item" style="background-image: url('${pageContext.request.contextPath}/images/bg2.jpg');" data-img="${pageContext.request.contextPath}/images/bg2.jpg"></div>
    <div class="bg-item" style="background-image: url('${pageContext.request.contextPath}/images/bg3.jpg');" data-img="${pageContext.request.contextPath}/images/bg3.jpg"></div>
  </div>
</div>

<script>
  $(function() {
    // --- 1. 皮肤初始化逻辑 ---
    var bgVal = localStorage.getItem("bg_value");
    if(bgVal) $('body').css('background-image', 'url('+bgVal+')');

    $("#skin-btn").click(function(e){ e.stopPropagation(); $("#skin-drawer").toggleClass("open"); });
    $(document).click(function(){ $("#skin-drawer").removeClass("open"); });
    $(".skin-drawer").click(function(e){ e.stopPropagation(); });

    $(".bg-item").click(function(){
      var url = $(this).data("img");
      $('body').css('background-image', 'url('+url+')');
      localStorage.setItem("bg_type", "image");
      localStorage.setItem("bg_value", url);
    });
  });

  // ===========================
  //  2. 新建项目 (AJAX 无刷新)
  // ===========================
  function createNewProject() {
    var name = prompt("请输入新看板的名称：");
    if (!name || name.trim() === "") return;

    $.post("${pageContext.request.contextPath}/addProject", {
      projectName: name
    }, function(response) {
      // 这里需要 Controller 返回 JSON: { "status": "success", "newId": 123 }
      if (response.status === "success") {
        var newId = response.newId;
        var contextPath = "${pageContext.request.contextPath}";

        // 构造新卡片的 HTML
        var newCardHtml =
                '<div class="project-card" id="project-card-' + newId + '" onclick="location.href=\'' + contextPath + '/board?projectId=' + newId + '&projectName=' + name + '\'">' +
                '<div class="project-title" id="title-' + newId + '">' + name + '</div>' +
                '<div class="card-actions" onclick="event.stopPropagation();">' +
                '<span class="action-btn" onclick="renameProject(event, ' + newId + ')" title="重命名">✏️</span> ' +
                '<span class="action-btn delete" onclick="deleteProject(event, ' + newId + ')" title="删除看板">🗑️</span>' +
                '</div>' +
                '<span class="enter-text">点击进入 &rarr;</span>' +
                '</div>';

        // 插入到新建按钮之前，并加一个淡入动画
        $(newCardHtml).insertBefore("#createCardBtn").hide().fadeIn(500);

      } else {
        // 如果 Controller 没改对，可能 response 是 "success" 字符串，这里会失败
        alert("创建失败，请检查后端是否返回了正确的 JSON");
      }
    });
  }

  // ===========================
  //  3. 删除项目 (AJAX 无刷新)
  // ===========================
  function deleteProject(event, id) {
    if(event) event.stopPropagation();

    if (confirm("⚠️ 警告：确定要删除这个看板吗？\n里面的任务将无法恢复！")) {
      $.post("${pageContext.request.contextPath}/deleteProject", {
        projectId: id
      }, function(response) {
        if (response === "success") {
          // 动画移除元素
          $("#project-card-" + id).fadeOut(300, function() {
            $(this).remove();
          });
        } else {
          alert("删除失败");
        }
      });
    }
  }

  // ===========================
  //  4. 重命名项目 (AJAX 无刷新)
  // ===========================
  function renameProject(event, id) {
    if(event) event.stopPropagation();

    var $titleDiv = $("#title-" + id);
    var oldName = $titleDiv.text();

    var newName = prompt("重命名看板：", oldName);
    if (newName && newName.trim() !== "" && newName !== oldName) {
      $.post("${pageContext.request.contextPath}/renameProject", {
        projectId: id,
        projectName: newName
      }, function(response) {
        if (response === "success") {
          // 1. 更新标题文字
          $titleDiv.text(newName);
          // 2. 更新卡片点击跳转的 URL 参数 (为了严谨)
          var newUrl = "${pageContext.request.contextPath}/board?projectId=" + id + "&projectName=" + newName;
          $("#project-card-" + id).attr("onclick", "location.href='" + newUrl + "'");
        } else {
          alert("修改失败");
        }
      });
    }
  }
</script>
</body>
</html>