package com.example.volunteersystem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/add-project-servlet") // 对应 add_project.jsp 中的 form action
public class AddProjectServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // 设置请求编码，防止中文乱码
        response.setCharacterEncoding("UTF-8"); // 设置响应编码
        response.setContentType("text/html;charset=UTF-8"); // 设置响应内容类型

        // 获取表单提交的数据
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String pointsStr = request.getParameter("points");
        int points = 0;
        String message = ""; // 用于存储操作结果消息

        // 简单的输入验证
        if (name == null || name.trim().isEmpty() || description == null || description.trim().isEmpty() || pointsStr == null || pointsStr.trim().isEmpty()) {
            message = "活动名称、描述和积分不能为空！";
            request.setAttribute("message", message);
            request.getRequestDispatcher("/add_project.jsp").forward(request, response); // 返回发布页面并显示错误
            return;
        }

        try {
            points = Integer.parseInt(pointsStr);
            if (points < 0) {
                 message = "积分不能为负数！";
                 request.setAttribute("message", message);
                 request.getRequestDispatcher("/add_project.jsp").forward(request, response); // 返回发布页面并显示错误
                 return;
            }
        } catch (NumberFormatException e) {
            message = "积分必须是有效的数字！";
            request.setAttribute("message", message);
            request.getRequestDispatcher("/add_project.jsp").forward(request, response); // 返回发布页面并显示错误
            return;
        }


        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // 获取数据库连接
            conn = JDBCUtil.getConnection();

            // 准备 SQL 插入语句
            String sql = "INSERT INTO project (name, description, points) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql);

            // 设置参数
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setInt(3, points);

            // 执行插入操作
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                message = "活动发布成功！";
                // 发布成功后重定向到活动列表页面
                response.sendRedirect("project_list.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            } else {
                message = "活动发布失败，请重试。";
                request.setAttribute("message", message);
                request.getRequestDispatcher("/add_project.jsp").forward(request, response); // 返回发布页面并显示错误
            }

        } catch (SQLException e) {
            message = "数据库操作失败：" + e.getMessage();
            e.printStackTrace(); // 打印堆栈跟踪以便调试
            request.setAttribute("message", message);
            request.getRequestDispatcher("/add_project.jsp").forward(request, response); // 返回发布页面并显示错误
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            // 关闭数据库资源
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 如果需要处理 GET 请求，可以添加 doGet 方法，但对于表单提交通常只用 POST
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("add_project.jsp"); // GET 请求重定向到表单页面
     }
}