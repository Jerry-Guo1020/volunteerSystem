package com.example.volunteersystem;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
   

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email"); 
        String realname = request.getParameter("realname");

        // 添加数据库注册逻辑
        if (username != null && !username.isEmpty() &&
            password != null && !password.isEmpty() &&
            email != null && !email.isEmpty()&&
            realname != null && !realname.isEmpty()) {
            try (Connection conn = JDBCUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO user (username, password, email, realname, points) VALUES (?, ?, ?, ?, 0)")) {
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, email); 
                ps.setString(4, realname);
                int result = ps.executeUpdate();
                if (result > 0) {
                    // 注册成功，重定向到登录页面
                    response.sendRedirect("login.jsp");
                } else {
                    // 注册失败，请稍后再试
                    request.setAttribute("errorMessage", "注册失败，请稍后再试！");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
            } catch (Exception e) {
                // 数据库或其他系统错误
                e.printStackTrace(); // 记录日志
                request.setAttribute("errorMessage", "注册失败，系统错误：" + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } else {
            // 输入无效
            request.setAttribute("errorMessage", "注册失败，请检查输入！");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }

    }
}
