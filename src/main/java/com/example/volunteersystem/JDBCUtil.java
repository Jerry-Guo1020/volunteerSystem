package com.example.volunteersystem;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class JDBCUtil {
    // 简化URL参数，移除可能导致问题的参数
    private static final String URL = "jdbc:mysql://localhost:3306/volunteer_platform?useSSL=false";
    private static final String USER = "root"; 
    private static final String PASSWORD = "jerryguo1020@@"; 

    static {
        try {
            // 确保驱动正确加载
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL驱动加载成功");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("MySQL JDBC驱动加载失败", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("数据库连接成功");
            return conn;
        } catch (SQLException e) {
            System.out.println("数据库连接失败: " + e.getMessage());
            throw e;
        }
    }
}
