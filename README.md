# .emacs.d
快適なEmacs開発環境を整えるための設定ファイルです。

linux環境にPuttyやTeraTermなどのsshクライアントでリモートアクセスした際に、
CUIでもIDEのような開発環境を使用できることを目的としています。

また、実験や論文執筆など研究に必要な環境を全てEmacsから行えるように整備しています。

## 動作環境

各nlkenサーバで動かすことを主な用途として想定しています。

よって次のような環境で動作確認しています。

* Ubuntu OS
* CUI

## サポート

この設定ファイルは以下の環境をサポートします。

* Python開発環境
  * pipenvによる仮想環境とパッケージバージョン管理
  * company,jediによる補完
  * yapfによるPEP8準拠の自動フォーマッティング（セーブ時）
  * flycheckによる構文チェック
  * realgud:pdbによるIDEと遜色ないデバック機能
* Tex環境
* git,GitHubバージョン管理
* Markdown

なお、Emacsはデフォルト状態でも多くの種類のファイルに対応したテキストエディタです。

# Installation

`~/.emacs.d/init.el`
に設定ファイルを置くだけで設定完了です。

次回Emacs起動時に、Emacs側で必要なパッケージは全て自動インストールされます。


各環境で全機能を使用するには、Emacs外部で別途インストールが必要なものがあります。

各nlkenサーバではインストールされています[^1]が、各自のPC環境で使用する場合はインストールしてください。

[^1]: Tex環境を除く

## Python環境
Ubuntuでは、システムのPython3にpipenvをインストールしておきます。

pipenvで高度なPythonのパッケージのバージョン管理と、emacsから仮想環境へのアクセス、実行ができます。

`
sudo apt install pipenv
`

構文チェックのflycheckを動作させるために、仮想環境でflack8をインストールしておきます。

`M-x elpy-config`からflack8のインストールをするのが簡単です。

pipenv環境が入っていれば、`C-c C-s`でpipenvのシェルを起動し、

`
pipenv install --dev flack8
`

でインストールすると良いです。

オプション`--dev`は、開発環境でのみ必要なパッケージを区別してインストールするためのpipenvに用意されたオプションになります。

## Tex環境
Tex liveのインストールなどでTexの実行環境を整えてください。


# Putty設定
Puttyは、ダイナミックポートフォワーディングに対応しているため、学内限定サイトにアクセスしたい時などに大変便利です。（TeraTermは非対応）

sshクライアントとしてPuttyを使用している場合、次の設定をしていると快適になります。

## Color
通常設定だと、使用される色が限定されるので、拡張します。

Connection - Data より、Terminal detailsのTerminal-type stringをxterm-256colorに設定します。

## Bold
通常設定だと、太字が表示されません。

Window - Colours より、Indecate bolded by changingをThe fontに設定します。
