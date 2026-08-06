# CLAUDE.md

## AWSルール

- デフォルトのリージョンはap-northeast-1とする。
- AWS APIの呼び出しはAWS MCP Server経由で行う。awsコマンドは使用しない。
- AWS APIは読み取り系のみ呼び出してよい。変更を加えるAPIは呼び出さない。
- プロファイルは接尾辞`-readonly`があるもののみを使用する。
