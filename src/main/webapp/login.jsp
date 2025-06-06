<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>志愿者平台登录</title>
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
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      padding: 1.5rem;
      text-align: center;
      font-size: 1.5rem;
      font-weight: 600;
    }
    
    .card-body {
      padding: 2rem;
      background-color: white;
    }
    
    .form-control {
      border-radius: 10px;
      padding: 0.75rem 1rem;
      border: 1px solid #e0e0e0;
      transition: all 0.3s ease;
    }
    
    .form-control:focus {
      box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.2);
      border-color: #28a745;
    }
    
    .btn-success {
      border-radius: 10px;
      padding: 0.75rem;
      font-weight: 600;
      letter-spacing: 0.5px;
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      border: none;
      transition: all 0.3s ease;
    }
    
    .btn-success:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
    }
    
    .form-label {
      font-weight: 500;
      color: #495057;
    }
    
    .login-icon {
      display: flex;
      justify-content: center;
      margin-bottom: 1.5rem;
    }
    
    .login-icon i {
      font-size: 3rem;
      color: #28a745;
      background: rgba(40, 167, 69, 0.1);
      padding: 1rem;
      border-radius: 50%;
    }
    
    .input-group-text {
      background-color: #f8f9fa;
      border-right: none;
      border-radius: 10px 0 0 10px;
    }
    
    .input-group .form-control {
      border-left: none;
      border-radius: 0 10px 10px 0;
    }
    
    .register-link {
      color: #28a745;
      text-decoration: none;
      font-weight: 500;
      transition: color 0.3s ease;
    }
    
    .register-link:hover {
      color: #218838;
      text-decoration: underline;
    }
    
    .footer-link {
      margin-top: 1rem;
      text-align: center;
    }
  </style>
</head>
<body>
<div class="container d-flex justify-content-center align-items-center" style="height: 100vh;">
  <div class="row justify-content-center w-100">
    <div class="col-md-6 col-lg-5">
      <div class="login-card">
        <div class="card-header text-white">
          <i class="fas fa-hands-helping me-2"></i>志愿者平台登录
        </div>
        <div class="card-body">
          <div class="login-icon">
            <i class="fas fa-user-circle"></i>
          </div>
          <form action="login-servlet" method="post">
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
            <div class="text-center mt-4">
              没有账号？<a href="register.jsp" class="register-link">立即注册</a>
            </div>
          </form>
        </div>
      </div>
      <div class="footer-link">
        <a href="index.jsp" class="text-decoration-none text-secondary">
          <i class="fas fa-home me-1"></i>返回首页
        </a>
        <a href="admin_login.jsp" class="text-decoration-none text-secondary ms-3">
          <i class="fas fa-user-shield me-1"></i>管理员登录
        </a>
      </div>
    </div>
  </div>
</div>
</body>
</html>