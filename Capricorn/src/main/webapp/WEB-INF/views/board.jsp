<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>看板 - ${currentProjectName}</title>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">

  <style>
    body { font-family: sans-serif; background-color: #0079bf; margin: 0; padding: 20px; }
    h2 { color: white; }

    .board-container {
      display: flex;
      align-items: flex-start;
      overflow-x: auto;
      height: 90vh;
    }

    .list-column {
      background-color: #ebecf0;
      width: 280px;
      min-width: 280px;
      margin-right: 15px;
      border-radius: 5px;
      padding: 10px;
      box-sizing: border-box;
      /* 关键：让列表成为一个 Flex 容器，方便卡片排序 */
      display: flex;
      flex-direction: column;
    }

    .list-header { font-weight: bold; margin-bottom: 10px; padding: 5px; cursor: default;}

    /* 卡片样式 */
    .card {
      background-color: white;
      padding: 10px;
      margin-bottom: 8px;
      border-radius: 3px;
      box-shadow: 0 1px 0 rgba(9,30,66,.25);
      cursor: grab; /* 鼠标变成抓手形状 */
    }
    .card:active { cursor: grabbing; }

    /* 拖拽时的占位符样式 (虚线框) */
    .ui-sortable-placeholder {
      border: 2px dashed #ccc;
      visibility: visible !important;
      height: 40px !important;
      margin-bottom: 8px;
      background: rgba(0,0,0,0.05);
    }
  </style>
</head>
<body>
<h2>📊 ${currentProjectName} <a href="${pageContext.request.contextPath}/main" style="font-size:14px; color:#fff;">(返回首页)</a></h2>

<div class="board-container">
  <c:forEach items="${kanbanLists}" var="list">
    <div class="list-column connectedSortable" id="list-${list.listId}" data-list-id="${list.listId}">
      <div class="list-header">${list.listName}</div>

      <div class="card-container" style="min-height: 20px;">
        <c:forEach items="${list.cards}" var="card">
          <div class="card" data-card-id="${card.cardId}">
              ${card.cardContent}
          </div>
        </c:forEach>
      </div>
    </div>
  </c:forEach>
</div>

<script>
  $(function() {
    // 让所有带有 .card-container 的 div 变成可排序的
    $(".card-container").sortable({
      connectWith: ".card-container", // 允许在不同的列表之间拖拽
      placeholder: "ui-sortable-placeholder", // 拖拽时的占位样式
      cursor: "grabbing",

      // 当拖拽停止（松手）时触发
      stop: function(event, ui) {
        var item = ui.item;
        var cardId = item.data("card-id");
        var newListId = item.closest(".list-column").data("list-id");

        console.log("卡片 " + cardId + " 移动到了列表 " + newListId);

        // 🌟 新增：发送 AJAX 请求给服务器
        $.post("${pageContext.request.contextPath}/moveCard", {
          cardId: cardId,
          newListId: newListId
        }, function(response) {
          if (response === "success") {
            console.log("数据库保存成功！");
          } else {
            alert("保存失败，请刷新重试");
          }
        });
      }
    }).disableSelection();
  });
</script>
</body>
</html>