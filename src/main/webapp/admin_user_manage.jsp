<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.example.volunteersystem.JDBCUtil" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    String search = request.getParameter("search");
    List<Map<String, Object>> users = new ArrayList<>();
    try (Connection conn = JDBCUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(
            "SELECT id, username, realname, status, role FROM user WHERE username LIKE ? OR realname LIKE ?")) {
        String key = search == null ? "%" : "%" + search + "%";
        ps.setString(1, key);
        ps.setString(2, key);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getInt("id"));
                user.put("username", rs.getString("username"));
                user.put("realname", rs.getString("realname"));
                user.put("status", rs.getInt("status"));
                user.put("role", rs.getString("role"));
                users.add(user);
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
    <title>用户管理 - 管理员后台</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-container {
            max-width: 1000px;
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
        .search-bar {
            max-width: 350px;
            margin: 0 auto 25px auto;
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
        }
        .action-btn.enable {
            background: linear-gradient(45deg, #4caf50, #43a047);
            color: #fff;
            border: none;
        }
        .action-btn.disable {
            background: linear-gradient(45deg, #f44336, #e53935);
            color: #fff;
            border: none;
        }
        .action-btn.role {
            background: linear-gradient(45deg, #ff9800, #ffc107);
            color: #fff;
            border: none;
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="section-title">
        <i class="fas fa-users-cog me-2"></i>用户管理
    </div>
    <form class="search-bar mb-3" method="get">
        <div class="input-group">
            <input type="text" class="form-control" name="search" placeholder="输入用户名或姓名检索" value="<%= search == null ? "" : search %>">
            <button class="btn btn-warning" type="submit"><i class="fas fa-search"></i> 检索</button>
        </div>
    </form>
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>姓名</th>
                <th>状态</th>
                <th>角色</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
        <% for (Map<String, Object> user : users) { %>
            <tr>
                <td><%= user.get("id") %></td>
                <td><%= user.get("username") %></td>
                <td><%= user.get("realname") %></td>
                <td>
                    <% if ((int)user.get("status") == 1) { %>
                        <span class="badge bg-success">启用</span>
                    <% } else { %>
                        <span class="badge bg-secondary">禁用</span>
                    <% } %>
                </td>
                <td><%= user.get("role") %></td>
                <td>
                    <form action="admin_user_action.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="userId" value="<%= user.get("id") %>">
                        <% if ((int)user.get("status") == 1) { %>
                            <button name="action" value="disable" class="action-btn disable" type="submit">禁用</button>
                        <% } else { %>
                            <button name="action" value="enable" class="action-btn enable" type="submit">启用</button>
                        <% } %>
                        <button name="action" value="role" class="action-btn role" type="submit">修改权限</button>
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