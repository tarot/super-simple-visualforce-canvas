super-simple-visualforce-canvas
====
VisualforceにCanvasを埋め込んで、Event経由でやりとりするサンプル。ボタンをクリックしたら`console.log`するだけ。

Salesforceの設定
----
### 接続アプリケーション

設定 → ビルド → 作成 → アプリケーション を開き、接続アプリケーションを新規作成。後から設定変更できるので心配しなくてよい

#### 基本情報

* 接続アプリケーション名: 任意、サンプルのVisualforceでは`myfirstcanvas`
* API 参照名: 任意、サンプルのVisualforceでは`myfirstcanvas`
* 取引先責任者 メール: 任意のメールアドレス

#### API (OAuth 設定の有効化)

* OAuth 設定の有効化: チェック
* コールバック URL: 任意のURL。利用しない。`sfdc://success`とか
* 選択した OAuth 範囲: 利用しないが必須なのでとりあえず データへのアクセスと管理 (api)

#### キャンバスアプリケーション設定

* Force.com Canvas: チェック
* キャンバスアプリケーションの URL: CanvasアプリケーションのURL。HerokuのURLかngrokのURL
* アクセス方法: 署名付き要求 (POST)
* 場所: Visualforce ページ

保存したら Manage ボタンから接続アプリケーションの詳細へ

#### 接続アプリケーションの詳細

* 編集ページから、許可されているユーザを 管理者が承認したユーザは事前承認済み に設定
* 保存した後、プロファイル関連リストか権限セット関連リストで、自分のプロファイルか権限セットを追加する
  * ここで追加した権限のユーザが「管理者が承認したユーザ」ということになる

### Visualforce ページ

[salesforce](salesforce)ディレクトリをデプロイするか、[salesforce/pages/myfirstcanvas.page](salesforce/pages/myfirstcanvas.page)をコピペして作成する

ローカル実行
----
### ngrok

httpsが必要なのでngrokを使う。

`ngrok -authtoken $AUTHTOKEN -subdomain=example 3000`として起動すると、`https://example.ngrok.com`で`http://localhost:3000`を見られるようになる。

`subdomain`オプションはauth tokenが必要なのでサインアップして取得する。GitHubアカウントでもサインアップできる。

* [https://ngrok.com/](https://ngrok.com/)からサインアップしてログイン。
* [Dashboard → Admin](https://dashboard.ngrok.com/admin)でRestore ngrok 1.0ボタンをクリックする。
  * `brew install ngrok`でインストールできるngrokがまだ1.7なので
* [Dashboard](https://dashboard.ngrok.com/)でauth tokenを確認できる

### bundle

```
$ bundle install
```

### .env

```
NGROK_AUTHTOKEN=ngrokのauth token
NGROK_SUBDOMAIN=任意のサブドメイン。flsdhjfksdkljとか
NGROK_PORT=3000とか
CANVAS_CLIENT_SECRET=接続アプリケーションのコンシューマの秘密
CANVAS_ORIGIN=https://c.<your instance>.visual.force.com
```

`CANVAS_ORIGIN`で`X-Frame-Options: ALLOW-FROM`を付けるようにしているが、ChromeやSafariが対応していないので省略してもよい。

### 起動

```
$ bundle exec foreman start -f Procfile.dev
```

Sinatraアプリとngrokが起動する。`brew install ngrok`でngrok 1.xをインストールしておくこと。

Heroku
----
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Reference
----
* [Force.com Canvas Developer's Guide](https://developer.salesforce.com/docs/atlas.en-us.platform_connect.meta/platform_connect/)
* [SalesforceCanvasJavascriptSDK](https://github.com/forcedotcom/SalesforceCanvasJavascriptSDK)
