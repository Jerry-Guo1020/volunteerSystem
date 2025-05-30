<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    String username = (String) session.getAttribute("username");
    // 项目列表页面可能不需要登录，取决于您的设计
    // 如果需要登录，取消下面代码的注释
    /*
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    */

    List<Map<String, Object>> projects = new ArrayList<>();
    String errorMsg = null;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = JDBCUtil.getConnection();
        // 获取所有项目列表
        ps = conn.prepareStatement("SELECT id, name, description, points, publisher, start_time, end_time FROM project ORDER BY start_time DESC");
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> project = new HashMap<>();
            project.put("id", rs.getInt("id"));
            project.put("name", rs.getString("name"));
            project.put("description", rs.getString("description"));
            project.put("points", rs.getInt("points"));
            project.put("publisher", rs.getString("publisher"));
            project.put("start_time", rs.getTimestamp("start_time"));
            project.put("end_time", rs.getTimestamp("end_time"));
            projects.add(project);
        }

    } catch (SQLException e) {
        errorMsg = "加载项目列表失败：" + e.getMessage();
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>志愿服务项目列表 - 志愿者服务平台</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
    
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); /* 借鉴index.jsp背景 */
            min-height: 100vh;
            display: flex;
            align-items: flex-start; /* 顶部对齐 */
            justify-content: center;
            padding: 30px 15px; /* 增加上下内边距，左右适应 */
            box-sizing: border-box; /* 盒模型设置为border-box */
        }

        /* 主容器 - 调整阴影和圆角 */
        .main-container {
            background-color: #ffffff; /* 白色背景 */
            border-radius: 12px; /* 调整圆角 */
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); /* 调整阴影 */
            padding: 40px; /* 内部填充 */
            max-width: 960px; /* 稍微增加最大宽度 */
            width: 100%;
            margin-top: 20px; /* 顶部留白 */
            margin-bottom: 20px; /* 底部留白 */
        }

        /* 页面标题 */
        .section-title {
            color: #0056b3; /* 深蓝色标题 */
            font-weight: 700; /* 加粗 */
            margin-bottom: 30px; /* 增加下方间距 */
            text-align: center;
            font-size: 2.2rem; /* 增加字体大小 */
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

        /* 卡片样式优化 - 调整为类似index.jsp的卡片风格 */
        /* 包含 info-card, records-card, content-card (用于其他页面) */
        .info-card, .records-card, .content-card {
            border: 1px solid #d0d0d0; /* 添加边框 */
            border-radius: 12px; /* 调整圆角 */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05); /* 调整阴影 */
            margin-bottom: 30px; /* 卡片间距 */
            overflow: hidden; /* 确保内容不溢出圆角 */
            background-color: #ffffff; /* 确保背景色 */
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

        /* 表格样式 (保留，如果需要) */
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
            border-radius: 8px; /* 调整圆角 */
            padding: 10px 25px; /* 调整内边距 */
            font-size: 1.1rem; /* 增加字体大小 */
            font-weight: 600;
            transition: all 0.3s ease; /* 添加过渡效果 */
        }

        .btn-primary {
             background-color: #007bff;
             border-color: #007bff;
         }

         .btn-primary:hover {
             background-color: #0056b3;
             border-color: #0056b3;
             transform: translateY(-2px); /* 调整悬停上移距离 */
             box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 调整阴影 */
         }

         .btn-secondary {
             background-color: #6c757d;
             border-color: #6c757d;
         }

         .btn-secondary:hover {
             background-color: #5a6268;
             border-color: #545b62;
             transform: translateY(-2px); /* 调整悬停上移距离 */
             box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 调整阴影 */
         }

         .btn-outline-danger {
             border-color: #dc3545;
             color: #dc3545;
         }

         .btn-outline-danger:hover {
             background-color: #dc3545;
             color: white;
             transform: translateY(-2px); /* 调整悬停上移距离 */
             box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 调整阴影 */
         }

         /* 导航栏样式 (保留，如果需要) */
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
             }
             .section-title {
                 font-size: 1.8rem; /* 减小小屏幕标题字体 */
                 margin-bottom: 20px;
             }
             .button-group .btn {
                 margin: 5px; /* 减小小屏幕按钮间距 */
                 width: auto; /* 按钮宽度自适应 */
                 display: inline-block; /* 保持行内块显示 */
             }
             .nav-tabs .nav-link {
                 padding: 8px 15px; /* 减小小屏幕导航内边距 */
                 font-size: 0.9rem;
             }
             .table th, .table td {
                 padding: 8px 10px; /* 减小小屏幕表格内边距 */
             }
         }

         /* 项目列表特定样式 - 调整为卡片风格 */
         .project-list .activity-card { /* 使用activity-card样式 */
             margin-bottom: 15px; /* 调整卡片间距 */
             text-decoration: none; /* 移除链接下划线 */
             color: inherit; /* 继承父元素颜色 */
             border: 1px solid #d0d0d0; /* 添加边框 */
             border-radius: 10px; /* 调整圆角 */
             box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); /* 调整阴影 */
             transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out; /* 添加过渡效果 */
         }

         .project-list .activity-card:hover {
             transform: translateY(-3px); /* 向上微移 */
             box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1); /* 增大阴影 */
         }

         .activity-icon-container { /* 借鉴index.jsp的图标容器样式 */
             width: 50px; /* 调整大小 */
             height: 50px; /* 调整大小 */
             border-radius: 50%; /* 圆形 */
             background-color: #e9ecef;
             display: flex;
             flex-direction: column;
             align-items: center;
             justify-content: center;
             padding: 5px;
             flex-shrink: 0;
             margin-right: 15px; /* 调整间距 */
         }

         .activity-icon-container i {
             color: #28a745; /* 调整图标颜色 */
             font-size: 1.5rem; /* 调整图标大小 */
         }

         .activity-category-label { /* 借鉴index.jsp的标签样式 */
             font-size: 0.6rem; /* 调整字体大小 */
             color: #6c757d;
             margin-top: 2px; /* 调整间距 */
         }

         .activity-details h6 { /* 调整标题样式 */
             margin-bottom: 0.25rem !important;
             color: #007bff; /* 调整颜色 */
             font-weight: bold;
         }

         .activity-details p { /* 调整文本样式 */
             margin-bottom: 0.1rem !important;
             line-height: 1.3;
             color: #555;
         }

         .activity-details .project-meta span {
             margin-right: 15px; /* 调整meta信息间距 */
         }

     </style>
