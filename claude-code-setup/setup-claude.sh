#!/bin/bash

echo "🚀 Claude Code Node.js環境をセットアップしています..."

# 作業ディレクトリに移動
cd /home/user/workspace

# package.jsonが存在しない場合は作成
if [ ! -f package.json ]; then
    echo "📦 Node.jsプロジェクトを初期化しています..."
    npm init -y
fi

# 必要なパッケージをインストール
echo "📥 必要なパッケージをインストールしています..."
npm install @anthropic-ai/sdk dotenv
npm install -D @types/node typescript ts-node nodemon eslint prettier

# Claude Code設定ファイルをコピー
echo "📋 Claude Code設定ファイルをセットアップしています..."
cp /home/user/.config/claude-code/claude-client.js ./
cp /home/user/.config/claude-code/test-claude.js ./

# .envファイルのテンプレートを作成
if [ ! -f .env ]; then
    echo "📝 .envファイルのテンプレートを作成しています..."
    cat > .env << EOF
# Anthropic API Key for Claude
# Get your API key from: https://console.anthropic.com/
ANTHROPIC_API_KEY=your_api_key_here

# Optional: Model configuration
CLAUDE_MODEL=claude-3-sonnet-20240229
EOF
fi

# TypeScript設定ファイル
if [ ! -f tsconfig.json ]; then
    echo "⚙️  TypeScript設定を作成しています..."
    cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "node",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
fi

# README.mdを作成
cat > README.md << EOF
# Claude Code - Node.js Environment

Cloud Workstations上でClaude AIを使用するためのNode.js環境です。

## セットアップ

1. APIキーの設定:
   \`\`\`bash
   # .envファイルを編集してAPIキーを設定
   nano .env
   \`\`\`

2. 接続テスト:
   \`\`\`bash
   npm run test
   \`\`\`

3. Claude Clientの使用:
   \`\`\`javascript
   import ClaudeClient from './claude-client.js';
   
   const claude = new ClaudeClient();
   const response = await claude.sendMessage('Hello, Claude!');
   console.log(response);
   \`\`\`

## スクリプト

- \`npm start\`: Claude Clientを起動
- \`npm run dev\`: 開発モード（ファイル変更を監視）
- \`npm run test\`: Claude API接続テスト

## 機能

- ✅ Claude AI APIとの通信
- ✅ コード生成
- ✅ コードレビュー
- ✅ TypeScriptサポート
- ✅ 開発ツール完備
EOF

echo "✅ Claude Code Node.js環境のセットアップが完了しました！"
echo ""
echo "🔑 次のステップ:"
echo "1. .envファイルを編集してANTHROPIC_API_KEYを設定してください"
echo "2. 'npm run test' でClaude APIへの接続をテストしてください"
echo ""
echo "📚 使用方法については README.md を参照してください"
