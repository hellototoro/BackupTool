# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Git版本控制管理
- 完整的项目文档
- 贡献指南和许可证

## [1.0.0] - 2025-05-25

### Added
- 初始版本发布
- Qt 6 + QML现代化GUI界面
- CMake构建系统
- 扁平化无边框设计
- 圆角窗口边框
- 深色/浅色主题切换
- Windows软件列表备份功能
- WSL发行版备份功能
- Miniforge环境备份功能
- OhMyBash配置备份功能
- OhMyPosh配置备份功能
- 系统配置备份功能
- 实时进度显示
- 自定义标题栏（拖拽、最小化、关闭）

### Changed
- 从qmake迁移到CMake构建系统
- 统一构建产物到build目录
- 优化图标和文字布局，修复重叠问题

### Fixed
- 修复界面元素重叠问题
- 修复构建脚本路径问题
- 修复窗口边框显示问题

### Technical Details
- 使用Qt 6.8.2
- 支持C++17标准
- MinGW编译器支持
- 跨平台CMake构建系统
