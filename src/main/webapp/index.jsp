<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>志愿者服务平台</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 全局样式优化 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        
        /* 卡片样式优化 */
        .feature-card {
            border: 2px solid #e0e0e0;
            border-radius: 18px;
            padding: 28px 20px;
            background: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.04);
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
            margin: 15px auto;
            height: 280px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        
        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
            border-color: #7ed957;
        }
        
        .feature-icon {
            font-size: 3rem;
            color: #0d6efd;
            margin-bottom: 1.2rem;
        }
        
        /* 积分榜样式优化 */
        .leaderboard {
            background: #fffbe7;
            border-radius: 12px;
            padding: 1.8rem;
            margin-top: 2rem;
        }
        
        .leaderboard-animated {
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
            box-shadow: 0 2px 10px rgba(0,0,0,0.04);
            border: 2px solid #f7e3a3;
            border-radius: 18px;
            animation: leaderboard-fade-in 0.7s ease-out;
        }
        
        .leaderboard-animated:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 24px rgba(243,156,18,0.18);
            border-color: #f39c12;
        }
        
        @keyframes leaderboard-fade-in {
            from { opacity: 0; transform: translateY(32px); }
            to { opacity: 1; transform: none; }
        }
        
        /* 轮播图样式优化 */
        .carousel-caption {
            background: rgba(0,0,0,0.5);
            border-radius: 8px;
            padding: 15px;
            max-width: 80%;
            margin: 0 auto;
        }
        
        /* 导航栏样式优化 */
        .navbar {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        /* 页脚样式优化 */
        .footer {
            background-color: #343a40;
            padding: 20px 0;
            margin-top: 50px;
        }
        
        .footer .text-muted {
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
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="fas fa-hands-helping me-2"></i>志愿者服务平台
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="login.jsp"><i class="fas fa-sign-in-alt me-1"></i>登录</a></li>
                <li class="nav-item"><a class="nav-link" href="register.jsp"><i class="fas fa-user-plus me-1"></i>注册</a></li>
                <li class="nav-item"><a class="nav-link" href="volunteer_center.jsp"><i class="fas fa-user-circle me-1"></i>个人中心</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- 轮播图 -->
<div id="mainCarousel" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80" class="d-block w-100" style="max-height:450px;object-fit:cover;" alt="志愿服务">
            <div class="carousel-caption d-none d-md-block">
                <h4>让爱心点亮城市</h4>
                <p>加入我们，让世界因你更美好！</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=1200&q=80" class="d-block w-100" style="max-height:450px;object-fit:cover;" alt="志愿者活动">
            <div class="carousel-caption d-none d-md-block">
                <h4>志愿服务，收获成长</h4>
                <p>每一次付出都值得被铭记。</p>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Previous</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
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
                <p class="mb-0">结识志同道合的朋友，共同成长、共同进步。</p>
            </div>
        </div>
    </div>
    
    <!-- 积分榜 -->
    <div class="row justify-content-center mt-4">
        <div class="col-md-8">
            <div class="leaderboard leaderboard-animated shadow-sm">
                <h4 class="mb-3"><span style="color:#f39c12;"><i class="fas fa-medal me-2"></i></span>积分榜</h4>
                <table class="table table-striped">
                    <thead class="table-light">
                        <tr>
                            <th>排名</th>
                            <th>用户名</th>
                            <th>积分</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><td>1</td><td>admin</td><td>100</td></tr>
                        <tr><td>2</td><td>志愿者A</td><td>80</td></tr>
                        <tr><td>3</td><td>志愿者B</td><td>65</td></tr>
                        <tr><td>4</td><td>志愿者C</td><td>40</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<footer class="footer text-white text-center">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <p class="mb-0">&copy; 2025 志愿者服务平台 | 联系方式：service@volunteer.com | 地址：北京市志愿路100号</p>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>