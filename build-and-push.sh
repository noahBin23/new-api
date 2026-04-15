#!/bin/bash

# Docker 镜像构建和推送脚本
# Usage: ./build-and-push.sh [tag]
# Example: ./build-and-push.sh latest
#          ./build-and-push.sh v1.0.0

set -e  # 遇到错误立即退出

# 配置
IMAGE_NAME="register.blessedbin.top/new-api"
DEFAULT_TAG="latest"
DOCKERFILE="Dockerfile"

# 获取标签参数，默认为 latest
TAG=${1:-$DEFAULT_TAG}
FULL_IMAGE="${IMAGE_NAME}:${TAG}"

echo "=========================================="
echo "Docker 镜像构建和推送"
echo "=========================================="
echo "镜像名称: ${FULL_IMAGE}"
echo "Dockerfile: ${DOCKERFILE}"
echo "=========================================="

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "错误: Docker 未运行，请先启动 Docker Desktop"
    exit 1
fi

# 检查 Dockerfile 是否存在
if [ ! -f "${DOCKERFILE}" ]; then
    echo "错误: 找不到 ${DOCKERFILE}"
    exit 1
fi

# 构建镜像
echo ""
echo ">>> 开始构建镜像..."
docker build -t "${FULL_IMAGE}" -f "${DOCKERFILE}" .

if [ $? -eq 0 ]; then
    echo "✓ 镜像构建成功"
else
    echo "✗ 镜像构建失败"
    exit 1
fi

# 显示镜像信息
echo ""
echo ">>> 镜像信息:"
docker images "${IMAGE_NAME}" | head -2

# 推送镜像
echo ""
echo ">>> 开始推送镜像到 ${FULL_IMAGE}..."
docker push "${FULL_IMAGE}"

if [ $? -eq 0 ]; then
    echo "✓ 镜像推送成功"
else
    echo "✗ 镜像推送失败"
    exit 1
fi

echo ""
echo "=========================================="
echo "完成! 镜像已推送到: ${FULL_IMAGE}"
echo "=========================================="
