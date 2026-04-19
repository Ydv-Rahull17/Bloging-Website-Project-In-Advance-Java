-- Creates database and all required tables for Hariom Web Application
CREATE DATABASE IF NOT EXISTS mspblog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mspblog;

CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(120) NOT NULL,
    email VARCHAR(190) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_pic VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS blog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    content MEDIUMTEXT NOT NULL,
    image VARCHAR(255) DEFAULT NULL,
    author_email VARCHAR(190) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_blog_author_email (author_email),
    INDEX idx_blog_category (category),
    CONSTRAINT fk_blog_author_email
        FOREIGN KEY (author_email) REFERENCES user(email)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    blog_id INT NOT NULL,
    user_email VARCHAR(190) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_likes_blog_user (blog_id, user_email),
    INDEX idx_likes_user_email (user_email),
    CONSTRAINT fk_likes_blog
        FOREIGN KEY (blog_id) REFERENCES blog(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_likes_user
        FOREIGN KEY (user_email) REFERENCES user(email)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    blog_id INT NOT NULL,
    user_email VARCHAR(190) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_comments_blog_id (blog_id),
    INDEX idx_comments_user_email (user_email),
    CONSTRAINT fk_comments_blog
        FOREIGN KEY (blog_id) REFERENCES blog(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_comments_user
        FOREIGN KEY (user_email) REFERENCES user(email)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(190) NOT NULL,
    token VARCHAR(140) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    used TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_reset_email (user_email),
    INDEX idx_reset_token (token)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(190) NOT NULL,
    firstname VARCHAR(120) NOT NULL,
    lastname VARCHAR(120) NOT NULL,
    country VARCHAR(100) NOT NULL,
    user_message TEXT NOT NULL,
    admin_reply TEXT DEFAULT NULL,
    is_replied TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    replied_at TIMESTAMP NULL DEFAULT NULL,
    INDEX idx_contact_user_email (user_email),
    INDEX idx_contact_created_at (created_at)
) ENGINE=InnoDB;
