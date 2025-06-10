<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.example.volunteersystem.JDBCUtil" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    List<Map<String, Object>> signupList = new ArrayList<>();
    try (Connection conn = JDBCUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(
            "SELECT s.id, u.username, u.realname, p.name AS project_name, p.points, s.status " +
            "FROM signup s " +
            "JOIN user u ON s.user_id = u.id " +
            "JOIN project p ON s.project_id = p.id " +
            "ORDER BY s.status ASC, s.id DESC")) {
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("username", rs.getString("username"));
                row.put("realname", rs.getString("realname"));
                row.put("project_name", rs.getString("project_name"));
                row.put("points", rs.getInt("points"));
                row.put("status", rs.getInt("status"));
                signupList.add(row);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>报名管理 - 管理员后台</title>
    <link rel="icon" href="image/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-container {
            max-width: 1100px;
            margin: 40px auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            padding: 35px 30px;
        }
        .section-title {
            font-size: 1.5rem;
            font-weight: bold;
            color: #ff9800;
            margin-bottom: 25px;
            text-align: center;
        }
        .table thead {
            background: linear-gradient(45deg, #fffde4 0%, #ffe9c7 100%);
        }
        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }
        .action-btn {
            border-radius: 20px;
            padding: 3px 18px;
            font-size: 0.95rem;
            background: linear-gradient(45deg, #28a745, #20c997);
            color: #fff;
            border: none;
        }
        .action-btn:disabled {
            background: #ccc;
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="section-title">
        <i class="fas fa-check-double me-2"></i>报名记录管理
    </div>
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>姓名</th>
                <th>活动名称</th>
                <th>活动积分</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
        <% for (Map<String, Object> row : signupList) { %>
            <tr>
                <td><%= row.get("id") %></td>
                <td><%= row.get("username") %></td>
                <td><%= row.get("realname") %></td>
                <td><%= row.get("project_name") %></td>
                <td><%= row.get("points") %></td>
                <td>
                    <% if ((int)row.get("status") == 1) { %>
                        <span class="badge bg-success">已完成</span>
                    <% } else { %>
                        <span class="badge bg-warning text-dark">未完成</span>
                    <% } %>
                </td>
                <td>
                    <form action="admin_signup_action.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="signupId" value="<%= row.get("id") %>">
                        <input type="hidden" name="username" value="<%= row.get("username") %>">
                        <input type="hidden" name="points" value="<%= row.get("points") %>">
                        <button name="action" value="finish" class="action-btn" type="submit" <% if ((int)row.get("status") == 1) { %>disabled<% } %>>
                            确认完成
                        </button>
                    </form>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
    <div class="text-center mt-4">
        <a href="admin_dashboard.jsp" class="btn btn-outline-warning"><i class="fas fa-arrow-left me-1"></i>返回后台首页</a>
    </div>
</div>
</body>
</html>