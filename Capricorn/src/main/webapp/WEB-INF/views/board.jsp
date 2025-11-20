<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>看板 - ${currentProjectName}</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">

  <style>
    body {
      font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
      background-color: #0079bf;
      margin: 0;
      padding: 20px;
      background-size: cover;
      background-position: center;
      transition: background 0.5s;
      display: flex;
      flex-direction: column;
      height: 100vh; /* 全屏高度 */
      box-sizing: border-box;
      overflow: hidden; /* 防止双滚动条 */
    }

    h2 { color: white; margin-top: 0; text-shadow: 1px 1px 3px rgba(0,0,0,0.5); flex-shrink: 0; }
    a { text-decoration: none; }

    .board-container {
      display: flex;
      align-items: flex-start;
      overflow-x: auto; /* 允许横向滚动 */
      flex-grow: 1; /* 占据剩余空间 */
      padding-bottom: 10px;
      margin-bottom: 10px;
      /* 滚动条样式优化 */
      scrollbar-width: thin;
      scrollbar-color: rgba(255,255,255,0.5) transparent;
    }

    .uncategorized-zone {
      height: 220px; /* 固定高度 */
      flex-shrink: 0; /* 禁止被压缩 */
      background: rgba(255, 255, 255, 0.25);
      backdrop-filter: blur(5px);
      border-radius: 8px;
      padding: 15px;
      display: flex;
      flex-direction: column;
      border: 2px dashed rgba(255, 255, 255, 0.6);
      transition: all 0.2s;
      position: relative;
    }

    .uncategorized-header {
      color: white;
      font-weight: bold;
      margin-bottom: 10px;
      font-size: 15px;
      text-shadow: 0 1px 2px rgba(0,0,0,0.3);
    }

    .uncategorized-list-body {
      display: flex;
      flex-wrap: wrap; /* 允许换行 */
      gap: 10px;
      overflow-y: auto; /* 内容多了可以竖向滚动 */
      height: 100%;
      align-content: flex-start;
    }

    .uncategorized-list-body .card {
      width: 260px !important;  /* 强制宽度：跟上面列表卡片保持一致 */
      flex: 0 0 auto;           /* 禁止伸缩 */
      margin: 0 !important;     /* 由 gap 控制间距 */
      height: fit-content;
    }

    .list-column {
      background-color: #ebecf0;
      width: 280px;
      min-width: 280px;
      margin-right: 15px;
      border-radius: 8px;
      padding: 10px;
      display: flex;
      flex-direction: column;
      max-height: 100%;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
      transition: transform 0.2s, box-shadow 0.2s; /* 动画准备 */
    }

    .list-header {
      font-weight: bold;
      color: #172b4d;
      padding: 5px;
      margin-bottom: 10px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .list-del-btn { opacity: 0; cursor: pointer; transition: 0.2s; padding: 5px; border-radius: 3px; }
    .list-del-btn:hover { background: #dfe1e6; color: #c00; }
    .list-column:hover .list-del-btn { opacity: 1; }

    .card-container {
      flex-grow: 1;
      min-height: 50px; /* 保证空列表也能拖入 */
      overflow-y: auto;
      padding-right: 5px;
    }

    .card {
      background-color: white;
      padding: 10px;
      margin-bottom: 8px;
      border-radius: 4px;
      box-shadow: 0 1px 2px rgba(9,30,66,.25);
      cursor: grab;
      position: relative;
      word-wrap: break-word;
      color: #172b4d;
    }
    .delete-btn { position: absolute; top: 5px; right: 5px; display: none; cursor: pointer; color: #999; font-weight: bold; padding: 0 5px;}
    .delete-btn:hover { color: #c00; background: #eee; border-radius: 3px; }
    .card:hover .delete-btn { display: block; }

    .ui-sortable-placeholder {
      border: 2px dashed #0079bf !important;
      background-color: rgba(0, 121, 191, 0.05) !important;
      visibility: visible !important;
      height: 40px !important;
      border-radius: 4px;
      margin-bottom: 8px;
      box-sizing: border-box;
    }

    .ui-sortable-helper {
      z-index: 10000 !important; /* 保证最高层级 */
      width: 260px !important;   /* 强制宽度 */
      box-shadow: 0 10px 25px rgba(0,0,0,0.3) !important;
      transform: rotate(3deg);   /* 倾斜效果 */
      cursor: grabbing !important;
    }

    /* (C) 列表激活样式 (拖入时放大) */
    .list-column.drag-active,
    .uncategorized-zone.drag-active {
      transform: scale(1.02);
      box-shadow: 0 0 0 2px #0079bf, 0 0 15px rgba(0, 121, 191, 0.5); /* 蓝色光圈 */
      background-color: #e6e9ef;
      z-index: 500; /* 浮起 */
    }

    .add-list-wrapper { min-width: 280px; background: rgba(255,255,255,0.25); color: white; padding: 12px; border-radius: 5px; cursor: pointer; font-weight: bold; transition: background 0.2s; }
    .add-list-wrapper:hover { background: rgba(255,255,255,0.4); }
    .add-card-btn { color: #5e6c84; padding: 8px; cursor: pointer; border-radius: 3px; margin-top: 5px; }
    .add-card-btn:hover { background: rgba(9,30,66,0.08); color: #172b4d; }

    .list-footer { margin-top: 5px; }
    .add-card-form, .add-list-form { display: none; margin-top: 5px; }
    .card-input, .list-name-input { width: 100%; padding: 8px; border-radius: 3px; border: none; margin-bottom: 5px; box-sizing: border-box; box-shadow: inset 0 0 0 2px #0079bf; }
    .btn-save { background: #0079bf; color: white; border: none; padding: 6px 12px; border-radius: 3px; cursor: pointer; font-weight: 600; }
    .btn-save:hover { background: #026aa7; }
    .btn-close { background: transparent; border: none; cursor: pointer; font-size: 20px; color: #6b778c; margin-left: 5px; vertical-align: middle; }

    /* 垃圾桶 */
    .trash-zone { position: fixed; bottom: 240px; right: 40px; width: 60px; height: 60px; border-radius: 50%; background: #ebecf0; text-align: center; line-height: 60px; font-size: 30px; z-index: 900; opacity: 0.8; box-shadow: 0 4px 10px rgba(0,0,0,0.2); transition: all 0.2s; }
    .trash-zone.ui-droppable-active { transform: scale(1.1); opacity: 1; background: #fff; }
    .trash-zone.ui-droppable-hover { transform: scale(1.2); background: #ffe3e3; color: #c00; box-shadow: 0 0 20px #c00; }
    .card-danger { background-color: #ffebec !important; border: 2px solid #c00 !important; transform: rotate(5deg) !important; }

    /* 皮肤按钮 */
    .skin-toggle-btn { position: fixed; top: 20px; right: 20px; width: 40px; height: 40px; background: rgba(255,255,255,0.3); border-radius: 50%; display: flex; justify-content: center; align-items: center; padding-bottom: 3px; box-sizing: border-box; font-size: 22px; cursor: pointer; z-index: 2000; color: white; border: 1px solid rgba(255,255,255,0.5); backdrop-filter: blur(5px); }
    .skin-drawer { position: fixed; top: 0; right: -280px; width: 260px; height: 100%; background: #f4f5f7; z-index: 1999; transition: right 0.3s cubic-bezier(0.4, 0, 0.2, 1); padding: 70px 20px; box-sizing: border-box; box-shadow: -5px 0 15px rgba(0,0,0,0.1); }
    .skin-drawer.open { right: 0; }
    .bg-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
    .bg-item { width: 100%; height: 70px; border-radius: 6px; cursor: pointer; background-size: cover; border: 2px solid transparent; transition: transform 0.2s; }
    .bg-item:hover { border-color: #0079bf; transform: scale(1.05); }
  </style>
</head>
<body>

<h2>📊 ${currentProjectName} <a href="${pageContext.request.contextPath}/main" style="font-size:14px; color:#fff; opacity: 0.9;">(返回首页)</a></h2>

<div class="board-container">
  <c:forEach items="${kanbanLists}" var="list">
    <c:if test="${list.listName != '未分类'}">
      <div class="list-column" id="column-${list.listId}" data-list-id="${list.listId}">
        <div class="list-header">
          <div style="cursor: text;" onclick="editListTitle(this, ${list.listId})">${list.listName}</div>
          <div class="list-del-btn" onclick="deleteList(${list.listId})" title="删除列表">🗑️</div>
        </div>

        <div class="card-container connectedSortable" id="container-${list.listId}">
          <c:forEach items="${list.cards}" var="card">
            <div class="card" data-card-id="${card.cardId}">
                ${card.cardContent}
              <span class="delete-btn" onclick="deleteCard(event, ${card.cardId})">&times;</span>
            </div>
          </c:forEach>
        </div>

        <div class="list-footer">
          <div class="add-card-btn" id="btn-wrapper-${list.listId}" onclick="showInputBox(${list.listId})">+ 添加任务</div>
          <div class="add-card-form" id="form-wrapper-${list.listId}">
            <textarea class="card-input" id="input-${list.listId}" rows="3" placeholder="输入任务..."></textarea>
            <div style="display: flex; align-items: center;">
              <button class="btn-save" onclick="submitCard(${list.listId})">添加</button>
              <button class="btn-close" onclick="hideInputBox(${list.listId})">&times;</button>
            </div>
          </div>
        </div>
      </div>
    </c:if>
  </c:forEach>

  <div class="add-list-wrapper" id="addListBtn" onclick="showAddListForm()">+ 添加新列表</div>
  <div class="add-list-wrapper add-list-form" id="addListForm">
    <input type="text" class="list-name-input" id="newListName" placeholder="列表名称..." />
    <div style="display: flex; align-items: center;">
      <button class="btn-save" onclick="submitNewList()">确定</button>
      <button class="btn-close" onclick="hideAddListForm()">&times;</button>
    </div>
  </div>
</div>

<c:forEach items="${kanbanLists}" var="list">
  <c:if test="${list.listName == '未分类'}">
    <div class="uncategorized-zone" data-list-id="${list.listId}">
      <div class="uncategorized-header">📂 未分类 / 归档池 (删除列表后的任务会来到这里)</div>

      <div class="card-container connectedSortable uncategorized-list-body" id="container-${list.listId}">
        <c:forEach items="${list.cards}" var="card">
          <div class="card" data-card-id="${card.cardId}">
              ${card.cardContent}
            <span class="delete-btn" onclick="deleteCard(event, ${card.cardId})">&times;</span>
          </div>
        </c:forEach>
      </div>
    </div>
  </c:if>
</c:forEach>

<div id="trash-can" class="trash-zone" title="拖入此处删除">🗑️</div>
<div class="skin-toggle-btn" id="skin-btn" title="更换背景">👕</div>
<div class="skin-drawer" id="skin-drawer">
  <h3 style="margin-top:0; border-bottom:1px solid #ddd; padding-bottom:10px;">背景设置</h3>
  <div class="bg-grid">
    <div class="bg-item" style="background-image: url('${pageContext.request.contextPath}/images/bg1.png');" data-img="${pageContext.request.contextPath}/images/bg1.png"></div>
    <div class="bg-item" style="background-image: url('${pageContext.request.contextPath}/images/bg2.png');" data-img="${pageContext.request.contextPath}/images/bg2.png"></div>
    <div class="bg-item" style="background-image: url('${pageContext.request.contextPath}/images/bg3.png');" data-img="${pageContext.request.contextPath}/images/bg3.png"></div>
  </div>
</div>

<script>
  var currentProjectId = ${currentProjectId};
  $(function() {
    // 1. 皮肤加载
    var bgVal = localStorage.getItem("bg_value");
    if(bgVal) $('body').css('background-image', 'url('+bgVal+')');

    // 2. 初始化核心拖拽功能
    initSortable();

    // 3. 初始化垃圾桶
    initTrash();

    // 4. 皮肤切换事件
    $("#skin-btn").click(function(e){ e.stopPropagation(); $("#skin-drawer").toggleClass("open"); });
    $(document).click(function(){ $("#skin-drawer").removeClass("open"); });
    $(".skin-drawer").click(function(e){ e.stopPropagation(); });
    $(".bg-item").click(function(){ var u=$(this).data("img"); $('body').css('background-image','url('+u+')'); localStorage.setItem("bg_value",u); });
  });


  function initSortable() {
    $(".card-container").sortable({
      connectWith: ".card-container", // 允许上下区域互通
      placeholder: "ui-sortable-placeholder", // 虚线框样式
      cursor: "grabbing",
      revert: 200,

      appendTo: "body",   // 挂载到 body，脱离容器限制
      helper: "clone",    // 克隆模式
      zIndex: 10000,      // 强制最高层级

      start: function(event, ui) {
        ui.item.css("opacity", 0); // 隐藏原卡片
        // 强制 Helper 宽度，防止从宽容器拖到窄容器时变形
        ui.helper.css("width", "260px");
      },


      over: function(event, ui) {
        $(this).closest(".list-column, .uncategorized-zone").addClass("drag-active");
      },

      out: function(event, ui) {
        $(this).closest(".list-column, .uncategorized-zone").removeClass("drag-active");
      },

      stop: function(event, ui) {
        ui.item.css("opacity", 1); // 恢复显示
        // 移除所有特效，防止卡死
        $(".list-column, .uncategorized-zone").removeClass("drag-active");

        if (ui.item.data("deleting")) return; // 如果是删除操作，不执行移动

        var cardId = ui.item.data("card-id");
        // 获取目标列表ID
        var newListId = ui.item.closest("[data-list-id]").data("list-id");

        $.post("${pageContext.request.contextPath}/moveCard", { cardId: cardId, newListId: newListId });
      }
    }).disableSelection();
  }

  // 垃圾桶逻辑
  function initTrash() {
    $("#trash-can").droppable({
      accept: ".card", tolerance: "touch",
      over: function(e, ui) { ui.helper.addClass("card-danger"); $(this).html("⚠️"); },
      out: function(e, ui) { ui.helper.removeClass("card-danger"); $(this).html("🗑️"); },
      drop: function(e, ui) {
        var cardId = ui.draggable.data("card-id");
        var $card = ui.draggable;

        ui.helper.removeClass("card-danger"); $card.removeClass("card-danger"); $(this).html("🗑️");
        $card.data("deleting", true); // 标记为正在删除

        if(confirm("确定要永久粉碎这个任务吗？")) {
          $card.hide(); // 视觉删除
          $.post("${pageContext.request.contextPath}/board/deleteCard", {cardId:cardId}, function(r){
            if(r==="success") $card.remove();
            else { $card.show(); $card.data("deleting",false); initSortable(); }
          });
        } else {
          $card.data("deleting",false);
          $(".card-container").sortable("cancel"); // 取消操作回弹
        }
      }
    });
  }

  // 列表管理函数
  function showAddListForm() { $("#addListBtn").hide(); $("#addListForm").show(); $("#newListName").focus(); }
  function hideAddListForm() { $("#addListForm").hide(); $("#addListBtn").show(); $("#newListName").val(""); }

  function submitNewList() {
    var name = $("#newListName").val(); if(!name) return;
    $.post("${pageContext.request.contextPath}/board/addList", { projectId: currentProjectId, listName: name }, function(res) {
      if(res.status === "success") location.reload();
    });
  }

  function deleteList(listId) {
    if(confirm("确定删除此列表？\n所有任务将移动到底部的【未分类】区域。")) {
      $.post("${pageContext.request.contextPath}/board/deleteList", { listId: listId }, function(res) {
        if(res==="success") location.reload();
        else alert("删除失败");
      });
    }
  }

  // 其他辅助函数
  function editListTitle(el, id) {
    var txt = $(el).text(); var $inp=$("<input class='list-name-input' style='margin:0;' value='"+txt+"'>");
    $(el).hide().after($inp); $inp.focus().select().on("blur keydown", function(e){
      if(e.type==="keydown" && e.keyCode!==13)return;
      var val=$inp.val();
      if(val && val!==txt) $.post("${pageContext.request.contextPath}/board/renameList", {listId:id, listName:val}, function(){ $(el).text(val).show(); $inp.remove(); });
      else { $(el).show(); $inp.remove(); }
    });
  }

  function showInputBox(id) { $("#btn-wrapper-"+id).hide(); $("#form-wrapper-"+id).show(); $("#input-"+id).focus(); }
  function hideInputBox(id) { $("#form-wrapper-"+id).hide(); $("#btn-wrapper-"+id).show(); $("#input-"+id).val(""); }

  function deleteCard(e, id) { e.stopPropagation(); if(confirm("删除任务？")) $.post("${pageContext.request.contextPath}/board/deleteCard", {cardId:id}, function(r){ if(r==="success") $("div[data-card-id='"+id+"']").remove(); }); }

  function submitCard(id) {
    var txt = $("#input-"+id).val(); if(!txt)return;
    $.post("${pageContext.request.contextPath}/board/addCard", {listId:id, cardContent:txt}, function(r){
      if(r.status==="success") {
        $("#container-"+id).append('<div class="card" data-card-id="'+r.newCardId+'">'+txt+'<span class="delete-btn" onclick="deleteCard(event, '+r.newCardId+')">&times;</span></div>');
        hideInputBox(id);
      }
    });
  }
</script>
</body>
</html>