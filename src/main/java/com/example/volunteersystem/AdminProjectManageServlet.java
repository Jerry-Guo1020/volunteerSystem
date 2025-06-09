package com.example.volunteersystem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin_project_manage") // 映射到这个URL
public class AdminProjectManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        List<Map<String, Object>> projectList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = JDBCUtil.getConnection();
            // 查询所有项目信息
            String sql = "SELECT id, name, publisher, start_time, end_time, points, status FROM project";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> project = new HashMap<>();
                project.put("id", rs.getInt("id"));
                project.put("name", rs.getString("name"));
                project.put("publisher", rs.getString("publisher"));
                project.put("start_time", rs.getTimestamp("start_time")); // 根据数据库字段类型调整
                project.put("end_time", rs.getTimestamp("end_time"));     // 根据数据库字段类型调整
                project.put("points", rs.getInt("points"));
                project.put("status", rs.getInt("status"));
                projectList.add(project);
            }

            // 将项目列表设置到请求属性中
            request.setAttribute("projectList", projectList);

            // 转发到JSP页面显示
            request.getRequestDispatcher("admin_project_manage.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(); // 记录日志
            // 发生错误时，可以转发到错误页面或在当前页面显示错误信息
            request.setAttribute("errorMessage", "加载项目列表失败：" + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response); // 或者转发回admin_project_manage.jsp并显示错误
        } finally {
            JDBCUtil.close(conn, ps, rs);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 如果admin_project_manage.jsp页面有POST请求（例如搜索、过滤等），可以在这里处理
        // 当前页面主要用于显示，所以只实现了GET方法
        doGet(request, response);
    }
}