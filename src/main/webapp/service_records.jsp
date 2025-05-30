<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp"); // 假设login.jsp在同一目录下
        return;
    }

    List<Map<String, Object>> serviceRecords = new ArrayList<>();
    String errorMsg = null;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = JDBCUtil.getConnection();
        // 获取当前用户的服务记录
        ps = conn.prepareStatement(
                "SELECT p.name, p.description, p.points, s.signup_time, s.completed " +
                "FROM signup s JOIN user u ON s.user_id=u.id " +
                "JOIN project p ON s.project_id=p.id " +
                "WHERE u.username=? ORDER BY s.signup_time DESC");
        ps.setString(1, username);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> record = new HashMap<>();
            record.put("name", rs.getString("name"));
            record.put("description", rs.getString("description"));
            record.put("points", rs.getInt("points"));
            record.put("signup_time", rs.getTimestamp("signup_time"));
            record.put("completed", rs.getBoolean("completed"));
            serviceRecords.add(record);
        }

    } catch (SQLException e) {
        errorMsg = "加载服务记录失败：" + e.getMessage();
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
    <title>服务记录 - 志愿者服务平台</title>
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

         /* 服务记录特定样式 */
         .service-record-item {
             border-bottom: 1px solid #eee;
             padding: 15px 0;
         }
         .service-record-item:last-child {
             border-bottom: none;
         }
         .service-record-item .record-project {
             font-weight: bold;
             color: #007bff;
             margin-bottom: 5px;
         }
         .service-record-item .record-meta {
             font-size: 0.9rem;
             color: #888;
             margin-bottom: 5px;
         }
         .service-record-item .record-status {
             font-size: 0.9rem;
             font-weight: bold;
         }
         .status-completed {
             color: #28a745; /* Green */
         }
         .status-pending {
             color: #ffc107; /* Yellow */
         }

    </style>
</head>
<body>
<jsp:include page="common/navbar.jsp" />

<div class="main-container">
    <h2 class="section-title">我的服务记录</h2>

    <%-- 错误消息 --%>
    <% if (errorMsg != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= errorMsg %>
        </div>
    <% } %>

    <!-- Service Records Card -->
    <div class="card records-card">
        <div class="card-header">
            服务记录列表
        </div>
        <div class="card-body">
            <% if (serviceRecords.isEmpty()) { %>
                <p class="text-center text-muted">暂无服务记录。</p>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>项目名称</th>
                                <th>项目描述</th>
                                <th>获得积分</th>
                                <th>报名时间</th>
                                <th>状态</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> record : serviceRecords) { %>
                                <tr>
                                    <td><%= record.get("name") %></td>
                                    <td><%= record.get("description") %></td>
                                    <td><%= record.get("points") %></td>
                                    <td><%= record.get("signup_time") %></td>
                                    <td>
                                        <% if ((Boolean) record.get("completed")) { %>
                                            <span class="badge bg-success">已完成</span>
                                        <% } else { %>
                                            <span class="badge bg-warning text-dark">进行中</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <div class="button-group">
        <a href="index.jsp" class="btn btn-secondary"><i class="fas fa-home me-2"></i>返回首页</a>
        <a href="project_list.jsp" class="btn btn-primary"><i class="fas fa-list me-2"></i>查看项目列表</a>
        <a href="logout.jsp" class="btn btn-outline-danger"><i class="fas fa-sign-out-alt me-2"></i>退出登录</a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>