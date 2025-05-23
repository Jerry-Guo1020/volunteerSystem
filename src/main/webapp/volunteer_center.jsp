<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int points = 0;
    String errorMsg = null;
    try (Connection conn = JDBCUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT points FROM user WHERE username=?")) {
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                points = rs.getInt("points");
            }
        }
    } catch (Exception e) {
        errorMsg = "获取积分失败：" + e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>个人中心 - 志愿者服务平台</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar {
            background-color: #fff;
            padding-top: 20px;
            border-right: 1px solid #dee2e6;
        }
        .sidebar a {
            display: block;
            padding: 10px 20px;
            color: #333;
            text-decoration: none;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: #f1f1f1;
            color: #007bff;
        }
        /* 添加卡片样式 */
        .card {
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }
        .card-header {
            background-color: #e9ecef;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-2 sidebar">
            <h5 class="text-center">我的中心</h5>
            <a href="#" class="active">个人信息</a>
            <a href="#">我的消息</a>
            <a href="#">志愿日程</a>
            <a href="#">服务记录</a>
            <a href="#">我的收藏</a>
        </div>

        <!-- Main Content -->
        <div class="col-md-10">
            <div class="p-4">
                <!-- Welcome Card -->
                <div class="card mb-4">
                    <div class="card-body">
                        <h4>欢迎，<%= username %>！</h4>
                        <p>当前积分：<span class="badge bg-success"><%= points %></span></p>
                        <% if (errorMsg != null) { %>
                        <div class="alert alert-danger"><%= errorMsg %></div>
                        <% } %>
                    </div>
                </div>

                <!-- Service Records Card -->
                <div class="card">
                    <div class="card-header">
                        <h5>我的志愿服务记录</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-bordered">
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
                                try (Connection conn = JDBCUtil.getConnection();
                                     PreparedStatement ps = conn.prepareStatement(
                                             "SELECT p.name, p.description, p.points, s.signup_time, s.completed " +
                                                     "FROM signup s JOIN user u ON s.user_id=u.id " +
                                                     "JOIN project p ON s.project_id=p.id " +
                                                     "WHERE u.username=? ORDER BY s.signup_time DESC")) {
                                    ps.setString(1, username);
                                    try (ResultSet rs = ps.executeQuery()) {
                                        boolean hasRecord = false;
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
                                        if (!hasRecord) {
                            %>
                            <tr><td colspan="5" class="text-center">暂无志愿服务记录</td></tr>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                            %>
                            <tr><td colspan="5" class="text-danger">加载报名记录失败：<%= e.getMessage() %></td></tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="mt-4">
                    <a href="index.jsp" class="btn btn-secondary">返回首页</a>
                    <a href="project_list.jsp" class="btn btn-primary ms-2">浏览志愿服务项目</a>
                    <a href="logout.jsp" class="btn btn-outline-danger ms-2">退出登录</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
