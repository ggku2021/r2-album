#!/bin/bash

# =======================================================
# GitHub 图床安全发布脚本 (核心功能)
# 作用：1. 拉取 2. 提交 3. 推送 (处理增、改、删)
# =======================================================

# 配置 Git 默认远程和分支
REMOTE="origin"
BRANCH="main"

echo "---"
echo "⬇️ 正在拉取远程最新数据以避免冲突..."
# 执行 git pull，合并远程的更改
git pull "$REMOTE" "$BRANCH"

# 检查拉取是否成功 (若失败，通常是冲突，需要用户手动解决)
if [ $? -ne 0 ]; then
    echo "---"
    echo "⚠️ 警告：拉取操作失败或检测到冲突！"
    echo "请手动解决冲突后，再重新运行此脚本。"
    exit 1
fi

# 检查是否有未提交的本地更改 (包括删除和新增)
if git diff --quiet && git diff --cached --quiet; then
    echo "✅ 仓库状态良好，没有检测到新的本地更改。无需发布。"
    exit 0
fi

# 询问用户是否需要自定义提交信息
read -p "请输入提交信息 (留空则使用默认信息): " CUSTOM_MESSAGE

# 生成提交信息
if [ -z "$CUSTOM_MESSAGE" ]; then
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    COMMIT_MESSAGE="图床自动更新: 添加/修改/删除文件于 $TIMESTAMP"
else
    COMMIT_MESSAGE="$CUSTOM_MESSAGE"
fi

echo "---"
echo "➡️ 正在准备提交..."

# 暂存所有更改 (git add -A 会自动处理所有新增、修改和删除的文件)
echo "✨ 正在执行：git add -A (暂存所有更改)"
git add -A

# 执行提交操作
echo "💬 提交信息：$COMMIT_MESSAGE"
git commit -m "$COMMIT_MESSAGE"

# 执行推送操作
echo "---"
echo "🚀 正在执行：git push"
git push "$REMOTE" "$BRANCH"

# 完成
if [ $? -eq 0 ]; then
    echo "---"
    echo "🎉 恭喜！图床更新已成功发布到 GitHub！"
else
    echo "---"
    echo "❌ 警告：推送失败。请检查您的网络连接或 Git 权限。"
fi

exit 0