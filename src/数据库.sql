-- 创建用户表 (user)
-- 存储用户信息，包括用户名、密码和积分
CREATE TABLE IF NOT EXISTS user (
                                    id INT AUTO_INCREMENT PRIMARY KEY,
                                    username VARCHAR(50) NOT NULL UNIQUE,
                                    password VARCHAR(255) NOT NULL, -- 存储加密后的密码
                                    points INT DEFAULT 0-- 用户积分，默认为0
    -- 您可以根据需要添加更多字段，例如：
    -- email VARCHAR(100),
    -- phone VARCHAR(20),
    -- registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建志愿项目表 (project)
-- 存储志愿项目的详细信息
CREATE TABLE IF NOT EXISTS project (
                                       id INT AUTO_INCREMENT PRIMARY KEY,
                                       name VARCHAR(255) NOT NULL,
                                       description TEXT,
                                       points INT DEFAULT 0, -- 完成项目获得的积分
                                       publisher VARCHAR(100), -- 发布组织或个人
                                       start_time DATETIME, -- 项目开始时间
                                       end_time DATETIME, -- 项目结束时间
                                       category VARCHAR(50) -- 项目类别 (例如：环保, 教育, 社区服务)
    -- 您可以根据需要添加更多字段，例如：
    -- location VARCHAR(255),
    -- required_volunteers INT,
    -- current_volunteers INT DEFAULT 0
);

-- 创建报名记录表 (signup)
-- 存储用户报名参加项目的记录，以及完成状态
CREATE TABLE IF NOT EXISTS signup (
                                      id INT AUTO_INCREMENT PRIMARY KEY,
                                      user_id INT, -- 报名用户ID，外键关联user表
                                      project_id INT, -- 报名项目ID，外键关联project表
                                      signup_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 报名时间
                                      completed BOOLEAN DEFAULT FALSE, -- 项目是否完成
    -- 添加外键约束
                                      FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
                                      FOREIGN KEY (project_id) REFERENCES project(id) ON DELETE CASCADE,
    -- 确保同一个用户不会重复报名同一个项目
                                      UNIQUE (user_id, project_id)
);

-- 创建积分商城商品表 (mall_items)
-- 存储积分商城中可兑换的商品信息
CREATE TABLE IF NOT EXISTS mall_items (
                                          id INT AUTO_INCREMENT PRIMARY KEY,
                                          name VARCHAR(255) NOT NULL,
                                          description TEXT,
                                          points_cost INT NOT NULL, -- 兑换所需积分
                                          image_url VARCHAR(255), -- 商品图片URL
                                          is_featured BOOLEAN DEFAULT FALSE -- 是否是精选商品
);

-- 创建积分兑换记录表 (redemption_records)
-- 存储用户兑换商品的记录 (可选，但推荐用于追踪)
CREATE TABLE IF NOT EXISTS redemption_records (
                                                  id INT AUTO_INCREMENT PRIMARY KEY,
                                                  user_id INT, -- 兑换用户ID，外键关联user表
                                                  item_id INT, -- 兑换商品ID，外键关联mall_items表
                                                  points_used INT NOT NULL, -- 兑换使用的积分
                                                  redemption_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 兑换时间
    -- 添加外键约束
                                                  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
                                                  FOREIGN KEY (item_id) REFERENCES mall_items(id) ON DELETE CASCADE
);

-- 添加更多生活用品示例数据
INSERT INTO mall_items (name, description, points_cost, image_url, is_featured) VALUES
                                                                                    ('精美笔记本', '记录生活点滴，学习工作好帮手。', 180, 'https://via.placeholder.com/150x150?text=Notebook', FALSE),
                                                                                    ('便携水杯', '健康饮水，随身携带。', 220, 'https://via.placeholder.com/150x150?text=Water+Bottle', FALSE),
                                                                                    ('创意书签', '让阅读更有趣。', 80, 'https://via.placeholder.com/150x150?text=Bookmark', FALSE),
                                                                                    ('多功能笔', '一支笔满足多种书写需求。', 120, 'https://via.placeholder.com/150x150?text=Pen', FALSE),
                                                                                    ('迷你手电筒', '小巧实用，应急照明。', 150, 'https://via.placeholder.com/150x150?text=Flashlight', FALSE),
                                                                                    ('卡通钥匙扣', '可爱造型，装饰你的钥匙。', 50, 'https://via.placeholder.com/150x150?text=Keychain', FALSE),
                                                                                    ('手机支架', '解放双手，追剧更轻松。', 100, 'https://via.placeholder.com/150x150?text=Phone+Stand', FALSE),
                                                                                    ('数据线收纳器', '告别杂乱，保持桌面整洁。', 70, 'https://via.placeholder.com/150x150?text=Cable+Organizer', FALSE);