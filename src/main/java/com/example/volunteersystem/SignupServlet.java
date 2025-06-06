package com.example.volunteersystem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/signup-servlet") // 映射到 /signup-servlet URL
public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // 设置请求编码
        response.setCharacterEncoding("UTF-8"); // 设置响应编码
        response.setContentType("text/html;charset=UTF-8"); // 设置响应内容类型

        // 获取表单提交的数据
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password"); // 假设注册表单有确认密码字段
        String message = ""; // 用于存储操作结果消息

        // 简单的输入验证
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            message = "用户名、密码和确认密码不能为空！";
            request.setAttribute("message", message);
            request.getRequestDispatcher("/signup.jsp").forward(request, response); // 返回注册页面并显示错误
            return;
        }

        if (!password.equals(confirmPassword)) {
            message = "两次输入的密码不一致！";
            request.setAttribute("message", message);
            request.getRequestDispatcher("/signup.jsp").forward(request, response); // 返回注册页面并显示错误
            return;
        }

        // 可以在这里添加更多密码复杂度验证，例如长度、包含字符类型等

        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psInsert = null;
        ResultSet rs = null;

        try {
            conn = JDBCUtil.getConnection();
            conn.setAutoCommit(false); // 开启事务

            // 检查用户名是否已存在
            String checkSql = "SELECT id FROM user WHERE username = ?";
            psCheck = conn.prepareStatement(checkSql);
            psCheck.setString(1, username);
            rs = psCheck.executeQuery();

            if (rs.next()) {
                // 用户名已存在
                message = "用户名 '" + username + "' 已被注册，请选择其他用户名。";
                request.setAttribute("message", message);
                conn.rollback(); // 回滚事务
                request.getRequestDispatcher("/signup.jsp").forward(request, response); // 返回注册页面并显示错误
                return;
            }

            // 用户名可用，插入新用户记录
            // 假设 user 表有 id (自增主键), username, password, points (默认0) 字段
            String insertSql = "INSERT INTO user (username, password, points) VALUES (?, ?, 0)";
            psInsert = conn.prepareStatement(insertSql);
            psInsert.setString(1, username);
            psInsert.setString(2, password); // 注意：实际应用中密码应该加密存储！这里为简化示例未加密。

            int rowsAffected = psInsert.executeUpdate();

            if (rowsAffected > 0) {
                conn.commit(); // 提交事务
                message = "注册成功！请登录。";
                // 注册成功后重定向到登录页面
                response.sendRedirect("login.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            } else {
                conn.rollback(); // 回滚事务
                message = "注册失败，请重试。";
                request.setAttribute("message", message);
                request.getRequestDispatcher("/signup.jsp").forward(request, response); // 返回注册页面并显示错误
            }

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback(); // 发生异常时回滚事务
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            message = "数据库操作失败：" + e.getMessage();
            e.printStackTrace(); // 打印堆栈跟踪以便调试
            request.setAttribute("message", message);
            request.getRequestDispatcher("/signup.jsp").forward(request, response); // 返回注册页面并显示错误
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            // 关闭数据库资源
            try {
                if (rs != null) rs.close();
                if (psCheck != null) psCheck.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (psInsert != null) psInsert.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 如果需要处理 GET 请求，可以添加 doGet 方法
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 通常 GET 请求直接显示注册页面
        request.getRequestDispatcher("/signup.jsp").forward(request, response);
    }
}