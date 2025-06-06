<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>管理员登录 - 志愿者服务平台</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      padding: 15px; 
      box-sizing: border-box; 
    }

    .login-card {
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      overflow: hidden;
      transition: transform 0.3s ease;
      max-width: 450px;
      width: 100%;
      margin: 0 auto;
      
    }

    .login-card:hover {
      transform: translateY(-5px);
    }

    .card-header {
      background: linear-gradient(45deg, #ffc107, #ff9800); /* 黄色渐变 */
      color: white;
      padding: 1.5rem;
      font-size: 1.5rem;
      font-weight: 600;
      text-align: center;
    }

    .card-body {
        padding: 2rem;
        background-color: white;
    }

    .login-icon {
      font-size: 4rem;
      color: #ffc107; /* 黄色 */
      text-align: center;
      margin-bottom: 20px;
    }

    .footer-link {
      text-align: center;
      margin-top: 20px;
    }

    .footer-link a {
      color:  #ffc107;
      text-decoration: none;
      font-weight: bold;
    }

    .footer-link a:hover {
      text-decoration: underline;
    }


    .form-label {
        font-weight: 600;
        color: #555;
    }

    .input-group-text {
        background-color: #e9ecef;
        border-right: none;
        color: #495057;
    }

    .form-control {
        border-left: none;
    }

    .form-control:focus {
        box-shadow: none;
        border-color: #ffc107;
    }

    .btn-success {
        /* 修改为黄色渐变背景 */
        background: linear-gradient(45deg, #ffc107, #ff9800); /* 黄色渐变 */
        border: none; /* 移除边框 */
        color: white; /* 确保文字颜色为白色 */
        font-size: 1.1rem;
        font-weight: 600;
        padding: 10px 20px;
        border-radius: 10px;
        transition: background-color 0.3s ease, border-color 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease;
    }

    .btn-success:hover {
        /* 调整 hover 效果为黄色 */
        background: linear-gradient(45deg, #ff9800, #f57c00); /* 较深的黄色渐变 */
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(255, 193, 7, 0.3); /* 黄色阴影 */
    }

    .text-secondary {
        color: #6c757d !important;
    }

    .text-secondary:hover {
        color: #5a6268 !important;
    }

    /* 注册链接样式 */
    .register-link {
        text-align: center;
        margin-top: 15px; /* 调整间距 */
        font-size: 0.9rem; /* 调整字体大小 */
    }

    .register-link a {
        color:  #ff9800;
        text-decoration: none;
        font-weight: bold;
    }

    .register-link a:hover {
        text-decoration: underline;
    }

  </style>
</head>
<body>
<div class="container d-flex justify-content-center align-items-center" style="height: 100vh;">
  <div class="row justify-content-center w-100">
    <div class="col-md-6 col-lg-5">
      <div class="login-card">
        <div class="card-header text-white">
          <i class="fas fa-user-shield me-2"></i>管理员登录
        </div>
        <div class="card-body">
          <div class="login-icon">
            <i class="fas fa-user-circle"></i>
          </div>
          <form action="admin-login-servlet" method="post">
            <div class="mb-4">
              <label for="username" class="form-label">用户名</label>
              <div class="input-group">
                <span class="input-group-text"><i class="fas fa-user"></i></span>
                <input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名" required>
              </div>
            </div>
            <div class="mb-4">
              <label for="password" class="form-label">密码</label>
              <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password" placeholder="请输入密码" required>
              </div>
            </div>
            <button type="submit" class="btn btn-success w-100 mb-3">
              <i class="fas fa-sign-in-alt me-2"></i>登录
            </button>
          </form>
          <div class="register-link">
              没有账号? <a href="index.jsp"> 那就别登录了</a>
          </div>
        </div>
      </div>
      <div class="footer-link">
        <a href="index.jsp" class="text-decoration-none text-secondary">
          <i class="fas fa-home me-1"></i>返回首页
        </a>
        <%-- 添加用户登录按钮 --%>
        <a href="login.jsp" class="text-decoration-none text-secondary ms-3">
          <i class="fas fa-user me-1"></i>用户登录
        </a>
      </div>
    </div>
  </div>
</div>
</body>
</html>