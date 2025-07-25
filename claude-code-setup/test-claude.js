/**
 * Claude Code テストスクリプト
 */

import ClaudeClient from './claude-client.js';

async function testClaudeConnection() {
    try {
        console.log('Claude APIへの接続をテストしています...');
        
        const claude = new ClaudeClient();
        
        // 簡単なテストメッセージ
        const response = await claude.sendMessage('Hello, Claude! Please respond with "Connection successful!"');
        
        console.log('✅ Claude APIに正常に接続されました');
        console.log('応答:', response);
        
        // コード生成テスト
        console.log('\n📝 コード生成テストを実行中...');
        const code = await claude.generateCode('Create a simple "Hello World" function in JavaScript');
        console.log('生成されたコード:');
        console.log(code);
        
    } catch (error) {
        console.error('❌ テストに失敗しました:', error.message);
        
        if (error.message.includes('ANTHROPIC_API_KEY')) {
            console.log('\n💡 解決方法:');
            console.log('1. .envファイルを作成してANTHROPIC_API_KEYを設定してください');
            console.log('2. または環境変数として export ANTHROPIC_API_KEY=your_key_here を実行してください');
        }
    }
}

// テスト実行
testClaudeConnection();
