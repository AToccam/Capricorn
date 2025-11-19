<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Capricorn - 任务管理系统</title>
  <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
  <style>
    /* --- 全局样式 --- */
    body {
      margin: 0;
      padding: 0;
      font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: hidden;
      color: white;
      background-color: #000; /* 视频加载前的兜底颜色 */
    }

    /* ========================================= */
    /* 🎥 视频背景核心样式                        */
    /* ========================================= */
    #bg-video {
      position: fixed;
      top: 50%;
      left: 50%;
      min-width: 100%;
      min-height: 100%;
      width: auto;
      height: auto;
      z-index: -100; /* 放在最底层 */
      transform: translate(-50%, -50%);
      object-fit: cover; /* 关键：裁剪视频以填满屏幕 */
    }

    /* --- 遮罩层 (让文字更清晰) --- */
    .overlay {
      position: fixed;
      top: 0; left: 0; width: 100%; height: 100%;
      background: rgba(0, 0, 0, 0.4);
      z-index: -1; /* 在视频之上，内容之下 */
    }

    /* --- 核心内容容器 (磨砂玻璃) --- */
    .hero-container {
      position: relative;
      z-index: 2;
      text-align: center;
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(10px);
      padding: 60px 80px;
      border-radius: 20px;
      border: 1px solid rgba(255, 255, 255, 0.2);
      box-shadow: 0 15px 35px rgba(0,0,0,0.2);
      animation: floatUp 1s ease-out;
    }

    @keyframes floatUp {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* ========================================= */
    /* ✨ 标题样式 (花体字 + 渐变高亮)             */
    /* ========================================= */
    h1 {
      /* 引用 Google Fonts 字体 */
      font-family: 'Dancing Script', cursive;
      font-size: 5rem; /* 字体加大，更显气势 */
      margin: 0;
      font-weight: 700;
      letter-spacing: 2px; /* 字母间距稍微收紧，花体字更紧凑 */
      text-transform: capitalize; /* 首字母大写即可，花体字不适合全大写 */

      /* 更明亮、有光泽感的渐变色 */
      background: linear-gradient(to right, #ffe6cc, #ffd699, #f7f7f7, #ffd699, #ffe6cc);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;

      /* 更有深度的投影 */
      text-shadow: 0 0 15px rgba(255, 255, 255, 0.5), 0 0 30px rgba(255, 255, 255, 0.2);
    }

    p.subtitle {
      font-size: 1.2rem;
      margin-top: 15px;
      margin-bottom: 40px;
      opacity: 0.9;
      letter-spacing: 1px;
      color: #e0e0e0;
    }

    /* --- 按钮样式 --- */
    .btn-start {
      display: inline-block;
      padding: 15px 40px;
      font-size: 1.1rem;
      font-weight: bold;
      color: #0079bf;
      background-color: white;
      border-radius: 50px;
      text-decoration: none;
      transition: all 0.3s ease;
      box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }

    .btn-start:hover {
      transform: translateY(-3px) scale(1.05);
      box-shadow: 0 10px 20px rgba(0,0,0,0.3);
      background-color: #f0f8ff;
    }

    .footer {
      position: absolute;
      bottom: 20px;
      z-index: 2;
      font-size: 0.8rem;
      opacity: 0.6;
    }
  </style>
</head>
<body>

<video autoplay muted loop playsinline id="bg-video">
  <source src="${pageContext.request.contextPath}/videos/test.mp4" type="video/mp4">
  您的浏览器不支持 HTML5 视频。
</video>

<div class="overlay"></div>

<div class="hero-container">
  <h1>Capricorn</h1>
  <p class="subtitle">Define your tasks. Design your life.</p>

  <a href="${pageContext.request.contextPath}/login" class="btn-start">
    立即体验 &rarr;
  </a>
</div>

<div class="footer">
  &copy; 2025 Capricorn Project. All rights reserved.
</div>

</body>
</html>