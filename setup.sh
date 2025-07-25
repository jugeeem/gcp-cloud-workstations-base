#!/bin/bash

# プロジェクトIDの設定（環境に合わせて変更してください）
PROJECT_ID=$(gcloud config get-value project)
REGION="asia-northeast1"
REPOSITORY_NAME="cloud-workstations"
IMAGE_NAME="custom-workstation"

echo "プロジェクトID: $PROJECT_ID"
echo "リージョン: $REGION"
echo "リポジトリ名: $REPOSITORY_NAME"

# 必要なAPIの有効化
echo "必要なAPIを有効化しています..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable workstations.googleapis.com

# Artifact Registryリポジトリの作成
echo "Artifact Registryリポジトリを作成しています..."
gcloud artifacts repositories create $REPOSITORY_NAME \
    --repository-format=docker \
    --location=$REGION \
    --description="Cloud Workstations custom images"

# Docker認証の設定
echo "Docker認証を設定しています..."
gcloud auth configure-docker $REGION-docker.pkg.dev

echo "セットアップが完了しました！"
echo "次のコマンドでビルドを開始できます："
echo "gcloud builds submit --config cloudbuild.yaml ."
