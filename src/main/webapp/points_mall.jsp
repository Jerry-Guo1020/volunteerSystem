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
        /* 全局样式和背景 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e0f7fa 0%, #b2ebf2 100%); /* 使用更柔和的蓝色渐变 */
            min-height: 100vh;
            display: flex;
            align-items: flex-start; /* 顶部对齐 */
            justify-content: center;
            padding: 30px 15px; /* 增加上下内边距，左右适应 */
            box-sizing: border-box; /* 盒模型设置为border-box */
        }

        /* 主容器 */
        .main-container {
            background-color: #ffffff; /* 白色背景 */
            border-radius: 15px; /* 圆角 */
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15); /* 更明显的阴影 */
            padding: 40px; /* 内部填充 */
            max-width: 960px; /* 稍微增加最大宽度 */
            width: 100%;
            margin-top: 20px; /* 顶部留白 */
            margin-bottom: 20px; /* 底部留白 */
        }

        /* 页面标题 */
        .section-title {
            color: #0056b3; /* 深蓝色标题 */
            font-weight: 700; /* 加粗 */
            margin-bottom: 30px; /* 增加下方间距 */
            text-align: center;
            font-size: 2.2rem; /* 增加字体大小 */
            position: relative; /* 用于添加下划线效果 */
        }

        .section-title::after {
            content: '';
            display: block;
            width: 60px; /* 下划线宽度 */
            height: 4px; /* 下划线高度 */
            background-color: #007bff; /* 下划线颜色 */
            margin: 10px auto 0; /* 居中并与标题保持距离 */
            border-radius: 2px;
        }

        /* 卡片样式优化 */
        /* 包含 info-card, records-card, content-card (用于其他页面) */
        .info-card, .records-card, .content-card {
            border: none; /* 移除默认边框 */
            border-radius: 12px; /* 较大的圆角 */
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08); /* 适中的阴影 */
            margin-bottom: 30px; /* 卡片间距 */
            overflow: hidden; /* 确保内容不溢出圆角 */
        }

        .info-card .card-body, .records-card .card-body, .content-card .card-body {
            padding: 30px; /* 调整内边距 */
        }

        .info-card h4 {
            margin-bottom: 15px;
            color: #333; /* 深色标题 */
            font-size: 1.5rem;
        }

        /* 商品卡片样式 */
        .item-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease-in-out;
            height: 100%; /* Ensure cards in a row have equal height */
        }

        .item-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }

        .item-card img {
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            height: 180px; /* Fixed image height */
            object-fit: cover; /* Cover the area without distorting aspect ratio */
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
            color: #ff9800; /* Orange color for points */
        }

        /* 积分信息卡片 */
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
            margin-bottom: 10px;
        }

        .points-info-card .badge {
            background-color: rgba(255, 255, 255, 0.3);
            color: white;
            font-size: 1.2rem;
            padding: 0.5em 0.75em;
        }

        /* 响应式调整 */
        @media (max-width: 768px) {
            .main-container {
                padding: 20px; /* 减小小屏幕内边距 */
            }
            .section-title {
                font-size: 1.8rem; /* 减小小屏幕标题字体 */
                margin-bottom: 20px;
            }
            .item-card img {
                height: 150px; /* Adjust image height on smaller screens */
            }
        }
    </style>
</head>
<body>
<jsp:include page="common/navbar.jsp" />

<div class="main-container">
    <h2 class="section-title">积分商城</h2>

    <%-- 错误消息 --%>
    <% if (errorMsg != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= errorMsg %>
        </div>
    <% } %>

    <!-- 用户积分信息 -->
    <div class="points-info-card text-center">
        <h4>我的当前积分</h4>
        <h1><span class="badge bg-light text-warning"><i class="fas fa-coins me-2"></i><%= userPoints %></span></h1>
    </div>

    <!-- 商品列表 -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <% if (allItems.isEmpty()) { %>
            <div class="col">
                <p class="text-center text-muted">暂无商品可兑换。</p>
            </div>
        <% } else { %>
            <% for (Map<String, Object> item : allItems) { %>
                <div class="col">
                    <div class="card item-card">
                        <img src="https://picsum.photos/seed/<%= item.get("id") %>/400/200" class="card-img-top" alt="<%= item.get("name") %>">
                        <div class="card-body">
                            <h5 class="card-title"><%= item.get("name") %></h5>
                            <p class="card-text"><%= item.get("description") %></p>
                            <p class="points-cost"><i class="fas fa-coins me-1"></i>所需积分: <%= item.get("points_cost") %></p>
                            <%-- 兑换按钮，需要根据用户积分和商品成本判断是否可点击 --%>
                            <button class="btn btn-primary btn-sm" <% if (userPoints < (Integer) item.get("points_cost")) { %>disabled<% } %> data-item-id="<%= item.get("id") %>">兑换</button>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.querySelectorAll('.btn-primary[data-item-id]').forEach(button => {
        button.addEventListener('click', function() {
            const itemId = this.getAttribute('data-item-id');
            // 这里可以添加兑换确认或直接发送兑换请求的逻辑
            alert('点击了兑换商品 ' + itemId);
            // TODO: Implement actual redemption logic via AJAX or form submission
        });
    });
</script>
</body>
</html>