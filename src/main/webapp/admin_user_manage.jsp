<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.example.volunteersystem.JDBCUtil" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    List<Map<String, Object>> userList = new ArrayList<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        conn = JDBCUtil.getConnection();
        // 确保这里的字段名和你的user表完全一致
        ps = conn.prepareStatement(
            "SELECT id, username, realname, email, reg_time, points, role, status FROM user ORDER BY id DESC");
        rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("id", rs.getInt("id"));
            row.put("username", rs.getString("username"));
            row.put("realname", rs.getString("realname")); // 假设user表有realname字段
            row.put("email", rs.getString("email"));
            row.put("reg_time", rs.getTimestamp("reg_time")); // 使用getTimestamp获取时间
            row.put("points", rs.getInt("points"));
            row.put("role", rs.getString("role"));
            row.put("status", rs.getInt("status"));
            userList.add(row);
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("数据库查询错误: " + e.getMessage()); // 添加错误输出
    } finally {
        JDBCUtil.close(conn, ps, rs);
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
        /* 样式与之前页面保持一致 */
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
             background: linear-gradient(45deg, #2196f3, #1976d2);
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
    <!-- 搜索框部分 (如果需要实现搜索功能) -->
    <%--
    <div class="mb-3 d-flex justify-content-center">
        <div class="input-group" style="max-width: 400px;">
            <input type="text" class="form-control" placeholder="输入用户名或姓名搜索">
            <button class="btn btn-warning" type="button"><i class="fas fa-search me-1"></i>搜索</button>
        </div>
    </div>
    --%>
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>姓名</th>
                <th>邮箱</th>
                <th>注册时间</th>
                <th>积分</th>
                <th>角色</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
        <% for (Map<String, Object> row : userList) { %>
            <tr>
                <td><%= row.get("id") %></td>
                <td><%= row.get("username") %></td>
                <td><%= row.get("realname") != null ? row.get("realname") : "NULL" %></td> <%-- 处理realname可能为null的情况 --%>
                <td><%= row.get("email") %></td>
                <td><%= row.get("reg_time") %></td>
                <td><%= row.get("points") %></td>
                <td><%= row.get("role") %></td>
                <td>
                    <%
                        Object statusObj = row.get("status");
                        int status = (statusObj instanceof Integer) ? (Integer) statusObj : 0; // 安全地获取status，如果为null或非Integer则默认为0
                        if (status == 1) {
                    %>
                        <span class="badge bg-success">启用</span>
                    <% } else { %>
                        <span class="badge bg-secondary">禁用</span>
                    <% } %>
                </td>
                <td>
                    <form action="admin_user_action.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="userId" value="<%= row.get("id") %>">
                        <%
                            Object statusObjForBtn = row.get("status");
                            int statusForBtn = (statusObjForBtn instanceof Integer) ? (Integer) statusObjForBtn : 0; // 安全地获取status
                            if (statusForBtn == 1) {
                        %>
                            <button name="action" value="disable" class="action-btn disable" type="submit">禁用</button>
                        <% } else { %>
                            <button name="action" value="enable" class="action-btn enable" type="submit">启用</button>
                        <% } %>
                        <%-- 修改权限按钮 (功能待实现) --%>
                        <button name="action" value="role" class="action-btn role" type="submit" disabled>修改权限</button>
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