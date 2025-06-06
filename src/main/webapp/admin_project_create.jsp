<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.volunteersystem.JDBCUtil" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    String pointsStr = request.getParameter("points");
    String publisher = request.getParameter("publisher");
    String startTime = request.getParameter("start_time");
    String endTime = request.getParameter("end_time");
    String message = "";

    if(name != null && description != null && pointsStr != null && publisher != null && startTime != null && endTime != null){
        try(Connection conn = JDBCUtil.getConnection()){
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO project (name, description, points, publisher, start_time, end_time, status) VALUES (?, ?, ?, ?, ?, ?, 0)"
            );
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setInt(3, Integer.parseInt(pointsStr));
            ps.setString(4, publisher);
            ps.setString(5, startTime.replace('T', ' '));
            ps.setString(6, endTime.replace('T', ' '));
            int result = ps.executeUpdate();
            if(result > 0){
                message = "活动创建成功！";
            }else{
                message = "活动创建失败！";
            }
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
            message = "数据库异常：" + e.getMessage();
        }
    }else{
        message = "参数不完整！";
    }
    response.sendRedirect("admin_project_manage.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>