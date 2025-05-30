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

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        // PrintWriter out = response.getWriter(); // 不再需要直接输出HTML

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
                    // 重定向到个人中心页面
                    response.sendRedirect("volunteer_center.jsp");
                } else {
                    // 登录失败，设置错误信息并转发到错误页面
                    request.setAttribute("errorMessage", "登录失败，用户名或密码错误！");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            // 数据库或其他系统错误，设置错误信息并转发到错误页面
            e.printStackTrace(); // 记录日志
            request.setAttribute("errorMessage", "登录失败，系统错误：" + e.getMessage()); // 您提到的这行代码
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
        // out.close(); // 不再需要在这里关闭
    }
}
