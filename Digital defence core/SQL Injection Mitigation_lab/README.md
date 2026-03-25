This lab demonstrates SQL injection vulnerabilities in web applications and how to prevent them using parameterized queries, input validation, and secure coding practices. You will create a vulnerable Flask application, build a SQL injection detection tool, then develop a secure application that mitigates SQL injection attacks.

Objectives

By the end of this lab, you will be able to:

Identify SQL injection vulnerabilities in web applications
Understand how SQL injection attacks exploit insecure queries
Implement parameterized queries to prevent SQL injection
Apply input validation and secure coding practices
Test applications for SQL injection vulnerabilities

Tasks Covered
Create vulnerable web application
Perform manual SQL injection attacks
Build automated SQL injection scanner
Create secure application with parameterized queries
Test secure application against SQL injection
Compare vulnerable vs secure application
SQL Injection Test Payloads
admin'--
' OR '1'='1
'; DROP TABLE users;--
' UNION SELECT username,password,email FROM users--
Expected Outcomes

After completing this lab, you should have:

A vulnerable application demonstrating SQL injection
A SQL injection detection script
A secure application using parameterized queries
Test script proving SQL injection protection
Understanding of secure database coding practices
Key Security Concepts
Parameterized queries
Input validation
Password hashing
Error handling
Least privilege principle
