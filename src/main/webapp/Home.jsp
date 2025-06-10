<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>志愿者服务平台</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 全局样式优化 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        /* 卡片样式优化 */
        .feature-card {
            border: 1px solid #d0d0d0; /* Slightly lighter border */
            border-radius: 12px; /* Slightly smaller border radius */
            padding: 25px 20px; /* Adjusted padding */
            background: #ffffff; /* White background */
            transition: all 0.3s ease;
            height: 100%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05); /* Subtle shadow */
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1); /* More pronounced shadow on hover */
            border-color: #28a745; /* Green border on hover */
        }

        /* 图标样式 */
        .feature-icon {
            font-size: 3rem; /* Slightly larger icon */
            margin-bottom: 1rem;
            color: #007bff; /* Example color for icons */
        }

        /* 轮播图样式优化 */
        .carousel-item {
            height: 400px;
        }

        .carousel-item img {
            object-fit: cover;
            height: 100%;
        }

        .carousel-caption {
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 10px;
            padding: 15px;
        }

        /* 底部样式 */
        .footer {
            background-color: #343a40;
            color: #fff;
            padding: 40px 0;
        }

        .footer a {
            color: #adb5bd !important;
        }

        /* 按钮样式优化 */
        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
            transition: all 0.3s ease;
        }

        .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* 用户下拉菜单样式 */
        .dropdown-menu {
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border: none;
        }

        .dropdown-item {
            padding: 8px 20px;
            transition: all 0.2s ease;
        }

        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: #28a745;
        }

        .dropdown-item.text-danger:hover {
            background-color: #fff5f5;
            color: #dc3545;
        }

        .user-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #28a745;
            color: white;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 5px;
            font-weight: bold;
        }


        .recommended-activities-header {
            background: linear-gradient(to right, #dc3545, #c82333);
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            color: white;
            padding: 15px 20px;
        }

        .recommended-activities-header h3 {
            color: white;
            font-size: 1.5rem; /* Adjusted font size */
        }

        .recommended-activities-header a {
            color: white !important;
            opacity: 0.9;
            transition: opacity 0.2s ease;
            font-size: 0.9rem;
        }

        .recommended-activities-header a:hover {
            opacity: 1;
            text-decoration: underline !important;
        }

        /* Activity Card Style */
        .activity-card {
            border: 1px solid #d0d0d0; /* Slightly lighter border */
            border-radius: 12px; /* Slightly smaller border radius */
            padding: 25px 20px; /* Adjusted padding */
            background: #ffffff; /* White background */
            transition: all 0.3s ease;
            height: 100%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05); /* Subtle shadow */

        }

        .activity-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
        }

        /* Activity Icon Container Style */
        .activity-icon-container {
            width: 50px; /* Adjusted size */
            height: 50px; /* Adjusted size */
            border-radius: 50%; /* Make it round */
            background-color: #e9ecef;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 5px;
            flex-shrink: 0;
            margin-right: 15px; /* Adjusted margin */
        }

        .activity-icon-container i {
            color: #28a745;
            font-size: 1.5rem; /* Adjusted icon size */
        }

        .activity-category-label {
            font-size: 0.6rem; /* Adjusted font size */
            color: #6c757d;
            margin-top: 2px; /* Adjusted margin */
        }

        /* Activity Details Style */
        .activity-details h6 {
            margin-bottom: 0.25rem !important;
            /* Adjust spacing */
        }

        .activity-details p {
            margin-bottom: 0.1rem !important;
            /* Adjust spacing */
            line-height: 1.3;
        }
    </style>
</head>

