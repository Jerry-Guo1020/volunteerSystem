<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员后台 - 志愿者服务平台</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .dashboard-container {
            max-width: 900px;
            margin: 60px auto;
            padding: 40px 30px;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        }
        .dashboard-title {
            font-size: 2rem;
            font-weight: bold;
            color: #ff9800;
            text-align: center;
            margin-bottom: 30px;
        }
        .dashboard-menu {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
        }
        .dashboard-card {
            flex: 1 1 220px;
            min-width: 220px;
            max-width: 260px;
            background: linear-gradient(135deg, #fffde4 0%, #ffe9c7 100%);
            border-radius: 15px;
            box-shadow: 0 4px 16px rgba(255,193,7,0.08);
            padding: 30px 20px;
            text-align: center;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .dashboard-card:hover {
            transform: translateY(-6px) scale(1.03);
            box-shadow: 0 8px 24px rgba(255,193,7,0.18);
        }
        .dashboard-card i {
            font-size: 2.5rem;
            color: #ff9800;
            margin-bottom: 15px;
        }
        .dashboard-card h5 {
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }
        .dashboard-card p {
            color: #666;
            font-size: 0.98rem;
        }
        .logout-link {
            display: block;
            text-align: right;
            margin-top: 20px;
        }
        .logout-link a {
            color: #ff9800;
            font-weight: bold;
            text-decoration: none;
        }
        .logout-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <div class="dashboard-title">
        <i class="fas fa-user-shield me-2"></i>管理员后台
    </div>
    <div class="dashboard-menu">
        <a href="admin_user_manage.jsp" class="dashboard-card text-decoration-none">
            <i class="fas fa-users-cog"></i>
            <h5>用户管理</h5>
            <p>启用/禁用用户、权限管理、信息检索</p>
        </a>
        <a href="admin_project_manage.jsp" class="dashboard-card text-decoration-none">
            <i class="fas fa-tasks"></i>
            <h5>活动管理</h5>
            <p>活动审批、修改、删除、统计</p>
        </a>
        <a href="admin_report.jsp" class="dashboard-card text-decoration-none">
            <i class="fas fa-chart-bar"></i>
            <h5>报表统计</h5>
            <p>服务时长统计、报表导出</p>
        </a>
    </div>
    <div class="logout-link">
        <a href="admin_logout.jsp"><i class="fas fa-sign-out-alt me-1"></i>退出登录</a>
    </div>
</div>
</body>
</html>