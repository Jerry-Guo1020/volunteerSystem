<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> serviceRecords = new ArrayList<>();
    String errorMsg = null;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = JDBCUtil.getConnection();
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
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e0f7fa 0%, #b2ebf2 100%);
            min-height: 100vh;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 30px 15px;
            box-sizing: border-box;
        }

        .main-container {
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
            padding: 40px;
            max-width: 1500px;
            width: 100%;
            margin-top: 10px;
            margin-bottom: 10px;
            display: flex;
        }

        .section-title {
            color: #0056b3;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
            font-size: 2rem;
            position: relative;
        }

        .section-title::after {
            content: '';
            display: block;
            width: 60px;
            height: 4px;
            background-color: #007bff;
            margin: 10px auto 0;
            border-radius: 2px;
        }

        .sidebar {
            width: 250px;
            margin-right: 30px;
            flex-shrink: 0;
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

        .content-area {
            flex-grow: 1;
        }

        .records-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
            overflow: hidden;
        }

        .records-card .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            padding: 15px 30px;
            font-size: 1.2rem;
            font-weight: bold;
            color: #495057;
        }

        .table {
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0 8px;
        }

        .table th, .table td {
            vertical-align: middle;
            padding: 12px 15px;
            border-top: 1px solid #dee2e6;
        }

        .table thead th {
            background-color: #e9ecef;
            border-bottom: 2px solid #dee2e6;
            font-weight: bold;
            color: #495057;
        }

        .table tbody tr {
             background-color: #fff;
             transition: all 0.2s ease-in-out;
        }

        .table tbody tr:hover {
             background-color: #f1f1f1;
        }

        .table-bordered th, .table-bordered td {
            border: 1px solid #dee2e6;
        }

        .table-bordered thead th {
             border-bottom-width: 2px;
        }

        .button-group {
            text-align: center;
            margin-top: 40px;
        }

        .button-group .btn {
            margin: 0 15px;
            border-radius: 30px;
            padding: 10px 25px;
            font-size: 1.1rem;
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
             transform: translateY(-3px);
             box-shadow: 0 6px 12px rgba(0, 123, 255, 0.3);
         }

         .btn-secondary {
             background-color: #6c757d;
             border-color: #6c757d;
         }

         .btn-secondary:hover {
             background-color: #5a6268;
             border-color: #545b62;
             transform: translateY(-3px);
             box-shadow: 0 6px 12px rgba(108, 117, 125, 0.3);
         }

         .btn-outline-danger {
             border-color: #dc3545;
             color: #dc3545;
         }

         .btn-outline-danger:hover {
             background-color: #dc3545;
             color: white;
             transform: translateY(-3px);
             box-shadow: 0 6px 12px rgba(220, 53, 69, 0.3);
         }

         @media (max-width: 768px) {
             .main-container {
                 padding: 20px;
                 flex-direction: column;
             }
             .section-title {
                 font-size: 1.8rem;
                 margin-bottom: 20px;
             }
             .sidebar {
                 width: 100%;
                 margin-right: 0;
                 margin-bottom: 20px;
             }
             .content-area {
                 width: 100%;
             }
         }
    </style>
</head>
<body>
<jsp:include page="common/navbar.jsp" />

<div class="main-container">
    <div class="sidebar">
        <div class="list-group">
            <a href="volunteer_center.jsp" class="list-group-item list-group-item-action">
                <i class="fas fa-user-circle"></i> 个人信息
            </a>
            <a href="service_records.jsp" class="list-group-item list-group-item-action active">
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
        <h2 class="section-title">服务记录</h2>

        <% if (errorMsg != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= errorMsg %>
            </div>
        <% } %>

        <div class="records-card">
            <div class="card-header">
                我的服务记录
            </div>
            <div class="card-body">
                <% if (serviceRecords.isEmpty()) { %>
                    <p class="text-center text-muted">暂无服务记录。</p>
                <% } else { %>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>项目名称</th>
                                <th>描述</th>
                                <th>积分</th>
                                <th>报名时间</th>
                                <th>完成状态</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> record : serviceRecords) { %>
                                <tr>
                                    <td><%= record.get("name") %></td>
                                    <td><%= record.get("description") %></td>
                                    <td><%= record.get("points") %></td>
                                    <td><%= record.get("signup_time") %></td>
                                    <td><%= (Boolean) record.get("completed") ? "已完成" : "未完成" %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
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