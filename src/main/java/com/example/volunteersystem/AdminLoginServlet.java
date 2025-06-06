package com.example.volunteersystem;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM admin WHERE username=? AND password=?")) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("adminUsername", username);
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    request.setAttribute("message", "管理员登录失败，请检查用户名和密码。");
                    request.getRequestDispatcher("admin_login.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "系统错误，请稍后再试。");
            request.getRequestDispatcher("admin_login.jsp").forward(request, response);
        }
    }
}