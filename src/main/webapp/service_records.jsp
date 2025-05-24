<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("../login.jsp"); // 注意路径调整
        return;
    }
    // 可以选择在这里再次查询积分，或者只查询服务记录
    // int points = 0; // 如果需要显示积分
    String errorMsg = null;
    ResultSet rs = null;
    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = JDBCUtil.getConnection();
        ps = conn.prepareStatement(
                "SELECT p.name, p.description, p.points, s.signup_time, s.completed " +
                        "FROM signup s JOIN user u ON s.user_id=u.id " +
                        "JOIN project p ON s.project_id=p.id " +
                        "WHERE u.username=? ORDER BY s.signup_time DESC");
        ps.setString(1, username);
        rs = ps.executeQuery();

    } catch (Exception e) {
        errorMsg = "加载报名记录失败：" + e.getMessage();
        e.printStackTrace();
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
            margin-bottom: 30px; /* 卡片间距 */
        }

        .info-card .card-body, .content-card .card-body {
            padding: 25px; /* 调整内边距 */
        }

        .info-card h4 {
            margin-bottom: 15px;
        }

        .badge-success {
            background-color: #28a745 !important; /* Bootstrap success color */
        }

        /* 表格样式 */
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
            <a class="nav-link" href="messages.jsp">消息通知</a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="service_records.jsp">服务记录</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="reviews.jsp">收到评价</a>
        </li>
    </ul>

    <!-- Service Records Card -->
    <div class="card content-card">
        <div class="card-header">
            <h5>我的志愿服务记录</h5>
        </div>
        <div class="card-body">
            <% if (errorMsg != null) { %>
            <div class="alert alert-danger"><%= errorMsg %></div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-striped table-hover table-bordered">
                    <thead class="table-light">
                    <tr>
                        <th>项目名称</th>
                        <th>描述</th>
                        <th>获得积分</th>
                        <th>报名时间</th>
                        <th>是否完成</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        boolean hasRecord = false;
                        if (rs != null) {
                            while (rs.next()) {
                                hasRecord = true;
                    %>
                    <tr>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("description") %></td>
                        <td><%= rs.getInt("points") %></td>
                        <td><%= rs.getTimestamp("signup_time") %></td>
                        <td><%= rs.getBoolean("completed") ? "已完成" : "未完成" %></td>
                    </tr>
                    <%
                            }
                        }
                        if (!hasRecord) {
                    %>
                    <tr><td colspan="5" class="text-center text-muted">暂无志愿服务记录</td></tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
            <% } %>
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
<%
    // 关闭数据库资源
    try { if (rs != null) rs.close(); } catch (SQLException ignore) {}
    try { if (ps != null) ps.close(); } catch (SQLException ignore) {}
    try { if (conn != null) conn.close(); } catch (SQLException ignore) {}
%>