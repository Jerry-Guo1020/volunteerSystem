package com.example.volunteersystem;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 使用数据库校验逻辑
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM user WHERE username=? AND password=?")) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // 登录成功，创建会话
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    // 重定向到项目列表页面
                    response.sendRedirect("volunteer_center.jsp");
                } else {
                    out.println("<html><body><h2>登录失败，用户名或密码错误！</h2><a href='login.jsp'>返回登录</a></body></html>");
                }
            }
        } catch (Exception e) {
            out.println("<html><body><h2>登录失败，系统错误！</h2><p>" + e.getMessage() + "</p><a href='login.jsp'>返回登录</a></body></html>");
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}
