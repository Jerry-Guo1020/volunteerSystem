<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>志愿者平台注册</title>
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

        .register-card {
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
            max-width: 450px;
            width: 100%;
            margin: 0 auto;
        }

        .register-card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
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
            box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.2);
            border-color: #0d6efd;
        }

        .btn-primary {
            border-radius: 10px;
            padding: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
        }

        .form-label {
            font-weight: 500;
            color: #495057;
        }

        .register-icon {
            display: flex;
            justify-content: center;
            margin-bottom: 1.5rem;
        }

        .register-icon i {
            font-size: 3rem;
            color: #0d6efd;
            background: rgba(13, 110, 253, 0.1);
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

        .login-link {
            color: #0d6efd;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .login-link:hover {
            color: #0a58ca;
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
            <div class="register-card">
                <div class="card-header text-white">
                    <i class="fas fa-user-plus me-2"></i>志愿者平台注册
                </div>
                <div class="card-body">
                    <div class="register-icon">
                        <i class="fas fa-user-edit"></i>
                    </div>
                    <form action="register-servlet" method="post">
                        <div class="mb-4">
                            <label for="username" class="form-label">用户名</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="username" name="username" placeholder="请设置用户名" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="realname" class="form-label">姓名</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-address-card"></i></span> 
                                <input type="text" class="form-control" id="realname" name="realname" placeholder="请输入您的真实姓名" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="email" class="form-label">邮箱</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email" placeholder="请输入邮箱" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label">密码</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="请设置密码" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 mb-3">
                            <i class="fas fa-user-plus me-2"></i>注册
                        </button>
                        <div class="text-center mt-4">
                            已有账号？<a href="login.jsp" class="login-link">立即登录</a>
                        </div>
                    </form>
                </div>
            </div>
            <div class="footer-link">
                <a href="index.jsp" class="text-decoration-none text-secondary">
                    <i class="fas fa-home me-1"></i>返回首页
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>