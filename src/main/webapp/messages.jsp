<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("../login.jsp"); // 注意路径调整
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>消息通知 - 志愿者服务平台</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); /* 借鉴留言板背景 */
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px; /* 添加一些内边距 */
        }

        .main-container {
            background-color: #fff; /* 白色背景卡片 */
            border-radius: 15px; /* 圆角 */
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); /* 阴影 */
            padding: 40px; /* 内部填充 */
            max-width: 900px; /* 最大宽度 */
            width: 100%;
        }

        .section-title {
            color: #007bff; /* 蓝色标题，借鉴留言板标题颜色 */
            font-weight: bold;
            margin-bottom: 20px;
            text-align: center;
        }

        /* 卡片样式优化 */
        .info-card, .content-card { /* content-card 用于其他页面内容 */
            border: none; /* 移除默认边框 */
            border-radius: 10px; /* 较小的圆角 */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); /* 较小的阴影 */
            margin-bottom: 20px; /* 调整卡片间距 */
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out; /* 添加过渡效果 */
        }

        .info-card:hover { /* 添加悬停效果 */
            transform: translateY(-5px); /* 向上微移 */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); /* 增大阴影 */
        }

        .info-card .card-body, .content-card .card-body {
            padding: 20px; /* 调整内边距 */
        }

        .info-card h5 {
            margin-bottom: 10px; /* 调整标题下边距 */
            color: #333; /* 调整标题颜色 */
        }

        .info-card p {
            margin-bottom: 15px; /* 调整文本下边距 */
            color: #555; /* 调整文本颜色 */
        }

        .info-card .badge {
            font-size: 0.85em; /* 调整徽章字体大小 */
        }

        .info-card .text-muted {
            font-size: 0.85em; /* 调整日期字体大小 */
        }

        .badge-success {
            background-color: #28a745 !important; /* Bootstrap success color */
        }

        /* 表格样式 (保留，因为其他页面会用) */
        .table {
            margin-bottom: 0; /* 移除表格底部默认间距 */
        }

        .table th, .table td {
            vertical-align: middle; /* 垂直居中 */
        }

        .table thead th {
            background-color: #e9ecef; /* 表头背景色 */
            border-bottom: 2px solid #dee2e6;
        }

        /* 按钮组样式 */
        .button-group {
            text-align: center; /* 按钮居中 */
            margin-top: 30px;
        }

        .button-group .btn {
            margin: 0 10px; /* 按钮间距 */
            border-radius: 8px; /* 按钮圆角 */
        }

        .btn-primary {
             background-color: #007bff;
             border-color: #007bff;
             transition: all 0.3s ease;
         }

         .btn-primary:hover {
             background-color: #0056b3;
             border-color: #0056b3;
             transform: translateY(-2px);
             box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
         }

         .btn-secondary {
             background-color: #6c757d;
             border-color: #6c757d;
             transition: all 0.3s ease;
         }

         .btn-secondary:hover {
             background-color: #5a6268;
             border-color: #545b62;
             transform: translateY(-2px);
             box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
         }

         .btn-outline-danger {
             border-color: #dc3545;
             color: #dc3545;
             transition: all 0.3s ease;
         }

         .btn-outline-danger:hover {
             background-color: #dc3545;
             color: white;
             transform: translateY(-2px);
             box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
         }

         /* 导航栏样式 */
         .nav-tabs {
             margin-bottom: 30px; /* 导航栏下方间距 */
             border-bottom: 1px solid #dee2e6; /* 底部边框 */
         }

         .nav-tabs .nav-link {
             color: #495057; /* 默认链接颜色 */
             border: 1px solid transparent;
             border-top-left-radius: 0.25rem;
             border-top-right-radius: 0.25rem;
             margin-bottom: -1px; /* 使激活的tab边框与下方对齐 */
             transition: color 0.2s ease-in-out, background-color 0.2s ease-in-out, border-color 0.2s ease-in-out;
         }

         .nav-tabs .nav-link:hover {
             border-color: #e9ecef #e9ecef #dee2e6;
         }

         .nav-tabs .nav-link.active {
             color: #007bff; /* 激活链接颜色 */
             background-color: #fff; /* 激活背景色 */
             border-color: #dee2e6 #dee2e6 #fff; /* 激活边框 */
             font-weight: bold;
         }

    </style>
</head>
<body>

<div class="main-container">
    <h2 class="section-title">我的个人中心</h2>

    <!-- Navigation Tabs -->
    <ul class="nav nav-tabs mb-4">
        <li class="nav-item">
            <a class="nav-link" href="volunteer_center.jsp">个人中心</a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="messages.jsp">消息通知</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="service_records.jsp">服务记录</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="reviews.jsp">收到评价</a>
        </li>
    </ul>

    <!-- Messages Content Card -->
    <div class="card content-card">
        <div class="card-header">
            <h5>消息通知</h5>
        </div>
        <div class="card-body">
            <!-- 示例消息卡片展示 -->
            <div class="card mb-3 info-card">
                <div class="card-body">
                    <h5 class="card-title mb-2">活动报名成功通知</h5>
                    <p class="card-text">您已成功报名“社区卫生宣传志愿服务”活动，请准时参加。</p>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="badge badge-success">系统通知</span>
                        <span class="text-muted" style="font-size:0.95em;">2024-06-02</span>
                    </div>
                </div>
            </div>
            <div class="card mb-3 info-card">
                <div class="card-body">
                    <h5 class="card-title mb-2">项目负责人留言</h5>
                    <p class="card-text">感谢您的积极参与，期待下次合作！</p>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="badge badge-success">项目负责人</span>
                        <span class="text-muted" style="font-size:0.95em;">2024-05-30</span>
                    </div>
                </div>
            </div>
            <div class="card mb-3 info-card">
                <div class="card-body">
                    <h5 class="card-title mb-2">积分变动提醒</h5>
                    <p class="card-text">您因参与志愿服务获得10积分，继续加油！</p>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="badge badge-success">系统通知</span>
                        <span class="text-muted" style="font-size:0.95em;">2024-05-25</span>
                    </div>
                </div>
            </div>
            <!-- 结束示例消息卡片 -->
        </div>
    </div>

    <div class="button-group">
        <a href="index.jsp" class="btn btn-secondary"><i class="fas fa-home me-2"></i>返回首页</a>
        <a href="project_list.jsp" class="btn btn-primary"><i class="fas fa-list-alt me-2"></i>浏览志愿服务项目</a>
        <a href="logout.jsp" class="btn btn-outline-danger"><i class="fas fa-sign-out-alt me-2"></i>退出登录</a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>