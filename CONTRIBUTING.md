# 贡献指南

感谢您对BackupTool项目的兴趣！我们欢迎所有形式的贡献。

## 如何贡献

### 报告问题
- 在GitHub Issues中报告bug
- 提供详细的问题描述和重现步骤
- 包含系统信息和错误日志

### 功能请求
- 在Issues中提交功能请求
- 详细描述期望的功能
- 解释为什么这个功能有用

### 代码贡献

1. **Fork项目**
   ```bash
   git clone https://github.com/yourusername/BackupTool.git
   ```

2. **创建功能分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **编写代码**
   - 遵循现有的代码风格
   - 添加必要的注释
   - 确保代码通过编译

4. **测试**
   ```powershell
   .\build.ps1
   .\run.ps1
   ```

5. **提交更改**
   ```bash
   git add .
   git commit -m "feat: 添加您的功能描述"
   ```

6. **推送分支**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **创建Pull Request**

## 代码规范

### C++代码
- 使用4个空格缩进
- 类名使用PascalCase
- 变量名使用camelCase
- 常量使用UPPER_CASE

### QML代码
- 使用4个空格缩进
- 属性名使用camelCase
- 组件名使用PascalCase

### 提交消息格式
```
type(scope): 简短描述

详细描述（可选）

type包括：
- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式
- refactor: 重构
- test: 测试
- chore: 构建过程或辅助工具的变动
```

## 开发环境设置

1. 安装Qt 6.0+
2. 安装CMake 3.16+
3. 安装MinGW编译器
4. 克隆项目并构建

## 联系方式

如有问题，请通过以下方式联系：
- GitHub Issues
- Email: your-email@example.com
