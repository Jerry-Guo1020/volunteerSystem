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

    int userPoints = 0;
    List<Map<String, Object>> allItems = new ArrayList<>();
    String errorMsg = null;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = JDBCUtil.getConnection();

        ps = conn.prepareStatement("SELECT points FROM user WHERE username=?");
        ps.setString(1, username);
        rs = ps.executeQuery();
        if (rs.next()) {
            userPoints = rs.getInt("points");
        }
        rs.close();
        ps.close();

        ps = conn.prepareStatement("SELECT id, name, description, points_cost, image_url FROM mall_items");
        rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", rs.getInt("id"));
            item.put("name", rs.getString("name"));
            item.put("description", rs.getString("description"));
            item.put("points_cost", rs.getInt("points_cost"));
            item.put("image_url", rs.getString("image_url").replaceAll("/$", "")); // 移除路径末尾的斜杠
            allItems.add(item);
        }

    } catch (SQLException e) {
        errorMsg = "加载商品信息失败：" + e.getMessage();
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
    <title>积分商城 - 志愿者服务平台</title>
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

        .points-info-card {
            background: linear-gradient(to right, #ffc107, #ff9800);
            color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .points-info-card h4 {
            color: white;
            margin-bottom: 10px;
        }

        .points-info-card .badge {
            background-color: rgba(255, 255, 255, 0.3);
            color: white;
            font-size: 1.2rem;
            padding: 0.5em 0.75em;
        }

        .item-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease-in-out;
            height: 100%;
        }

        .item-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }

        .item-card img {
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            height: 180px;
            object-fit: cover;
        }

        .item-card .card-body {
            padding: 15px;
        }

        .item-card .card-title {
            font-size: 1.1rem;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .item-card .card-text {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 10px;
        }

        .item-card .points-cost {
            font-size: 1rem;
            font-weight: bold;
            color: #ff9800;
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
            .item-card img {
                height: 150px;
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
            <a href="points_mall.jsp" class="list-group-item list-group-item-action active">
                <i class="fas fa-store"></i> 积分商城
            </a>
            <a href="messages.jsp" class="list-group-item list-group-item-action">
                <i class="fas fa-envelope"></i> 消息中心
            </a>
        </div>
    </div>

    <div class="content-area">
        <h2 class="section-title">积分商城</h2>

        <div class="points-info-card">
            <h4>我的当前积分</h4>
            <h1><span class="badge bg-light text-warning"><i class="fas fa-coins me-2"></i><%= userPoints %></span></h1>
        </div>

        <div class="row">
            <% if (allItems.isEmpty()) { %>
                <p class="text-center text-muted">暂无可兑换商品。</p>
            <% } else { %>
                <% for (Map<String, Object> item : allItems) { %>
                    <div class="col-md-4 mb-4">
                        <div class="card item-card">
                            <img src="<%= item.get("image_url") %>" class="card-img-top" alt="商品图片">
                            <div class="card-body">
                                <h5 class="card-title"><%= item.get("name") %></h5>
                                <p class="card-text"><%= item.get("description") %></p>
                                <p class="points-cost">所需积分: <%= item.get("points_cost") %></p>
                                <%
                                String redeemMsg = request.getParameter("redeemMsg");
                                if (redeemMsg != null) {
                                %>
                                <div class="alert alert-info" role="alert">
                                    <%= redeemMsg %>
                                </div>
                                <%
                                }
                                %>
                                <a href="redeem_item.jsp?item_id=<%= item.get("id") %>&points_cost=<%= item.get("points_cost") %>" class="btn btn-primary">兑换</a>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>