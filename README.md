# Laravel Skeleton

## セットアップ

### 1. インフラの起動
データベースとRedisを起動します。これは常時起動しておくことを想定しています。

```bash
docker compose -f docker-compose.infra.yml up -d
```

### 2. Huskyのセットアップ
Huskyによるgit hooksを有効にします。

```bash
./bin/npm run prepare
```

### 3. アプリケーションの起動
プロファイルを指定して、必要なサービスのみを起動できます。

**Webのみ起動（基本）**
```bash
docker compose --profile web up -d
```

**Queueワーカーも起動**
```bash
docker compose --profile queue up -d
```

**スケジューラーも起動**
```bash
docker compose --profile scheduler up -d
```

**全て起動**
```bash
docker compose --profile web --profile queue --profile scheduler up -d
# または単に
docker compose up -d
```

### 4. アプリケーションの停止
プロファイルを指定して、特定のサービスのみを停止できます（DBは停止しません）。

```bash
# Queueのみ停止
docker compose --profile queue down

# アプリケーション全体を停止
docker compose down
```

## 開発ツール

WSLから以下のコマンドが利用可能です。

- `./bin/artisan`: Artisanコマンド
- `./bin/composer`: Composerコマンド
- `./bin/pint`: コードフォーマッター
- `./bin/phpstan`: 静的解析
- `./bin/npm`: npmコマンド
- `./bin/npx`: npxコマンド

詳細なルールは [GEMINI.md](GEMINI.md) を参照してください。
