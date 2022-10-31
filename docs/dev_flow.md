開発の進行手順

基本的にgithub flowで開発を進める
具体的には下記手順で行う

*notionでチケット番号をもつタスクを発行し、チケット番号でブランチを切る

master = heroku本番環境
 ->github pull requestでのマージ -> git push heroku --remote heroku
heroku-test = herokuテスト環境
 ->git CLIでのマージ -> git push heroku --remote heroku-test
その他 = 開発用ブランチ

ブランチの命名規則


# バグ修正ブランチ
git checkout -b bug/#01_text_overwrapped

# ホットフィックスブランチ（緊急性の高いバグ）
git checkout -b hotfix/#02_login_button_not_work

# 新規機能開発ブランチ
git checkout -b feature/#03_twitter_Oauth

git flowのようなhotfix,featureブランチは作成せず、

*作業ブランチで編集して作業ブランチにコミットする

*heroku-testブランチにマージし、heroku-test環境で確認

*問題なければプルリクエストを発行しmasterにマージする

#　コミット名命名規則
 https://suwaru.tokyo/%E3%80%90%E5%BF%85%E9%A0%88%E3%80%91git%E3%82%B3%E3%83%9F%E3%83%83%E3%83%88%E3%81%AE%E6%9B%B8%E3%81%8D%E6%96%B9%E3%83%BB%E4%BD%9C%E6%B3%95%E3%80%90prefix-emoji%E3%80%91/
^参考
=======
例: fix: change database config

fix	バグ修正
クリティカルなバグ修正なら hotfix

add
feat	新規機能・新規ファイル追加

update	バグではない機能修正

change	
clean  仕様変更による機能修正

refactor
improve	整理 (リファクタリング等)

disable	無効化 (コメントアウト等)
remove
delete	ファイル削除、コードの一部を取り除く

rename	ファイル名の変更

move	ファイル移動

upgrade	バージョンアップ

revert	修正取り消し

docs	ドキュメントのみ修正

style	空白、セミコロン、行、コーディングフォーマットなどの修正

perf	性能向上する修正

test	テスト追加や間違っていたテストの修正

chore	ビルドツールやライブラリで自動生成されたものをコミットするとき