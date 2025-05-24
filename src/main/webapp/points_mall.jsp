<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Random" %>
<%
    // 检查用户是否登录
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

        // 获取用户积分
        ps = conn.prepareStatement("SELECT points FROM user WHERE username=?");
        ps.setString(1, username);
        rs = ps.executeQuery();
        if (rs.next()) {
            userPoints = rs.getInt("points");
        }
        rs.close();
        ps.close();

        // 获取所有商品
        // 移除了获取精选商品的逻辑
        ps = conn.prepareStatement("SELECT id, name, description, points_cost FROM mall_items"); // 移除了 image_url 字段，因为我们将使用随机图片
        rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", rs.getInt("id"));
            item.put("name", rs.getString("name"));
            item.put("description", rs.getString("description"));
            item.put("points_cost", rs.getInt("points_cost"));
            // 不再从数据库获取 image_url
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

    // 用于生成随机图片ID
    Random random = new Random();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>积分商城 - 志愿者服务平台</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            padding-top: 20px;
            padding-bottom: 40px;
        }
        .container {
            max-width: 1200px;
        }
        .points-info-card {
            background: linear-gradient(to right, #ffc107, #ff9800); /* Yellow gradient */
            color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .points-info-card h4 {
            color: white;
            margin-bottom: 5px;
        }
        .points-info-card .points-value {
            font-size: 2.5rem;
            font-weight: bold;
        }
        .section-header {
            background-color: #007bff; /* Blue header */
            color: white;
            padding: 15px 20px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            margin-bottom: 0;
        }
        .section-header h3 {
            color: white;
            margin: 0;
            font-size: 1.5rem;
        }
        .item-card {
            border: 1px solid #d0d0d0;
            border-radius: 12px;
            background: #ffffff;
            transition: all 0.3s ease;
            height: 100%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
        }
        .item-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }
        .item-card img {
            width: 100%;
            height: 180px; /* Fixed height for images */
            object-fit: cover; /* Cover the area without distortion */
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
        }
        .item-card .card-body {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .item-card .card-title {
            font-size: 1.1rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        .item-card .card-text {
            font-size: 0.9rem;
            color: #555;
            flex-grow: 1; /* Allow description to take up space */
            margin-bottom: 1rem;
        }
        .item-card .points-cost {
            font-size: 1.2rem;
            font-weight: bold;
            color: #28a745; /* Green color for points */
            margin-bottom: 1rem;
        }
        .item-card .btn-redeem {
             width: 100%; /* Full width button */
        }
         .btn-redeem.disabled {
             pointer-events: none; /* Disable click */
             opacity: 0.65; /* Visual indication of disabled state */
         }
    </style>
</head>
<body>

<div class="container">

    <%-- 用户积分信息 --%>
    <div class="points-info-card d-flex justify-content-between align-items-center">
        <div>
            <h4>您的积分</h4>
            <div class="points-value"><%= userPoints %></div>
        </div>
        <div>
            <a href="volunteer_center.jsp" class="btn btn-light btn-sm">返回个人中心</a>
        </div>
    </div>

    <%-- 错误消息 --%>
    <% if (errorMsg != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= errorMsg %>
        </div>
    <% } %>

    <%-- 移除了精选商品部分 --%>

    <%-- 所有商品 --%>
    <div class="all-items-section">
        <div class="section-header">
            <h3>所有商品</h3>
        </div>
        <div class="row mt-3">
             <% if (allItems.isEmpty()) { %>
                <div class="col-12">
                    <p class="text-center text-muted">暂无商品。</p>
                </div>
            <% } else { %>
                <%
                    // 生成一个随机数作为图片ID的基础，让每次加载页面图片都不同
                    int baseImageId = random.nextInt(1000);
                %>
                <% for (int i = 0; i < allItems.size(); i++) {
                    Map<String, Object> item = allItems.get(i);
                    // 使用 Lorem Picsum 生成随机图片URL
                    // https://picsum.photos/id/{id}/{width}/{height}
                    // 使用 baseImageId + i 作为图片ID，确保同一页面内的图片不重复
                    String imageUrl = "https://picsum.photos/id/" + (baseImageId + i) + "/300/180"; // 300x180 尺寸
                %>
                    <div class="col-md-3 col-sm-6 mb-4"> <%-- Adjust column size for more items per row --%>
                        <div class="item-card">
                             <img src="<%= imageUrl %>" class="card-img-top" alt="<%= item.get("name") %>">
                            <div class="card-body">
                                <h6 class="card-title"><%= item.get("name") %></h6> <%-- Smaller title for smaller cards --%>
                                <p class="card-text small"><%= item.get("description") %></p> <%-- Smaller text --%>
                                <div class="points-cost small"><%= item.get("points_cost") %> 积分</div> <%-- Smaller points text --%>
                                <%
                                    int pointsCost = (Integer) item.get("points_cost");
                                    boolean canRedeem = userPoints >= pointsCost;
                                %>
                                <button class="btn btn-success btn-redeem btn-sm <%= canRedeem ? "" : "disabled" %>"
                                        <%= canRedeem ? "" : "disabled" %>
                                        onclick="redeemItem(<%= item.get("id") %>, <%= pointsCost %>)">
                                    <%= canRedeem ? "立即兑换" : "积分不足" %>
                                </button>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>

</div>

<%-- 兑换功能的简单JS提示 (实际兑换需要后端Servlet) --%>
<script>
    function redeemItem(itemId, pointsCost) {
        if (confirm("确定要花费 " + pointsCost + " 积分兑换此商品吗？")) {
            // 这里应该调用一个后端的 Servlet 来处理兑换逻辑
            // 例如: window.location.href = 'redeem-servlet?itemId=' + itemId;
            alert("兑换功能待实现，商品ID: " + itemId + ", 积分: " + pointsCost);
            // 实际应用中，成功兑换后需要刷新页面或更新积分显示
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>