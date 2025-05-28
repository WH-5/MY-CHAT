#!/bin/bash

echo "🔄 停止并删除 MY-CHAT 的所有容器..."
docker-compose down --volumes --remove-orphans

echo "🗑️ 删除所有与 MY-CHAT 相关的镜像..."
docker images | grep 'my-chat' | awk '{print $3}' | xargs -r docker rmi

echo "🧹 清理未使用的卷..."
docker volume prune -f

echo "✅ MY-CHAT 所有容器、镜像和卷已清理完成。"