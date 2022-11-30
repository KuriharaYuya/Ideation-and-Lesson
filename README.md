# タイムラプス認証アプリ

## 2023 年 3 月までにレベルの高いインターン受かるための勉強習慣の構築のため、勉強がてら開発しました。初めての web アプリ開発です

#### どのような技術のインターン先を目指しているか？ => https://twitter.com/intern_ukaruzo/status/1596151762695917568?s=20&t=kd3RgFShHDYJm9OHZ2kUfw

<br>

### 何ができる？

自分の勉強する姿をライフログで撮影して投稿する SNS。他のユーザーがライフログでしっかり勉強していることを確認したら認証を行うことで、学習習慣の定着が期待できる。
twitter 連携で、一日の勉強記録とタイムラプスを twitter に自動投稿もできます(今は admin ユーザーのみ)

## twitter => https://twitter.com/intern_ukaruzo

## アプリ URL => https://lifelog-verification-app.herokuapp.com/

<br>

# 技術スタック

### フロントエンド: erb, html5, scsss, javascript, jQuery, bootstrap,

### バックエンド: Ruby3.1.2, Rails7.0.3

### API など: twitterAPI(gem)

### インフラなど: heroku,AWS S3(画像とタイムラプスのみ),M1macbookpro

<br>

# 特殊なモデルの説明

- マイクロポスト
  - タイムラプスを添付できるツイートのようなもの。勉強記録時の一つの単位として用いいる ex) お昼から夕方まで英語の長文の勉強
- ライフログ
  - 1 日に 1 ライフログで、ライフログの中にその日のマイクロポストが格納されている
  - 一日の勉強時間の集計や、過去の記録を見る際に使う
  - 一日の GoogleCalendar とスクリーンタイムの画像、および一日の振り返りを添付することができる。この点がただの日付概念と異なる点
- バリファイ
  - タイムラプスの添付されているマイクロポストに対して、twitter のいいねのノリで行うリアクション
  - タイムラプス動画内で確認できる経過時間と、マイクロポストで記録された時間が異なっていなければ、マイクロポストは他のユーザーによってバリファイさ(認められ)る。

# 主要機能一覧

- タイムライン
  - 作成者が投稿を許可したマイクロポストが流れます。
  - 作成者は投稿せず自分だけの勉強記録にすることも可能です。
- ユーザー検索機能(Explore)
  - 全てのユーザーに対して、名前での検索を行えます
  - 名前の検索において、完全一致、含む、前方一致などをオプションで指定して高度な検索が叶
  - 名前以外のユーザー属性を用いてのソートも可能
  - 検索結果が多い場合はページネーションで対応
- フォロー
- 通知機能
- 動画と画像の AWS S3 へのアップロードとアプリ上での表示
- twitter 自動投稿(admin のみ)
  - ライフログとそれに紐づいた複数のマイクロポストから、Twitter 投稿用の動画選定と文言を自動で生成。
  - 文字数が足りない場合は単純に削るのではなく、うまく要約するようなアルゴリズムにした
- ライフログの自動生成と、マイクロポストとの自動紐付け
  - マイクロポストを作成した時、該当日時のライフログが存在しなければ自動的に生成する。
- あとは各モデルでの一般的な CRUD
