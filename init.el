(require 'package)
;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; MELPA-stableを追加
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/") t)
;; Orgを追加
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;; 初期化
(package-initialize)

;; 基本use-packageの自動インストールで入れていく。
;; use-package自身など、use-package以外で自動インストールさせる場合は
;; 以下のリストに追加する
;; https://www.wagavulin.jp/entry/2016/07/04/211631
(defvar pre-install-package-list
  '(use-package)
  "packages to be installed")

(unless package-archive-contents (package-refresh-contents))
(dolist (pkg pre-install-package-list)
  (unless (package-installed-p pkg)
    (package-install pkg)))

;; 変更のあったファイルの自動再読み込み
(global-auto-revert-mode 1)

;; 警告音の代わりに画面フラッシュ
(setq visible-bell t)

;; バックアップファイル*~の保存先指定
(setq backup-directory-alist '((".*" . "~/.emacs.d/backup")))

;; カラーテーマ設定
;; Puttyから使用している場合、反映するには
;; xterm-256colorを設定する必要がある
;; https://www.emacswiki.org/emacs/PuTTY
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-dark+ t)
  )

;; 選択したキーワードをハイライトする
;; https://github.com/wolray/symbol-overlay
(use-package symbol-overlay
  :ensure t
  :bind
  ("M-i" . symbol-overlay-put)
  ("C-g" . symbol-overlay-remove-all)
  ;; ハイライト上で r で置換できる
  ;; w でkill-ringにコピー
  )

;; ディレクトリツリーをサイドバーに表示する
(use-package neotree
  :ensure t
  :bind ("C-t" . neotree-toggle)
  :custom
  (neo-persist-show t)
  (neo-smart-open t)
  )

;; コマンド補完パッケージ
(use-package ivy
  :ensure t
  :config (ivy-mode 1)
  :custom
  (ivy-use-virtual-buffers t)
  (enable-recursive-minibuffers t)
  (ivy-height 20) ;; minibufferの行数
  (ivy-extra-directories nil)
  (ivy-re-builders-alist '((t . ivy--regex-plus)))
  )

;; 絞り込み検索 ivy依存
(use-package counsel
  :ensure t
  :bind
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  :custom (counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))
  )

;; 最近使ったファイル検索 counsel依存
(use-package recentf
  :ensure t
  :bind ("C-x C-r" . counsel-recentf)
  :custom
  (recentf-save-file "~/.emacs.d/.recentf")
  (recentf-max-saved-items 200)             ;; recentf に保存するファイルの数
  (recentf-exclude '(".recentf"))           ;; .recentf自体は含まない
  (recentf-auto-cleanup 'never)             ;; 保存する内容を整理
  (run-with-idle-timer 30 t '(lambda () (with-suppressed-message (recentf-save-list))))
  )

;; 検索機能拡張 ivy依存
(use-package swiper
  :ensure t
  :bind ("C-s" . swiper)
  :custom (swiper-include-line-number-in-search t)
  )

;; git用
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  )

;; コード補完
(use-package company
  :ensure t
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 2) 
  (company-selection-wrap-around t) ; 候補選択カーソルの循環
  :config (global-company-mode)
  :custom-face
  ;;(company-tooltip ((t (:foreground "pink" :background "dimgrey"))))
  (company-tooltip-common ((t (:foreground "#5FD7FF" :background "dimgrey"))))
  ;;(company-tooltip-common-selection ((t (:foreground "white" :background "steelblue"))))
  ;;(company-tooltip-selection ((t (:foreground "white" :background "steelblue"))))
  ;;(company-preview-common ((t (:background nil :foreground "white" :underline t))))
  (company-tooltip-annotation ((t (:foreground "skyblue"))))
  ;;(company-scrollbar-fg ((t (:background "grey60"))))
  ;;(company-scrollbar-bg ((t (:background "gray40"))))
  )

;; デバッカ
;; https://github.com/realgud/realgud
(use-package realgud
  :ensure t
  )

;; python開発環境 pyvenv pipenv elpy
;; 参考
;; http://ayageman.blogspot.com/2019/04/emacspython.html
;; https://mako-note.com/python-emacs-ide/
(use-package pyvenv :ensure t)
(use-package pipenv :ensure t
    :diminish (pipenv-mode . "penv")
    :hook (python-mode . pipenv-mode)
    :custom (pipenv-with-projectile nil)  ;; Disable Projectile integration
    :config (pipenv-activate)
    ;; :bind
    ;; C-c C-p a   pipenv-activate
    ;; C-c C-p d   pipenv-deactivate
    ;; C-c C-p s   pipenv-shell
    )

(use-package elpy
  :ensure t
  :diminish (elpy-mode . "elpy")
  :hook
  (python-mode . elpy-enable)
  (elpy-enable . elpy-mode)
  (elpy-mode . (lambda ()
		 (add-hook 'before-save-hook 'elpy-format-code nil 'make-it-local)
		 ))
  :custom
  (elpy-rpc-python-command "python3")
  :bind (:map elpy-mode-map
	      ("C-d" . realgud:pdb)
	      )
  :config
  (use-package flycheck
    :ensure t
    :hook (elpy-mode . flycheck-mode)
    :bind (:map flycheck-mode-map
		("C-e" . flycheck-list-errors)
		("C-n" . flycheck-next-error)
		("C-p" . flycheck-previous-error)
		)
    :custom (elpy-modules (delq 'elpy-module-flymake elpy-modules))
    :custom-face
    (flycheck-warning ((t (:background "#F2E700")))) ;;警告の強調表示
    (flycheck-error ((t (:background "#FF4B00")))) ;;警告の強調表示
    ;; 参考 https://qiita.com/AnchorBlues/items/91026c4f1c0745f5b851
    )
  (use-package py-isort
    :ensure t
    :hook
    (elpy-mode . (lambda ()
		   (add-hook 'before-save-hook 'py-isort-before-save nil 'make-it-local)
		   ))
    )
  )

;; tex環境
(use-package yatex
  :ensure t
  :mode (("\\.tex\\'" . yatex-mode))
  :custom
  (tex-command "platex2pdf")
  (dvi2-command "evince")
  (bibtex-command "upbibtex")
  :init
  (defun replace-dot-comma ()
    (let ((curpos (point)))
      (goto-char (point-min))
      (while (search-forward "。" nil t) (replace-match "．"))
      (goto-char (point-min))
      (while (search-forward "、" nil t) (replace-match "，"))
      (goto-char curpos)
      ))
  :hook
  (yatex-mode . (lambda ()
		  (add-hook 'before-save-hook 'replace-dot-comma nil 'make-it-local)
		  ))
  )

;; Markdown環境
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  )

;; パッケージ依存の整合性確保のために勝手に追加される記述を外部に
;; http://extra-vision.blogspot.com/2016/10/emacs25-package-selected-packages.html
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