<body>
<%
    // 获取当前登录用户
    String username = (String) session.getAttribute("username");
    boolean isLoggedIn = (username != null);

    // 模拟从数据库获取推荐活动数据
    // 在实际应用中，您需要调用后端服务来获取真实数据
    List<Map<String, String>> recommendedActivities = new ArrayList<>();
    // Dummy data mimicking the image content
    Map<String, String> activity1 = new HashMap<>();
    activity1.put("title", "博罗中学班主任文化节");
    activity1.put("publisher", "博罗县博罗中学");
    activity1.put("time", "2025/05/24 00:00 - 23:46");
    activity1.put("category", "文艺文化");
    activity1.put("icon", "fas fa-palette");

    Map<String, String> activity2 = new HashMap<>();
    activity2.put("title", "5.24招生志愿活动");
    activity2.put("publisher", "乐昌市城关中学");
    activity2.put("time", "2025/05/24 00:00 - 23:59");
    activity2.put("category", "志愿服务");
    activity2.put("icon", "fas fa-graduation-cap");

    Map<String, String> activity3 = new HashMap<>();
    activity3.put("title", "金砂中学校园志愿");
    activity3.put("publisher", "汕头市金砂中学");
    activity3.put("time", "2025/05/24 00:00 - 05/25 00:00");
    activity3.put("category", "公共服务");
    activity3.put("icon", "fas fa-hand-holding-heart");

    Map<String, String> activity4 = new HashMap<>();
    activity4.put("title", "“青春志愿行,奉献新时代”5月24日志愿行");
    activity4.put("publisher", "广交院青年志愿者行动指导中心");
    activity4.put("time", "2025/05/24 00:00 - 05/25 23:59");
    activity4.put("category", "志愿服务");
    activity4.put("icon", "fas fa-flag");

    recommendedActivities.add(activity1);
    recommendedActivities.add(activity2);
    recommendedActivities.add(activity3);
    recommendedActivities.add(activity4);

    // 模拟从数据库获取新闻数据
    List<Map<String, String>> latestNews = new ArrayList<>();
    Map<String, String> news1 = new HashMap<>();
    news1.put("title", "平台用户突破10万，感谢你有你！");
    news1.put("date", "2025-06-01");
    news1.put("summary", "志愿者服务平台用户数量再创新高，感谢每一位VolunteerSystem贡献！");

    Map<String, String> news2 = new HashMap<>();
    news2.put("title", "夏季大型公益活动圆满成功");
    news2.put("date", "2025-05-28");
    news2.put("summary", "为期一个月的夏季公益活动顺利结束，志愿者们用汗水点亮城市。");

    Map<String, String> news3 = new HashMap<>();
    news3.put("title", "新功能上线：积分兑换商城");
    news3.put("date", "2025-05-20");
    news3.put("summary", "期待已久的积分兑换商城正式上线，快来用你的积分兑换心仪的礼品吧！");

    latestNews.add(news1);
    latestNews.add(news2);
    latestNews.add(news3);
%>
<jsp:include page="common/navbar.jsp" />

<!-- 轮播图 -->
<div id="mainCarousel" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="0" class="active"
                aria-current="true" aria-label="Slide 1"></button>
        <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="1"
                aria-label="Slide 2"></button>
        <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="2"
                aria-label="Slide 3"></button>
    </div>
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?auto=format&fit=crop&w=1200&q=80"
                 class="d-block w-100" alt="志愿服务">
            <div class="carousel-caption d-none d-md-block">
                <h2>加入志愿者行列</h2>
                <p>用爱心和行动，共建美好社会</p>
                <% if (isLoggedIn) { %>
                <a href="volunteer_center.jsp" class="btn btn-success">进入个人中心</a>
                <% } else { %>
                <a href="register.jsp" class="btn btn-success">立即加入</a>
                <% } %>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://images.unsplash.com/photo-1506784365847-bbad939e9335?auto=format&fit=crop&w=1200&q=80"
                 class="d-block w-100" alt="社区服务">
            <div class="carousel-caption d-none d-md-block">
                <h2>社区服务项目</h2>
                <p>从身边小事做起，温暖你我社区</p>
                <a href="project_list.jsp" class="btn btn-success">查看项目</a>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://images.unsplash.com/photo-1522199710521-72d69614c702?auto=format&fit=crop&w=1200&q=80"
                 class="d-block w-100" alt="公益活动">
            <div class="carousel-caption d-none d-md-block">
                <h2>公益活动招募</h2>
                <p>汇聚点滴力量，成就非凡事业</p>
                <a href="project_list.jsp" class="btn btn-success">我要报名</a>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel"
            data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Previous</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel"
            data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Next</span>
    </button>
</div>


