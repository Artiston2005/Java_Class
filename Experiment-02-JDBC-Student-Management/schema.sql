-- Database setup for Experiment 2
CREATE DATABASE IF NOT EXISTS college;
USE college;

CREATE TABLE IF NOT EXISTS student (
    roll_no VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    branch VARCHAR(100) NOT NULL,
    gender VARCHAR(20) NOT NULL
);
