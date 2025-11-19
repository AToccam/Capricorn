<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>看板 - ${currentProjectName}</title>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">

  <style>
    /* --- 全局基础样式 --- */
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0079bf; margin: 0; padding: 20px; overflow: hidden; /* 防止双滚动条 */ }
    h2 { color: white; margin-top: 0; }
    a { text-decoration: none; }

    /* --- 看板容器 --- */
    .board-container {
      display: flex;
      align-items: flex-start;
      overflow-x: auto;
      height: 90vh;
      padding-bottom: 20px;
    }

    /* --- 列表样式 --- */
    .list-column {
      background-color: #ebecf0;
      width: 280px;
      min-width: 280px;
      margin-right: 15px;
      border-radius: 5px;
      padding: 10px;
      box-sizing: border-box;
      display: flex;
      flex-direction: column;
      max-height: 100%;
    }

    .list-header {
      font-weight: bold;
      margin-bottom: 10px;
      padding: 5px;
      cursor: default;
      color: #172b4d;
    }

    /* --- 卡片容器 (可拖拽区域) --- */
    .card-container {
      flex-grow: 1;
      min-height: 10px; /* 保证空列表也能拖入 */
      overflow-y: auto;
      padding-bottom: 5px;
      padding-right: 5px; /* 滚动条间隙 */
    }

    /* --- 卡片样式 --- */
    .card {
      background-color: white;
      padding: 10px;
      margin-bottom: 8px;
      border-radius: 3px;
      box-shadow: 0 1px 0 rgba(9,30,66,.25);
      cursor: grab;
      word-wrap: break-word;
      color: #172b4d;
      transition: transform 0.1s, background-color 0.2s;
    }
    .card:active { cursor: grabbing; }

    /* 拖拽时的占位符 (虚线框) */
    .ui-sortable-placeholder {
      border: 2px dashed #ccc;
      visibility: visible !important;
      height: 40px !important;
      margin-bottom: 8px;
      background: rgba(0,0,0,0.05);
      border-radius: 3px;
    }

    /* --- 底部添加按钮区域 --- */
    .list-footer { margin-top: 5px; }

    .add-card-btn {
      color: #5e6c84;
      padding: 8px;
      border-radius: 3px;
      cursor: pointer;
      transition: background 0.2s;
    }
    .add-card-btn:hover { background-color: rgba(9, 30, 66, 0.08); color: #172b4d; }

    .add-card-form { display: none; } /* 默认隐藏 */

    .card-input {
      width: 100%;
      border: none;
      border-radius: 3px;
      padding: 8px;
      box-shadow: 0 1px 0 rgba(9,30,66,.25);
      margin-bottom: 5px;
      resize: none;
      display: block;
      box-sizing: border-box;
      font-family: inherit;
    }
    .btn-save { background-color: #0079bf; color: white; border: none; padding: 6px 12px; border-radius: 3px; cursor: pointer; font-weight: bold; }
    .btn-save:hover { background-color: #026aa7; }
    .btn-close { background: transparent; border: none; cursor: pointer; font-size: 20px; color: #6b778c; margin-left: 5px; vertical-align: middle; }
    .btn-close:hover { color: #172b4d; }

    /* --- 🗑️ 垃圾桶区域样式 --- */
    .trash-zone {
      position: fixed;
      bottom: 40px;
      right: 40px;
      width: 70px;
      height: 70px;
      border-radius: 50%;
      background-color: #ebecf0; /* 平时颜色 */
      text-align: center;
      line-height: 70px;
      font-size: 35px;
      z-index: 9999;
      transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); /* 弹性动画 */
      box-shadow: 0 4px 15px rgba(0,0,0,0.2);
      user-select: none;
      opacity: 0.8;
    }

    /* 当有卡片被拖动时，垃圾桶稍微变大提示 */
    .trash-zone.ui-droppable-active {
      transform: scale(1.1);
      background-color: #dfe1e6;
      opacity: 1;
    }

    /* 当卡片拖到垃圾桶上方时：变红警告 */
    .trash-zone.ui-droppable-hover {
      transform: scale(1.2);
      background-color: #ffe3e3;
      box-shadow: 0 0 20px rgba(255, 0, 0, 0.4);
      color: #ff0000;
    }

    /* --- 即将删除的卡片样式 --- */
    /* jQuery UI Helper 样式 */
    .card-danger {
      background-color: #ffebec !important;
      border: 2px solid #ff0000 !important;
      color: #c00 !important;
      transform: rotate(5deg) !important; /* 歪一点 */
      opacity: 0.9;
    }

  </style>
</head>
<body>

<h2>📊 ${currentProjectName} <a href="${pageContext.request.contextPath}/main" style="font-size:14px; color:#fff; opacity: 0.8;">(返回首页)</a></h2>

<div class="board-container">
  <c:forEach items="${kanbanLists}" var="list">
    <div class="list-column" data-list-id="${list.listId}">
      <div class="list-header">${list.listName}</div>

      <div class="card-container connectedSortable" id="container-${list.listId}">
        <c:forEach items="${list.cards}" var="card">
          <c:if test="${not empty card.cardId}">
            <div class="card" data-card-id="${card.cardId}">
                ${card.cardContent}
            </div>
          </c:if>
        </c:forEach>
      </div>

      <div class="list-footer">
        <div class="add-card-btn" id="btn-wrapper-${list.listId}" onclick="showInputBox(${list.listId})">
          + 添加任务
        </div>
        <div class="add-card-form" id="form-wrapper-${list.listId}">
          <textarea class="card-input" id="input-${list.listId}" rows="3" placeholder="为此卡片输入标题..."></textarea>
          <div style="display: flex; align-items: center;">
            <button class="btn-save" onclick="submitCard(${list.listId})">添加卡片</button>
            <button class="btn-close" onclick="hideInputBox(${list.listId})">&times;</button>
          </div>
        </div>
      </div>
    </div>
  </c:forEach>
</div>

<div id="trash-can" class="trash-zone" title="拖入此处删除">
  🗑️
</div>

<script>
  $(function() {
    // =========================================
    // 1. 拖拽排序 (Sortable)
    // =========================================
    $(".card-container").sortable({
      connectWith: ".card-container",
      placeholder: "ui-sortable-placeholder",
      cursor: "grabbing",
      revert: 200, // 开启回弹动画

      // 拖拽停止时的回调
      stop: function(event, ui) {
        // 如果卡片已经被标记为“正在删除”，则不要执行移动逻辑
        if (ui.item.data("deleting")) {
          return;
        }

        var item = ui.item;
        var cardId = item.data("card-id");
        var newListId = item.closest(".list-column").data("list-id");

        console.log("更新位置: " + cardId + " -> " + newListId);
        $.post("${pageContext.request.contextPath}/moveCard", {
          cardId: cardId,
          newListId: newListId
        });
      }
    }).disableSelection();

    // =========================================
    // 2. 拖拽删除 (Droppable) - 修复版
    // =========================================
    $("#trash-can").droppable({
      accept: ".card",
      tolerance: "touch",

      // 移入：变红
      over: function(event, ui) {
        ui.helper.addClass("card-danger");
        $(this).html("⚠️");
      },

      // 移出：恢复
      out: function(event, ui) {
        ui.helper.removeClass("card-danger");
        $(this).html("🗑️");
      },

      // 松手：触发删除逻辑
      drop: function(event, ui) {
        var cardId = ui.draggable.data("card-id");
        var $cardElement = ui.draggable; //原本的卡片元素

        // 【修复1】第一时间移除红色样式，防止它带着样式弹回去
        ui.helper.removeClass("card-danger");
        $cardElement.removeClass("card-danger");
        $(this).html("🗑️");

        // 标记为正在删除，防止 sortable 的 stop 事件干扰
        $cardElement.data("deleting", true);

        if (confirm("确定要永久删除这个任务吗？")) {
          // 【修复2】视觉上直接移除 (Optimistic UI)
          // 先隐藏，让用户觉得“已经删了”，然后再去后台删
          $cardElement.hide();

          // 发送请求给后端
          $.post("${pageContext.request.contextPath}/board/deleteCard", {
            cardId: cardId
          }, function(response) {
            if (response === "success") {
              // 后端删除成功，彻底移除DOM
              $cardElement.remove();
              console.log("数据库删除成功");
            } else {
              // 后端删除失败（极其罕见），恢复显示
              alert("删除失败，请刷新重试");
              $cardElement.show();
              $cardElement.data("deleting", false);
              $(".card-container").sortable("cancel");
            }
          });
        } else {
          // 用户点击取消：让卡片弹回去
          $cardElement.data("deleting", false);
          // 必须调用 cancel 让 sortable 把 DOM 放回原处
          $(".card-container").sortable("cancel");
        }
      }
    });
  });

  // =========================================
  // 3. 添加任务相关函数 (保持不变)
  // =========================================
  function showInputBox(listId) {
    $("#btn-wrapper-" + listId).hide();
    $("#form-wrapper-" + listId).show();
    $("#input-" + listId).focus();
  }

  function hideInputBox(listId) {
    $("#form-wrapper-" + listId).hide();
    $("#btn-wrapper-" + listId).show();
    $("#input-" + listId).val("");
  }

  function submitCard(listId) {
    var content = $("#input-" + listId).val();
    if (!content || content.trim() === "") return;

    $.ajax({
      url: "${pageContext.request.contextPath}/board/addCard",
      type: "POST",
      data: { listId: listId, cardContent: content },
      success: function(response) {
        if (response.status === "success") {
          var newCardHtml = '<div class="card" data-card-id="' + response.newCardId + '">' +
                  content + '</div>';
          $("#container-" + listId).append(newCardHtml);
          hideInputBox(listId);
        } else {
          alert("添加失败");
        }
      },
      error: function() { alert("网络错误"); }
    });
  }
</script>

</body>
</html>