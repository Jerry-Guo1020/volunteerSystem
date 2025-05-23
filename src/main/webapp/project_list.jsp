<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>志愿服务项目列表</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #fafafa;
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
        }
        .project-card {
            border: 1px solid #eee;
            border-radius: 10px;
            background-color: #fff;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }
        .project-card h5 {
            color: #333;
        }

        .project-card:hover {
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
        }
        .project-meta {
            font-size: 14px;
            color: #777;
        }
        .btn-apply {
            background-color: #ff6b6b;
            border: none;
            color: white;
        }
        .btn-apply:hover {
            background-color: #ff4c4c;
        }
        .activity-types {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            margin-bottom: 40px;
            transition: all 0.3s ease;

        }

        .activity-types:hover {
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
        }

        .activity-types h5 {
            color: #f44336;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .activity-icon {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 80px;
            height: 80px;
            margin: 10px;
            border-radius: 12px;
            background: #fefefe;
            font-size: 12px;
            color: #333;
            text-align: center;
        }
        .activity-icon img {
            width: 36px;
            height: 36px;
            margin-bottom: 6px;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0 ">志愿服务项目</h2>
        <a href="add_project.jsp" class="btn btn-danger">发布志愿服务活动</a>
    </div>

    <!-- 活动类型图标区域 -->
    <div class="activity-types">
        <h5>活动类型</h5>
        <div class="d-flex flex-wrap">
            <div class="activity-icon">
                <i class="bi bi-house-door-fill" style="font-size: 24px;"></i>
                社区服务
            </div>
            <div class="activity-icon">
                <i class="bi bi-emoji-smile-fill" style="font-size: 24px;"></i>
                关爱青少年
            </div>
            <div class="activity-icon">
                <i class="bi bi-person-hearts" style="font-size: 24px;"></i>
                敬老助老
            </div>
            <div class="activity-icon">
                <i class="bi bi-universal-access" style="font-size: 24px;"></i>
                阳光助残
            </div>
            <div class="activity-icon">
                <i class="bi bi-tree-fill" style="font-size: 24px;"></i>
                乡村振兴
            </div>
            <div class="activity-icon">
                <i class="bi bi-recycle" style="font-size: 24px;"></i>
                生态环保
            </div>
            <!-- 继续添加更多类型 -->
        </div>
    </div>

    <div class="row">
        <%
            try {
                conn = JDBCUtil.getConnection();
                String sql = "SELECT * FROM project WHERE status='open'";
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                while (rs.next()) {
        %>
        <div class="col-md-4">
            <div class="project-card">
                <h5><%= rs.getString("name") %></h5>
                <p class="project-meta">描述：<%= rs.getString("description") %></p>
                <p class="project-meta">积分：<%= rs.getInt("points") %></p>
                <p class="project-meta">状态：<%= rs.getString("status") %></p>
                <form action="signup-servlet" method="post">
                    <input type="hidden" name="project_id" value="<%= rs.getInt("id") %>">
                    <button type="submit" class="btn btn-apply btn-sm mt-2">报名</button>
                </form>
            </div>
        </div>
        <%
            }
        } catch(Exception e) {
        %>
        <div class="col-12">
            <div class="alert alert-danger">加载失败：<%= e.getMessage() %></div>
        </div>
        <%
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (ps != null) try { ps.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        %>
    </div>

    <div class="mt-4">
        <a href="index.jsp" class="btn btn-secondary">返回首页</a>
    </div>
</div>
</body>
</html>
