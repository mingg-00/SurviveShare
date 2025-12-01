CREATE DATABASE IF NOT EXISTS surviveshare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE surviveshare;

-- 기존 테이블 삭제 (재설계) - 외래키 제약조건 때문에 순서 중요
DROP TABLE IF EXISTS tip_recommendations;
DROP TABLE IF EXISTS recipe_steps;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS rentals;
DROP TABLE IF EXISTS challenges;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS tips;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS users;

-- 1) sessions (익명 사용자)
CREATE TABLE sessions (
    session_id VARCHAR(50) PRIMARY KEY,
    level_score INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2) tips (자취 꿀팁)
CREATE TABLE tips (
    tip_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    image_path VARCHAR(255),
    hashtags VARCHAR(255),
    recommend_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE
);

-- 3) items (공유 물품)
CREATE TABLE items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_path VARCHAR(255),
    price DECIMAL(10,2),
    meet_time DATETIME,
    meet_place VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE
);

-- 4) rentals (대여 요청)
CREATE TABLE rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    owner_session VARCHAR(50) NOT NULL,
    borrower_session VARCHAR(50) NOT NULL,
    status ENUM('pending','accepted','rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE,
    FOREIGN KEY (owner_session) REFERENCES sessions(session_id) ON DELETE CASCADE,
    FOREIGN KEY (borrower_session) REFERENCES sessions(session_id) ON DELETE CASCADE
);

-- 5) challenges (미니 챌린지)
CREATE TABLE challenges (
    challenge_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(50) NOT NULL,
    description VARCHAR(255) NOT NULL,
    image_path VARCHAR(255),
    points INT DEFAULT 5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE
);

-- 6) tip_recommendations (꿀팁 추천 기록)
CREATE TABLE tip_recommendations (
    recommendation_id INT AUTO_INCREMENT PRIMARY KEY,
    tip_id INT NOT NULL,
    session_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tip_id) REFERENCES tips(tip_id) ON DELETE CASCADE,
    FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE,
    UNIQUE KEY unique_recommendation (tip_id, session_id)
);

-- 7) recipes (레시피)
CREATE TABLE recipes (
    recipe_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    image_path VARCHAR(255),
    ingredients TEXT NOT NULL,
    time_required INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE
);

-- 8) recipe_steps (레시피 조리 단계)
CREATE TABLE recipe_steps (
    step_id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT NOT NULL,
    step_number INT NOT NULL,
    instruction TEXT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);
