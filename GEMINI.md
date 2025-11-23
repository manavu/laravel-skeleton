# GEMINI.md

## アーキテクチャガイドライン

本プロジェクトでは、Laravel の標準的な MVC アーキテクチャを基本としつつ、ビジネスロジックの複雑さに応じて以下のパターンを適用することを推奨します。

### 基本方針
- **Fat Controller の回避**: コントローラーはリクエストの受付とレスポンスの返却に専念し、ビジネスロジックは Service クラスや Action クラスに委譲する。
- **FormRequest の徹底**: リクエストのバリデーションには、必ず FormRequest を使用する（コントローラー内の `$request->validate()` は原則禁止）。
- **Eloquent Model の責務**: データベース操作やリレーション定義、アクセサ/ミューテータ。**クエリスコープ（Scope）や、自身のデータ・リレーション、引数で渡された他のモデルを用いて完結するロジックはモデルに実装する。**
- **Repository (任意)**: 外部データソースへのアクセスや、Eloquent だけでは表現しきれない複雑なクエリを隠蔽する場合に使用。**通常のクエリは Eloquent Scope で十分な場合が多い。**

### 推奨レイヤー構成
1.  **Controller**: ルーティングとバリデーション、Service または Action の呼び出し。
2.  **Use Case (Action)**: アプリケーションのユースケース（例: `RegisterUser`, `PlaceOrder`）を1クラス1メソッドで実装する。トランザクション管理やドメインオブジェクトの協調を行う。
3.  **Domain Service (任意)**: 特定のモデルに収まらないドメイン知識や、**複数のユースケースで共通して利用されるロジック**（例: 共通のファイル取込処理、複雑な計算）を実装する。Use Case から呼び出される。
4.  **Repository (任意)**: 複雑なクエリや外部データソースへのアクセスを抽象化する場合に使用。単純な Eloquent 操作であれば不要。

### ルーティング
- **DHH流 (Resourceful Routing)**: コントローラーには標準の7つのアクション（index, create, store, show, edit, update, destroy）のみを実装することを原則とする。
- **カスタムアクションの禁止**: `activate` や `publish` などのカスタムメソッドをコントローラーに追加しない。代わりに `UserActivationController` や `PublishedPostController` のように、新しいリソースとしてコントローラーを作成し、その `store` や `update` メソッドを使用する。

## コーディングルール

### スタイルガイド
- **PSR-12**: PHP 標準勧告に準拠する。
- **Laravel Pint**: コードフォーマッターとして Laravel Pint を使用する。コミット前に必ず実行すること。
    ```bash
    ./bin/pint
    ```

### 命名規則
- **クラス名**: PascalCase (例: `UserController`)
- **メソッド名**: camelCase (例: `storeUser`)
- **変数名**: camelCase (例: `userData`)
- **テーブル名**: 複数形スネークケース (例: `users`)

### 型安全性
- **PHPStan**: 静的解析ツールとして PHPStan を使用する。レベル 5 以上を推奨。
    ```bash
    ./bin/phpstan
    ```
- **型宣言**: 引数と戻り値には可能な限り型宣言を行う。

## テストルール

### テストフレームワーク
- **Pest** または **PHPUnit** を使用する（Laravel 11 以降は Pest がデフォルト推奨）。

### テスト方針
- **Feature Test**: コントローラーのエンドポイントに対するテストを優先して書く。正常系だけでなく、バリデーションエラーなどの異常系も網羅する。
- **Unit Test**: 複雑な計算ロジックや単体のクラスメソッドに対して書く。

### カバレッジ
- 重要なビジネスロジックについては高いカバレッジを目指す。

## 開発フロー
1.  **インフラの起動（初回・PC再起動時）**
    ```bash
    docker compose -f docker-compose.infra.yml up -d
    ```
2.  **アプリケーションの起動**
    ```bash
    docker compose up -d
    ```
3.  `bin/artisan` コマンドで各種操作。
4.  実装完了後、`bin/pint` と `bin/phpstan` を実行して品質チェック。
5.  テストを実行して動作確認。