</head>
<body>
<jsp:include page="common/navbar.jsp" />

<div class="main-container">
    <h2 class="section-title">志愿服务项目列表</h2>

    <%-- 错误消息 --%>
    <% if (errorMsg != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= errorMsg %>
        </div>
    <% } %>

    <!-- Project List Card -->
    <div class="card content-card">
        <div class="card-header"> <%-- 添加卡片头部 --%>
            <h5>所有项目</h5>
        </div>
        <div class="card-body">
            <% if (projects.isEmpty()) { %>
                <p class="text-center text-muted">暂无志愿服务项目。</p>
            <% } else { %>
                <div class="project-list">
                    <% for (Map<String, Object> project : projects) { %>
                        <%-- 将每个项目渲染为可点击的卡片 --%>
                        <a href="signup_project.jsp?project_id=<%= project.get("id") %>" class="card activity-card mb-3">
                            <div class="card-body d-flex align-items-start">
                                <div class="activity-icon-container me-3">
                                    <i class="fas fa-clipboard-list"></i> <%-- 使用项目相关的图标 --%>
                                    <small class="activity-category-label text-center">项目</small> <%-- 添加标签 --%>
                                </div>
                                <div class="activity-details flex-grow-1">
                                    <h6 class="card-title mb-1"><%= project.get("name") %></h6>
                                    <p class="card-text text-muted mb-1" style="font-size: 0.9em;"><%= project.get("description") %></p>
                                    <p class="card-text project-meta mb-1" style="font-size: 0.85em;">
                                        <span><i class="fas fa-coins me-1"></i>预计获得积分: <%= project.get("points") %></span>
                                        <span><i class="fas fa-user me-1"></i>发布者: <%= project.get("publisher") %></span>
                                    </p>
                                     <p class="card-text mb-0" style="font-size: 0.85em;">
                                        <i class="far fa-calendar-alt me-1"></i>时间: <%= project.get("start_time") %> - <%= project.get("end_time") %>
                                    </p>
                                </div>
                            </div>
                        </a>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <div class="button-group">
        <a href="index.jsp" class="btn btn-secondary"><i class="fas fa-home me-2"></i>返回首页</a>
        <a href="service_records.jsp" class="btn btn-primary"><i class="fas fa-list-alt me-2"></i>我的服务记录</a>
        <a href="logout.jsp" class="btn btn-outline-danger"><i class="fas fa-sign-out-alt me-2"></i>退出登录</a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>