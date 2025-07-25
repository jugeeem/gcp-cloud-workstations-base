/**
 * Claude Code Node.js Client
 * Anthropic APIを使用してClaude AIと対話するためのクライアント
 */

import Anthropic from '@anthropic-ai/sdk';
import dotenv from 'dotenv';

// 環境変数の読み込み
dotenv.config();

class ClaudeClient {
    constructor() {
        this.apiKey = process.env.ANTHROPIC_API_KEY;
        
        if (!this.apiKey) {
            throw new Error('ANTHROPIC_API_KEY環境変数が設定されていません');
        }
        
        this.anthropic = new Anthropic({
            apiKey: this.apiKey,
        });
    }

    /**
     * Claudeにメッセージを送信
     * @param {string} message - 送信するメッセージ
     * @param {string} model - 使用するモデル（デフォルト: claude-3-sonnet-20240229）
     * @returns {Promise<string>} - Claudeからの応答
     */
    async sendMessage(message, model = 'claude-3-sonnet-20240229') {
        try {
            const response = await this.anthropic.messages.create({
                model: model,
                max_tokens: 4000,
                messages: [
                    {
                        role: 'user',
                        content: message
                    }
                ]
            });

            return response.content[0].text;
        } catch (error) {
            console.error('Error sending message to Claude:', error);
            throw error;
        }
    }

    /**
     * コード生成に特化したプロンプト
     * @param {string} request - コード生成のリクエスト
     * @param {string} language - プログラミング言語
     * @returns {Promise<string>} - 生成されたコード
     */
    async generateCode(request, language = 'javascript') {
        const prompt = `
あなたは優秀なプログラマーです。以下の要求に基づいて、${language}でコードを生成してください。

要求: ${request}

コードのみを返してください。説明は不要です。
        `;

        return await this.sendMessage(prompt);
    }

    /**
     * コードレビューを実行
     * @param {string} code - レビューするコード
     * @param {string} language - プログラミング言語
     * @returns {Promise<string>} - レビュー結果
     */
    async reviewCode(code, language = 'javascript') {
        const prompt = `
以下の${language}コードをレビューして、改善点や問題点を指摘してください：

\`\`\`${language}
${code}
\`\`\`

改善提案も含めて回答してください。
        `;

        return await this.sendMessage(prompt);
    }
}

export default ClaudeClient;