<!-- 平台简介与特色 -->
<div class="container mt-5">
    <div class="row text-center mb-5">
        <div class="col">
            <h1 class="fw-bold">欢迎来到志愿者服务平台</h1>
            <p class="lead">参与志愿服务，收获成长与积分，兑换精彩奖励！</p>
            <a href="project_list.jsp" class="btn btn-success btn-lg mt-3 px-4 py-2">
                <i class="fas fa-list-alt me-2"></i>浏览志愿服务项目
            </a>
        </div>
    </div>

    <div class="row justify-content-center mb-5">
        <div class="col-md-4 mb-4">
            <div class="feature-card text-center">
                <div class="feature-icon">❤️</div>
                <h5 class="mb-3">公益项目丰富</h5>
                <p class="mb-0">多样化志愿服务项目，满足不同兴趣与特长。</p>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="feature-card text-center">
                <div class="feature-icon">🏆</div>
                <h5 class="mb-3">积分激励机制</h5>
                <p class="mb-0">每参与一次志愿服务即可获得积分，积分可兑换奖励。</p>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="feature-card text-center">
                <div class="feature-icon">🤝</div>
                <h5 class="mb-3">成长与交流</h5>
                <p class="mb-0">结识志同道合的伙伴，共同成长进步。</p>
            </div>
        </div>
    </div>

 <!-- How to become a volunteer Section -->
 <div class="how-to-volunteer-section mt-5">
    <div class="recommended-activities-header d-flex justify-content-between align-items-center p-3">
        <h3 class="mb-0 text-white">成为志愿者流程</h3>
    </div>
    <div class="row mt-3">
        <div class="col-md-4 mb-4">
            <div class="feature-card text-center">
                <div class="feature-icon">✍️</div>
                <h5 class="mb-3">第一步：注册账号</h5>
                <p class="mb-0">访问注册页面，填写必要信息，创建您的志愿者账号。</p>
                <a href="register.jsp" class="btn btn-outline-primary btn-sm mt-3">立即注册</a>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="feature-card text-center">
                <div class="feature-icon">🔍</div>
                <h5 class="mb-3">第二步：浏览项目</h5>
                <p class="mb-0">在项目列表中查找您感兴趣的志愿服务。</p>
                <a href="project_list.jsp" class="btn btn-outline-primary btn-sm mt-3">浏览项目</a>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="feature-card text-center">
                <div class="feature-icon">✅</div>
                <h5 class="mb-3">第三步：报名参与</h5>
                <p class="mb-0">选择项目并提交报名申请，等待组织者审核。</p>
                <a href="project_list.jsp" class="btn btn-outline-primary btn-sm mt-3">立即报名</a>
            </div>
        </div>
    </div>
</div>

    <!-- Recommended Activities Section -->
    <div class="recommended-activities-section mt-5">
        <div class="recommended-activities-header d-flex justify-content-between align-items-center p-3">
            <h3 class="mb-0 text-white">推荐活动</h3>
            <a href="project_list.jsp" class="text-white text-decoration-none">更多活动 &raquo;</a>
        </div>
        <div class="row mt-3">
            <% for (Map<String, String> activity : recommendedActivities) { %>
                <div class="col-md-6 mb-4">
                    <div class="activity-card d-flex align-items-center p-3">
                        <div class="activity-icon-container text-center me-3">
                            <i class="<%= activity.get("icon") %> fa-2x"></i>
                            <div class="activity-category-label mt-1"><%= activity.get("category") %></div>
                        </div>
                        <div class="activity-details flex-grow-1">
                            <h6 class="mb-1 fw-bold"><%= activity.get("title") %></h6>
                            <p class="mb-1 text-muted small">发布组织: <%= activity.get("publisher") %></p>
                            <p class="mb-0 text-muted small">开展时间: <%= activity.get("time") %></p>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </div>


    <!-- Latest News Section -->
    <div class="latest-news-section mt-5">
        <div class="recommended-activities-header d-flex justify-content-between align-items-center p-3">
            <h3 class="mb-0 text-white">最新动态</h3>
            <a href="#" class="text-white text-decoration-none">更多新闻 &raquo;</a>
        </div>
        <div class="row mt-3">
            <% for (Map<String, String> news : latestNews) { %>
                <div class="col-md-4 mb-4">
                    <div class="activity-card p-3">
                        <h6 class="mb-1 fw-bold"><%= news.get("title") %></h6>
                        <p class="mb-1 text-muted small"><%= news.get("date") %></p>
                        <p class="mb-0 text-muted small"><%= news.get("summary") %></p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>


    <!-- 关于我们部分 -->
    <div class="row justify-content-center mt-5 mb-5">
        <div class="col-md-8 text-center">
            <h2 class="fw-bold mb-3">关于我们</h2>
            <p class="lead">志愿者服务平台致力于连接有爱心的志愿者与需要帮助的社区，共同建设美好社会。</p>
        </div>
    </div>

</div>

<!-- 底部信息 -->
<footer class="footer mt-5">
    <div class="container">
        <div class="row">
            <div class="col text-center pt-3 ">
                <p>© 2025 志愿者服务平台,为有所需要的人而服务！</p>
            </div>
        </div>
    </div>
</footer>

<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>