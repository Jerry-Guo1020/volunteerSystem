package com.example.volunteersystem;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 添加数据库注册逻辑
        if (username != null && !username.isEmpty() && password != null && !password.isEmpty()) {
            try (Connection conn = JDBCUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement("INSERT INTO user (username, password, points) VALUES (?, ?, 0)")) {
                ps.setString(1, username);
                ps.setString(2, password);
                int result = ps.executeUpdate();
                if (result > 0) {
                    out.println("<html><body><h2>注册成功！</h2><a href='login.jsp'>去登录</a></body></html>");
                } else {
                    out.println("<html><body><h2>注册失败，请稍后再试！</h2><a href='register.jsp'>返回注册</a></body></html>");
                }
            } catch (Exception e) {
                out.println("<html><body><h2>注册失败，系统错误！</h2><p>" + e.getMessage() + "</p><a href='register.jsp'>返回注册</a></body></html>");
                e.printStackTrace();
            }
        } else {
            out.println("<html><body><h2>注册失败，请检查输入！</h2><a href='register.jsp'>返回注册</a></body></html>");
        }
        out.close();
    }
}
