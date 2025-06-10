<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String email = "";
    String regTime = "";
    int points = 0;
    int activityCount = 0; // 新增变量
    String errorMsg = null;
    try (Connection conn = JDBCUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(
             "SELECT u.username, u.email, u.reg_time, u.points, " +
             "(SELECT COUNT(*) FROM signup WHERE user_id = u.id) AS activity_count " +
             "FROM user u WHERE u.username=?")) {
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                email = rs.getString("email") != null ? rs.getString("email") : "";
                regTime = rs.getString("reg_time") != null ? rs.getString("reg_time") : "";
                points = rs.getInt("points");
                activityCount = rs.getInt("activity_count"); // 获取活动次数
            } else {
                errorMsg = "未找到该用户信息，请重新登录。";
            }
        }
    } catch (Exception e) {
        errorMsg = "获取用户信息失败：" + e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 志愿者服务平台</title>
    <link rel="icon" href="image/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 全局样式和背景 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e0f7fa 0%, #b2ebf2 100%); /* 使用更柔和的蓝色渐变 */
            min-height: 100vh;
            display: flex;
            align-items: flex-start; /* 顶部对齐 */
            justify-content: center;
            padding: 30px 15px; /* 增加上下内边距，左右适应 */
            box-sizing: border-box; /* 盒模型设置为border-box */
        }

        /* 主容器 */
        .main-container {
            background-color: #ffffff; /* 白色背景 */
            border-radius: 15px; /* 圆角 */
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15); /* 更明显的阴影 */
            padding: 40px; /* 内部填充 */
            max-width: 1500px; /* 稍微增加最大宽度 */
            width: 100%;
            margin-top: 10px; /* 顶部留白 */
            margin-bottom: 10px; /* 底部留白 */
            display: flex; /* 使用Flexbox布局 */
        }

        /* 页面标题 */
        .section-title {
            color: #0056b3; /* 深蓝色标题 */
            font-weight: 700; /* 加粗 */
            margin-bottom: 30px; /* 增加下方间距 */
            text-align: center;
            font-size: 2rem; /* 增加字体大小 */
            position: relative; /* 用于添加下划线效果 */
        }

        .section-title::after {
            content: '';
            display: block;
            width: 60px; /* 下划线宽度 */
            height: 4px; /* 下划线高度 */
            background-color: #007bff; /* 下划线颜色 */
            margin: 10px auto 0; /* 居中并与标题保持距离 */
            border-radius: 2px;
        }

        /* 卡片样式优化 */
        /* 包含 info-card, records-card, content-card (用于其他页面) */
        .info-card, .records-card, .content-card {
            border: none; /* 移除默认边框 */
            border-radius: 12px; /* 较大的圆角 */
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08); /* 适中的阴影 */
            margin-bottom: 30px; /* 卡片间距 */
            overflow: hidden; /* 确保内容不溢出圆角 */
        }

        .info-card .card-body, .records-card .card-body, .content-card .card-body {
            padding: 30px; /* 调整内边距 */
        }

        .info-card h4 {
            margin-bottom: 15px;
            color: #333; /* 深色标题 */
            font-size: 1.5rem;
        }

        .badge-success {
            background-color: #28a745 !important; /* Bootstrap success color */
            font-size: 1rem; /* 增加字体大小 */
            padding: 0.5em 0.75em; /* 调整内边距 */
            vertical-align: middle; /* 垂直居中 */
        }

        /* 服务记录卡片头部 */
        .records-card .card-header {
            background-color: #f8f9fa; /* 浅灰色背景 */
            border-bottom: 1px solid #e9ecef;
            padding: 15px 30px; /* 调整内边距 */
            font-size: 1.2rem;
            font-weight: bold;
            color: #495057;
        }

        /* 表格样式 */
        .table {
            margin-bottom: 0; /* 移除表格底部默认间距 */
            border-collapse: separate; /* 允许设置border-spacing */
            border-spacing: 0 8px; /* 增加行间距 */
        }

        .table th, .table td {
            vertical-align: middle; /* 垂直居中 */
            padding: 12px 15px; /* 调整单元格内边距 */
            border-top: 1px solid #dee2e6; /* 添加顶部边框 */
        }

        .table thead th {
            background-color: #e9ecef; /* 表头背景色 */
            border-bottom: 2px solid #dee2e6;
            font-weight: bold;
            color: #495057;
        }

        .table tbody tr {
             background-color: #fff; /* 行背景色 */
             transition: all 0.2s ease-in-out;
        }

        .table tbody tr:hover {
             background-color: #f1f1f1; /* 鼠标悬停背景色 */
        }

        .table-bordered th, .table-bordered td {
            border: 1px solid #dee2e6; /* 恢复边框 */
        }

        .table-bordered thead th {
             border-bottom-width: 2px;
        }

        /* 按钮组样式 */
        .button-group {
            text-align: center; /* 按钮居中 */
            margin-top: 40px; /* 增加上方间距 */
        }

        .button-group .btn {
            margin: 0 15px; /* 增加按钮间距 */
            border-radius: 30px; /* 更大的圆角，胶囊状 */
            padding: 10px 25px; /* 调整内边距 */
            font-size: 1.1rem; /* 增加字体大小 */
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary {
             background-color: #007bff;
             border-color: #007bff;
         }

         .btn-primary:hover {
             background-color: #0056b3;
             border-color: #0056b3;
             transform: translateY(-3px); /* 增加悬停上移距离 */
             box-shadow: 0 6px 12px rgba(0, 123, 255, 0.3); /* 蓝色阴影 */
         }

         .btn-secondary {
             background-color: #6c757d;
             border-color: #6c757d;
         }

         .btn-secondary:hover {
             background-color: #5a6268;
             border-color: #545b62;
             transform: translateY(-3px);
             box-shadow: 0 6px 12px rgba(108, 117, 125, 0.3); /* 灰色阴影 */
         }

         .btn-outline-danger {
             border-color: #dc3545;
             color: #dc3545;
         }

         .btn-outline-danger:hover {
             background-color: #dc3545;
             color: white;
             transform: translateY(-3px);
             box-shadow: 0 6px 12px rgba(220, 53, 69, 0.3); /* 红色阴影 */
         }

         /* 导航栏样式 */
         .nav-tabs {
             margin-bottom: 30px; /* 导航栏下方间距 */
             border-bottom: 2px solid #dee2e6; /* 底部边框加粗 */
         }

         .nav-tabs .nav-item {
             margin-bottom: -2px; /* 配合border-bottom加粗 */
         }

         .nav-tabs .nav-link {
             color: #495057; /* 默认链接颜色 */
             border: 1px solid transparent;
             border-top-left-radius: 0.35rem; /* 稍微增加圆角 */
             border-top-right-radius: 0.35rem;
             padding: 10px 20px; /* 调整内边距 */
             transition: color 0.2s ease-in-out, background-color 0.2s ease-in-out, border-color 0.2s ease-in-out;
         }

         .nav-tabs .nav-link:hover {
             border-color: #e9ecef #e9ecef #dee2e6;
             background-color: #f8f9fa; /* 悬停背景色 */
         }

         .nav-tabs .nav-link.active {
             color: #007bff; /* 激活链接颜色 */
             background-color: #fff; /* 激活背景色 */
             border-color: #dee2e6 #dee2e6 #fff; /* 激活边框 */
             border-bottom-color: #fff; /* 隐藏底部边框 */
             font-weight: bold;
             position: relative; /* 用于添加底部激活指示线 */
         }

         /* 激活tab底部指示线 */
         .nav-tabs .nav-link.active::after {
             content: '';
             display: block;
             position: absolute;
             bottom: -2px; /* 位于底部边框下方 */
             left: 0;
             right: 0;
             height: 2px; /* 指示线高度 */
             background-color: #007bff; /* 指示线颜色 */
             z-index: 1; /* 确保在其他元素之上 */
         }

         /* 响应式调整 */
         @media (max-width: 768px) {
             .main-container {
                 padding: 20px; /* 减小小屏幕内边距 */
                 flex-direction: column; /* 小屏幕下改为垂直布局 */
             }
             .section-title {
                 font-size: 1.8rem; /* 减小小屏幕标题字体 */
                 margin-bottom: 20px;
             }
             .sidebar {
                 width: 100%; /* 小屏幕下侧边栏宽度占满 */
                 margin-right: 0; /* 移除右侧间距 */
                 margin-bottom: 20px; /* 增加下方间距 */
             }
             .content-area {
                 width: 100%; /* 小屏幕下内容区域宽度占满 */
             }
         }

        /* 个人中心侧边导航栏样式 */
        .sidebar {
            width: 250px; /* 侧边栏固定宽度 */
            margin-right: 30px; /* 与主内容区域的间距 */
            flex-shrink: 0; /* 不允许侧边栏收缩 */
        }

        .sidebar .list-group-item {
            border: none;
            border-radius: 8px;
            margin-bottom: 8px;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .sidebar .list-group-item:hover {
            background-color: #e9ecef;
            color: #007bff;
        }

        .sidebar .list-group-item.active {
            background-color: #007bff;
            color: white;
            font-weight: bold;
        }

        .sidebar .list-group-item i {
            margin-right: 10px;
        }

        /* 主内容区域样式 */
        .content-area {
            flex-grow: 1; /* 允许主内容区域填充剩余空间 */
        }

        /* 卡片容器样式 */
        .card-container {
            display: flex;
            justify-content: center; /* 居中对齐 */
            gap: 20px; /* 卡片之间的间距 */
            margin-bottom: 30px; /* 底部间距 */
        }

        /* 用户积分信息卡片 */
        .points-info-card {
            background: linear-gradient(to right, #ffc107, #ff9800); /* Yellow gradient */
            color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 450px;
        }

        /* 活动次数卡片 */
        .activity-count-card {
            background: linear-gradient(to right, #4caf50, #81c784); /* Green gradient */
            color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 450px;
        }

        .points-info-card h4, .activity-count-card h4 {
            color: white;
            margin-bottom: 10px;
        }

        .points-info-card .badge, .activity-count-card .badge {
            background-color: rgba(255, 255, 255, 0.3);
            color: white;
            font-size: 1.5rem;
            padding: 0.5em 0.75em;
        }
    </style>
</head>
<body>
<jsp:include page="common/navbar.jsp" />

<div class="main-container">
    <div class="sidebar">
        <div class="list-group">
            <a href="volunteer_center.jsp" class="list-group-item list-group-item-action active">
                <i class="fas fa-user-circle"></i> 个人信息
            </a>
            <a href="service_records.jsp" class="list-group-item list-group-item-action">
                <i class="fas fa-clipboard-list"></i> 服务记录
            </a>
            <a href="points_mall.jsp" class="list-group-item list-group-item-action">
                <i class="fas fa-store"></i> 积分商城
            </a>
            <a href="messages.jsp" class="list-group-item list-group-item-action">
                <i class="fas fa-envelope"></i> 消息中心
            </a>
        </div>
    </div>

    <div class="content-area">
        <h2 class="section-title">个人中心</h2>

        <!-- 个人信息卡片开始 -->
        <div class="d-flex align-items-center justify-content-center mb-4 flex-row">
            <div style="width:110px;height:110px;border-radius:50%;border:4px solid #4caf50;display:flex;align-items:center;justify-content:center;background:#fff;">
                <span style="font-size:64px;line-height:1;">
                    <i class="fas fa-briefcase-medical" style="color:#e53935;"></i>
                </span>
            </div>
            <div class="ms-4 me-2" style="font-size:2.2rem;font-weight:700;letter-spacing:2px;">
                <%= username %>
            </div>
            <span class="badge bg-success ms-2" style="font-size:1rem;height:2.2rem;display:flex;align-items:center;">志愿者</span>
        </div>
        <!-- 个人信息卡片结束 -->

        <!-- 个人信息表格 -->
        <div class="mx-auto mb-4" style="max-width:350px;">
            <table class="table border-0" style="font-size:1.15rem;">
                <tbody>
                <tr>
                    <td class="text-end text-secondary border-0" style="width:40%;">用户名</td>
                    <td class="border-0"><%= username %></td>
                </tr>
                <tr>
                    <td class="text-end text-secondary border-0">邮箱</td>
                    <td class="border-0"><%= email %></td>
                </tr>
                <tr>
                    <td class="text-end text-secondary border-0">积分</td>
                    <td class="border-0"><%= points %></td>
                </tr>
                <tr>
                    <td class="text-end text-secondary border-0">注册时间</td>
                    <td class="border-0"><%= regTime %></td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- 卡片容器 -->
        <div class="card-container">
            <!-- 我的当前积分卡片 -->
            <div class="points-info-card">
                <h4>我的当前积分</h4>
                <h1><span class="badge bg-light text-warning"><i class="fas fa-coins me-2"></i><%= points %></span></h1>
            </div>

            <!-- 我参加的活动次数卡片 -->
            <div class="activity-count-card">
                <h4>我参加的活动次数</h4>
                <h1><span class="badge bg-light text-warning"><i class="fas fa-calendar-check me-2"></i><%= activityCount %></span></h1>
            </div>
        </div>

        <div class="button-group">
            <a href="index.jsp" class="btn btn-secondary"><i class="fas fa-home me-2"></i>返回首页</a>
            <a href="logout.jsp" class="btn btn-outline-danger"><i class="fas fa-sign-out-alt me-2"></i>退出登录</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
