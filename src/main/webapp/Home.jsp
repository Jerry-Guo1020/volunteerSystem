
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>志愿者管理系统 | 项目介绍</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- {{ edit_1 }} 添加 Favicon 链接 -->
    <link rel="icon" href="image/logo.png" type="image/x-icon">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            /* 活力橙+温暖黄渐变，符合志愿者氛围 */
            color: #333;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-title {
            font-size: 3rem;
            font-weight: bold;
            letter-spacing: 2px;
            margin-top: 25px;
            margin-bottom: 10px;
            color: #ff9800;
            text-shadow: 0 2px 16px #fff3e0;
        }
        .subtitle {
            font-size: 1.3rem;
            color: #ff9800;
            margin-bottom: 25px;
            font-weight: 500;
        }
        .logo-circle {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #ff9800 60%, #ffd54f 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            /* margin: 30px auto 10px auto; */ /* {{ edit_1 }} 移除旧的 margin */
            margin: 60px auto 10px auto; /* {{ edit_2 }} 增加顶部外边距 */
            box-shadow: 0 4px 24px rgba(255,152,0,0.15);
        }
        .logo-circle img {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: #fff;
            padding: 8px;
        }
        .section-title {
            font-size: 2rem;
            font-weight: bold;
            color: #ff9800;
            margin-bottom: 32px;
            text-align: center;
            letter-spacing: 1px;
        }
        .feature-cards {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 32px;
            margin-bottom: 48px;
        }
        .feature-card {
            background: #fff;
            border-radius: 22px;
            box-shadow: 0 4px 24px rgba(255,152,0,0.10);
            padding: 36px 28px 28px 28px;
            width: 400px;
            min-height: 260px;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: transform 0.18s, box-shadow 0.18s;
            border: none;
        }
        .feature-card:hover {
            transform: translateY(-6px) scale(1.03);
            box-shadow: 0 8px 32px rgba(255,152,0,0.18);
        }
        .feature-icon-circle {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ffd54f 0%, #ff9800 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 18px;
            box-shadow: 0 2px 8px #ffe0b2;
        }
        .feature-icon-circle i {
            font-size: 2rem;
            color: #fff;
        }
        .feature-title {
            font-size: 1.18rem;
            font-weight: bold;
            color: #ff9800;
            margin-bottom: 12px;
            text-align: center;
        }
        .feature-desc {
            font-size: 1.05rem;
            color: #666;
            text-align: center;
        }

        .tech-badge {
            background: #fff3e0;
            color: #ff9800;
            border-radius: 16px;
            padding: 6px 16px;
            font-size: 1rem;
            font-weight: 500;
            border: 1px solid #ffe0b2;
        }
        .info-section {
            background: rgba(255,255,255,0.85);
            border-radius: 18px;
            box-shadow: 0 2px 12px rgba(255,152,0,0.08);
            padding: 32px 24px;
            margin-bottom: 36px;
        }
        .info-section h3 {
            color: #ff9800;
            font-size: 1.3rem;
            font-weight: bold;
            margin-bottom: 18px;
        }
        .info-section p, .info-section div {
            color: #444;
            font-size: 1.08rem;
            line-height: 1.6; /* {{ edit_3 }} 增加行间距 */
        }


        /* 用于包裹并排的 info-section */
        .info-row {
            display: flex;
            gap: 32px; /* 卡片之间的间距 */
            justify-content: center;
            margin-bottom: 20px; /* {{ edit_2 }} 进一步调整底部外边距，使其与上方内容更紧凑 */
            flex-wrap: wrap; /* 允许在小屏幕上换行 */
        }

        /* info-section 在 info-row 中的布局 */
        .info-row > .info-section {
            flex: 1 1 400px; /* 允许伸缩，基础宽度调整为400px，与feature-card宽度一致 */
            min-width: 320px; /* 最小宽度 */
            text-align: left; /* 内部文本左对齐 */
        }

        /* 技术架构卡片内部布局 */
        .tech-architecture-content {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            align-items: center; /* 垂直居中 */
            justify-content: center; /* 水平居中内容 */
        }

        .tech-architecture-content .text {
            flex: 1 1 200px; /* 文字部分 */
            min-width: 200px; /* 确保文字有足够空间 */
        }

        .tech-architecture-content .badges {
            flex: 1 1 150px; /* 标签部分 */
            display: flex;
            flex-wrap: wrap;
            gap: 8px; /* 标签之间的间距 */
            justify-content: center; /* 标签居中 */
            min-width: 150px; /* 确保标签容器有足够空间 */
        }

        /* 快速开始卡片 */
        .quickstart-card {
             background: rgba(255,255,255,0.85);
             border-radius: 18px;
             box-shadow: 0 2px 12px rgba(255,152,0,0.08);
             padding: 40px 24px 100px 24px; /* 增加顶部和底部内边距给图标和按钮留空间 */
             margin-bottom: 60px; /* 调整底部外边距 */
             text-align: center;
             position: relative; /* 用于定位按钮 */
             margin-left: auto;
             margin-right: auto;
             display: flex; /* 使用flex布局 */
             flex-direction: column; /* 垂直排列子元素 */
             align-items: center; /* 子元素水平居中 */
             justify-content: center; /* 子元素垂直居中 */
        }

        /* 快速开始图标容器 */
        .quickstart-icon-container {
            margin-bottom: 20px; /* 图标下方间距 */
        }

        /* 快速开始图标 */
        .quickstart-icon-container i {
            font-size: 4rem; /* 图标放大 */
            color: #ff9800; /* 图标颜色 */
        }

        /* 快速开始标题 */
        .quickstart-title {
            font-size: 2.5rem; /* 标题放大 */
            font-weight: bold;
            color: #ff9800;
            margin-bottom: 15px; /* 标题下方间距 */
        }

        /* 快速开始描述 */
        .quickstart-desc {
            font-size: 1.1rem; /* 描述文字大小 */
            color: #444;
            margin-bottom: 30px; /* 描述下方间距 */
        }


        /* 快速开始按钮 */
        .quickstart-btn {
            background: linear-gradient(90deg, #ff9800 0%, #ffd54f 100%);
            color: #fff;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            padding: 14px 38px;
            font-size: 1.2rem;
            box-shadow: 0 2px 8px #ffecb3;
            transition: background 0.2s;
            position: absolute; /* 绝对定位 */
            bottom: 30px; /* 距离底部 */
            left: 50%; /* 水平居中 */
            transform: translateX(-50%); /* 精确居中 */
        }
        .quickstart-btn:hover {
            background: linear-gradient(90deg, #ffd54f 0%, #ff9800 100%);
            color: #fff;
        }

        /* --- 媒体查询调整 --- */
        @media (max-width: 1200px) { /* 调整断点 */
            .info-row {
                flex-direction: column; /* 在小屏幕上堆叠卡片 */
                gap: 24px;
            }
            .info-row > .info-section {
                width: 100%; /* 堆叠时宽度占满 */
                min-width: 0;
                max-width: none; /* 移除最大宽度限制 */
                text-align: center; /* 堆叠时文本居中 */
            }
             .tech-architecture-content {
                flex-direction: column; /* 在小屏幕上堆叠文字和标签 */
                align-items: center; /* 堆叠时居中 */
            }
            .tech-architecture-content .text,
            .tech-architecture-content .badges {
                 flex: none; /* 移除 flex 属性 */
                 width: 100%; /* 宽度占满 */
                 min-width: 0;
            }
             .tech-architecture-content .badges {
                justify-content: center; /* 标签保持居中 */
            }
             .quickstart-card {
                 /* max-width: 600px; */ /* 移除媒体查询中的旧最大宽度 */
                 max-width: 95%; /* 在小屏幕上宽度占满 */
                 padding-bottom: 80px; /* 调整快速开始卡片底部内边距 */
             }
             .quickstart-btn {
                 bottom: 24px; /* 调整按钮位置 */
             }
             .quickstart-title {
                 font-size: 2rem; /* 小屏幕标题稍微缩小 */
             }
             .quickstart-icon-container i {
                 font-size: 3.5rem; /* 小屏幕图标稍微缩小 */
             }
        }

        @media (max-width: 900px) {
            .feature-cards {
                flex-direction: column;
                align-items: center;
                gap: 24px;
            }
            .feature-card {
                width: 95%;
                min-width: 0;
            }
        }

        /* --- 现有样式 --- */
        .footer {
            color: #bdbdbd;
            font-size: 0.95rem;
            padding: 32px 0 12px 0;
            text-align: center;
            margin-top: 60px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 项目主标题 -->
        <div class="text-center">
            <div class="logo-circle">
                <img src="image/logo.png" alt="VolunteerSystem Logo">
            </div>
            <div class="main-title">志愿者管理系统 VolunteerSystem</div>
            <div class="subtitle">基于Java Web的志愿服务综合管理平台</div>
        </div>

        <!-- 项目简介 和 技术架构 并排 -->
        <div class="info-row">
            <!-- 项目简介 -->
            <div class="info-section">
                <h3><i class="fas fa-info-circle me-2"></i>项目简介</h3>
                <div>
                    志愿者管理系统是一个基于Java Web技术的综合性平台，致力于连接有爱心的志愿者与需要帮助的社区，共同建设美好社会。<br>
                    系统支持志愿者注册、活动参与、积分管理和奖励兑换，同时为管理员提供用户管理、项目管理和数据统计等功能。
                </div>
            </div>

            <!-- 技术架构 -->
            <div class="info-section">
                <h3><i class="fas fa-cogs me-2"></i>技术架构</h3>
                <div class="tech-architecture-content">
                    <div class="text">
                        核心技术栈：<br>
                        前端：JSP + Bootstrap + Font Awesome<br>
                        后端：Java Servlet + JDBC<br>
                        数据库：MySQL<br>
                        会话管理：HttpSession<br>
                        连接管理：JDBCUtil工具类<br>
                        系统架构：经典三层架构
                    </div>
                    <div class="badges">
                        <span class="tech-badge">JSP</span>
                        <span class="tech-badge">Bootstrap</span>
                        <span class="tech-badge">Font Awesome</span>
                        <span class="tech-badge">Java Servlet</span>
                        <span class="tech-badge">JDBC</span>
                        <span class="tech-badge">MySQL</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- {{ edit_4 }} 数据库设计和部署说明并排 -->
        <div class="info-row">
            <!-- 数据库设计 -->
            <div class="info-section">
                <h3><i class="fas fa-database me-2"></i>数据库设计</h3>
                <div>
                    <b>user</b>：用户账户信息管理 <br>
                    <b>project</b>：志愿项目定义和状态管理 <br>
                    <b>signup</b>：用户项目参与记录和状态跟踪 <br>
                    <b>message</b>：用户通信系统和消息管理
                </div>
            </div>

            <!-- 部署说明 -->
            <div class="info-section">
                <h3><i class="fas fa-server me-2"></i>部署说明</h3>
                <div>
                    1. 安装Java 8+、MySQL 5.7+、Apache Tomcat 8.5+、Maven 3.6+<br>
                    2. 导入 <code>src/数据库.sql</code> 文件创建数据库结构<br>
                    3. 在 <code>JDBCUtil</code> 类中配置数据库连接参数<br>
                    4. 使用Maven构建项目：<code>mvn clean package</code><br>
                    5. 将生成的WAR文件部署到Tomcat服务器<br>
                    6. 浏览器访问：<code>http://localhost:8080/VolunteerSystem/</code>
                </div>
            </div>
        </div>
        <!-- {{ edit_5 }} 核心功能模块（卡片式） -->
        <div class="section-title">核心功能模块</div>
        <div class="feature-cards">
            <div class="feature-card">
                <div class="feature-icon-circle"><i class="fas fa-user-plus"></i></div>
                <div class="feature-title">用户注册与登录</div>
                <div class="feature-desc">新用户注册、账户登录，安全的身份验证与会话管理。</div>
            </div>
            <div class="feature-card">
                <div class="feature-icon-circle"><i class="fas fa-user-circle"></i></div>
                <div class="feature-title">个人中心与服务记录</div>
                <div class="feature-desc">管理个人资料，查询参与活动历史与完成状态。</div>
            </div>
            <div class="feature-card">
                <div class="feature-icon-circle"><i class="fas fa-hands-helping"></i></div>
                <div class="feature-title">项目浏览与报名</div>
                <div class="feature-desc">浏览志愿服务项目，在线报名参与，活动评价反馈。</div>
            </div>
            <div class="feature-card">
                <div class="feature-icon-circle"><i class="fas fa-gift"></i></div>
                <div class="feature-title">积分奖励与商品兑换</div>
                <div class="feature-desc">参与服务获得积分，积分兑换精美奖品，兑换记录可查。</div>
            </div>
            <div class="feature-card">
                <div class="feature-icon-circle"><i class="fas fa-bell"></i></div>
                <div class="feature-title">消息中心</div>
                <div class="feature-desc">系统通知、消息沟通，实时掌握平台动态。</div>
            </div>
            <div class="feature-card">
                <div class="feature-icon-circle"><i class="fas fa-users-cog"></i></div>
                <div class="feature-title">管理员功能</div>
                <div class="feature-desc">用户管理、项目审批、报名监督、积分分配、数据统计与报表导出。</div>
            </div>
        </div>

        <!-- 快速开始 -->
        <div class="quickstart-card">
            <div class="quickstart-icon-container">
                 <i class="fas fa-rocket"></i> <!-- 使用火箭图标 -->
            </div>
            <h3 class="quickstart-title">快速开始</h3>
            <div class="quickstart-desc">
                访问系统首页了解平台功能，注册新用户账户或使用管理员账户登录，浏览志愿服务项目并参与感兴趣的内容。
            </div>
            <a href="index.jsp" class="quickstart-btn">进入系统主页</a>
        </div>

        <div class="footer">
            &copy; 2025 志愿者管理系统 VolunteerSystem | 课程设计作品
        </div>
    </div>
</body>
</html>