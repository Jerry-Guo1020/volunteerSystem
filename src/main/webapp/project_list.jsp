<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    String username = (String) session.getAttribute("username");
    List<Map<String, Object>> projects = new ArrayList<>();
    String errorMsg = null;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = JDBCUtil.getConnection();
        ps = conn.prepareStatement("SELECT id, name, description, points, publisher, start_time, end_time FROM project ORDER BY start_time DESC");
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> project = new HashMap<>();
            project.put("id", rs.getInt("id"));
            project.put("name", rs.getString("name"));
            project.put("description", rs.getString("description"));
            project.put("points", rs.getInt("points"));
            project.put("publisher", rs.getString("publisher"));
            project.put("start_time", rs.getTimestamp("start_time"));
            project.put("end_time", rs.getTimestamp("end_time"));
            projects.add(project);
        }

    } catch (SQLException e) {
        errorMsg = "加载项目列表失败：" + e.getMessage();
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
    <title>志愿服务项目列表 - 志愿者服务平台</title>
    <link rel="icon" href="image/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 30px 15px;
            box-sizing: border-box;
        }

        .main-container {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 40px;
            max-width: 1200px;
            width: 100%;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .section-title {
            color: #0056b3;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
            font-size: 2.2rem;
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

        .filter-group {
            margin-bottom: 20px;
            text-align: center;
        }

        .filter-group .btn {
            margin-right: 10px;
            margin-bottom: 10px;
        }

        .project-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .activity-card {
            text-decoration: none;
            color: inherit;
            border: 1px solid #d0d0d0;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            background-color: #fff;
            padding: 15px;
        }

        .activity-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
        }

        .activity-icon-container {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #e9ecef;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 5px;
            flex-shrink: 0;
            margin-bottom: 10px;
        }

        .activity-icon-container i {
            color: #28a745;
            font-size: 1.5rem;
        }

        .activity-details h6 {
            margin-bottom: 0.25rem !important;
            color: #007bff;
            font-weight: bold;
        }

        .activity-details p {
            margin-bottom: 0.1rem !important;
            line-height: 1.3;
            color: #555;
        }

        .activity-details .project-meta span {
            margin-right: 15px;
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 20px;
            }
            .section-title {
                font-size: 1.8rem;
                margin-bottom: 20px;
            }
            .filter-group .btn {
                margin: 5px;
                width: auto;
                display: inline-block;
            }
        }
    </style>
</head>
<body>
<jsp:include page="common/navbar.jsp" />

<div class="main-container">
    <h2 class="section-title">志愿服务项目列表</h2>

    <div class="filter-group">
        <button class="btn btn-outline-secondary">全部</button>
        <button class="btn btn-outline-secondary">志愿服务</button>
        <button class="btn btn-outline-secondary">志愿培训活动</button>
        <!-- Add more filter buttons as needed -->
    </div>

    <% if (errorMsg != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= errorMsg %>
        </div>
    <% } %>

    <div class="project-list">
        <% if (projects.isEmpty()) { %>
            <p class="text-center text-muted">暂无志愿服务项目。</p>
        <% } else { %>
            <% for (Map<String, Object> project : projects) { %>
                <div class="activity-card">
                    <div class="activity-icon-container">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <div class="activity-details">
                        <h6 class="card-title mb-1"><%= project.get("name") %></h6>
                        <p class="card-text text-muted mb-1" style="font-size: 0.9em;"><%= project.get("description") %></p>
                        <p class="card-text project-meta mb-1" style="font-size: 0.85em;">
                            <span><i class="fas fa-coins me-1"></i>积分: <%= project.get("points") %></span>
                            <span><i class="fas fa-user me-1"></i>发布者: <%= project.get("publisher") %></span>
                        </p>
                        <p class="card-text mb-0" style="font-size: 0.85em;">
                            <i class="far fa-calendar-alt me-1"></i>时间: <%= project.get("start_time") %> - <%= project.get("end_time") %>
                        </p>
                        <a href="join_project.jsp?project_id=<%= project.get("id") %>" class="btn btn-success mt-2">加入活动</a>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>