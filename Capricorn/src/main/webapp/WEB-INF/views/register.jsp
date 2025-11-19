<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>注册 - 任务看板</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* --- 全局基础样式 (与 Login 保持一致) --- */
        body {
            font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
            background-color: #0079bf;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            transition: background-image 0.5s ease-in-out;
        }

        /* --- 注册卡片 --- */
        .register-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            width: 400px;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.5);
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 { margin-top: 0; color: #172b4d; margin-bottom: 10px; font-weight: 600; }
        p.subtitle { color: #5e6c84; margin-bottom: 30px; font-size: 0.9rem; margin-top: 0; }

        /* --- 表单控件 --- */
        .form-group { margin-bottom: 20px; text-align: left; }
        label { display: block; margin-bottom: 8px; color: #5e6c84; font-weight: 500; font-size: 0.9rem; }

        input[type="text"], input[type="password"] {
            width: 100%; padding: 12px; border: 2px solid #dfe1e6; border-radius: 5px;
            box-sizing: border-box; font-size: 1rem; transition: border-color 0.2s; background-color: #fafbfc;
        }
        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #0079bf; background-color: #fff; outline: none;
        }

        .btn-submit {
            width: 100%; padding: 12px; background-color: #2eb067; /* 注册按钮用绿色区分一下 */
            color: white; border: none; border-radius: 5px; font-size: 1rem;
            font-weight: bold; cursor: pointer; transition: background 0.2s; margin-top: 10px;
        }
        .btn-submit:hover { background-color: #269656; }

        .link-text { margin-top: 20px; font-size: 0.9rem; color: #5e6c84; }
        .link-text a { color: #0079bf; text-decoration: none; font-weight: 600; }
        .link-text a:hover { text-decoration: underline; }

        /* --- 消息提示 --- */
        .alert { padding: 12px; border-radius: 5px; margin-bottom: 20px; font-size: 0.9rem; }
        .alert-error { background-color: #ffebe6; color: #bf2600; border: 1px solid #ffbdad; }

        /* --- 皮肤切换侧边栏 --- */
        .skin-toggle-btn {
            position: fixed; top: 20px; right: 20px; width: 40px; height: 40px;
            background: rgba(255,255,255,0.3); border-radius: 50%;
            display: flex; justify-content: center; align-items: center;
            padding-bottom: 3px; box-sizing: border-box; font-size: 22px;
            cursor: pointer; z-index: 2000; color: white; border: 1px solid rgba(255,255,255,0.5);
            transition: background 0.3s;
        }
        .skin-toggle-btn:hover { background: rgba(255,255,255,0.5); }

        .skin-drawer {
            position: fixed; top: 0; right: -280px; width: 260px; height: 100%;
            background: #f4f5f7; z-index: 1999; transition: right 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            padding: 70px 20px; box-sizing: border-box; box-shadow: -5px 0 15px rgba(0,0,0,0.1); text-align: left;
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

<div class="skin-toggle-btn" id="skin-btn" title="更换背景">👕</div>

<div class="register-card">
    <h2>🚀 创建账号</h2>
    <p class="subtitle">开始管理你的任务与生活</p>

    <c:if test="${not empty errorMsg}">
        <div class="alert alert-error">⚠️ ${errorMsg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="form-group">
            <label>用户名</label>
            <input type="text" name="username" placeholder="设置一个用户名" required>
        </div>

        <div class="form-group">
            <label>密码</label>
            <input type="password" name="password" placeholder="设置登录密码" required>
        </div>

        <button type="submit" class="btn-submit">立即注册</button>
    </form>

    <div class="link-text">
        已经有账号了？ <a href="${pageContext.request.contextPath}/login">直接登录</a>
    </div>
</div>

<div class="skin-drawer" id="skin-drawer">
    <h3 style="margin-top:0; border-bottom:1px solid #ddd; padding-bottom:10px; color:#172b4d;">背景风格</h3>
    <div class="bg-grid">
        <div class="bg-item" style="background-image: url('${pageContext.request.contextPath}/images/bg1.png');" data-img="${pageContext.request.contextPath}/images/bg1.png"></div>
        <div class="bg-item" style="background-image: url('${pageContext.request.contextPath}/images/bg2.png');" data-img="${pageContext.request.contextPath}/images/bg2.png"></div>
        <div class="bg-item" style="background-image: url('${pageContext.request.contextPath}/images/bg3.png');" data-img="${pageContext.request.contextPath}/images/bg3.png"></div>
    </div>
</div>

<script>
    $(function() {
        // 1. 自动加载缓存背景
        var bgVal = localStorage.getItem("bg_value");
        if(bgVal) $('body').css('background-image', 'url('+bgVal+')');

        // 2. 皮肤切换逻辑
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
</script>
</body>
</html>