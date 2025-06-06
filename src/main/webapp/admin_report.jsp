<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.example.volunteersystem.JDBCUtil" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    List<Map<String, Object>> reportList = new ArrayList<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        conn = JDBCUtil.getConnection();
         ps = conn.prepareStatement(
            "SELECT u.id, u.username, u.realname, SUM(s.hours) AS total_hours " +
            "FROM user u LEFT JOIN signup s ON u.id = s.user_id " +
            "GROUP BY u.id, u.username, u.realname ORDER BY total_hours DESC");
        rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("id", rs.getInt("id"));
            row.put("username", rs.getString("username"));
            row.put("realname", rs.getString("realname"));
            // 处理 SUM(s.hours) 可能为 NULL 的情况
            row.put("total_hours", rs.getObject("total_hours") == null ? 0.0 : rs.getDouble("total_hours"));
            reportList.add(row);
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
    <title>报表统计 - 管理员后台</title>
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
            max-width: 900px;
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
        .export-btn {
            background: linear-gradient(45deg, #ff9800, #ffc107);
            color: #fff;
            border: none;
            border-radius: 20px;
            padding: 7px 28px;
            font-size: 1rem;
            font-weight: bold;
            margin-bottom: 18px;
            transition: background 0.2s, box-shadow 0.2s;
        }
        .export-btn:hover {
            background: linear-gradient(45deg, #ffc107, #ff9800);
            box-shadow: 0 4px 16px rgba(255,193,7,0.18);
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="section-title">
        <i class="fas fa-chart-bar me-2"></i>志愿服务时长统计报表
    </div>
    <div class="text-end">
        <form action="admin_report_export.jsp" method="post" style="display:inline;">
            <button type="submit" class="export-btn"><i class="fas fa-file-export me-1"></i>导出报表</button>
        </form>
    </div>
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>姓名</th>
                <th>累计服务时长（小时）</th>
            </tr>
        </thead>
        <tbody>
        <% for (Map<String, Object> row : reportList) { %>
            <tr>
                <td><%= row.get("id") %></td>
                <td><%= row.get("username") %></td>
                <td><%= row.get("realname") != null ? row.get("realname") : "N/A" %></td> <%-- 处理realname可能为null的情况 --%>
                <td><%= row.get("total_hours") %></td>
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