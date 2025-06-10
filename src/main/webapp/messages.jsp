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

    List<Map<String, Object>> messages = new ArrayList<>();
    String errorMsg = null;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = JDBCUtil.getConnection();
        ps = conn.prepareStatement("SELECT sender, content, send_time FROM messages WHERE recipient=? ORDER BY send_time DESC");
        ps.setString(1, username);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> message = new HashMap<>();
            message.put("sender", rs.getString("sender"));
            message.put("content", rs.getString("content"));
            message.put("send_time", rs.getTimestamp("send_time"));
            messages.add(message);
        }

    } catch (SQLException e) {
        errorMsg = "加载消息失败：" + e.getMessage();
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
    <title>消息中心 - 志愿者服务平台</title>
    <link rel="icon" href="image/logo.png" type="image/x-icon">
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

        .message-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease-in-out;
            margin-bottom: 20px;
        }

        .message-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }

        .message-card .card-body {
            padding: 15px;
        }

        .message-card .card-title {
            font-size: 1.1rem;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .message-card .card-text {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 10px;
        }

        .message-card .send-time {
            font-size: 0.8rem;
            color: #999;
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
            <a href="service_records.jsp" class="list-group-item list-group-item-action">
                <i class="fas fa-clipboard-list"></i> 服务记录
            </a>
            <a href="points_mall.jsp" class="list-group-item list-group-item-action">
                <i class="fas fa-store"></i> 积分商城
            </a>
            <a href="messages.jsp" class="list-group-item list-group-item-action active">
                <i class="fas fa-envelope"></i> 消息中心
            </a>
        </div>
    </div>

    <div class="content-area">
        <h2 class="section-title">消息中心</h2>

        <% if (errorMsg != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= errorMsg %>
            </div>
        <% } %>

        <% if (messages.isEmpty()) { %>
            <p class="text-center text-muted">暂无消息。</p>
        <% } else { %>
            <% for (Map<String, Object> message : messages) { %>
                <div class="card message-card">
                    <div class="card-body">
                        <h5 class="card-title">来自: <%= message.get("sender") %></h5>
                        <p class="card-text"><%= message.get("content") %></p>
                        <p class="send-time">发送时间: <%= message.get("send_time") %></p>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>