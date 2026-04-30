;;; quake.el -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 Alex
;;
;; Author: Alex <alex@Scorpion>
;; Maintainer: Alex <alex@Scorpion>
;; Created: April 30, 2026
;; Modified: April 30, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/alex/quake-emacs-tools
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; configure quake-maker.el variables.
;;
;;; Code:

; For export and run:

(defvar quake-gamedirpath "~/Programs/project_enoch/FTEQW/"
  "Path to Quake game engine.")
(defvar quake-moddirpath "enoch/"
  "Relative path to Quake mod.")
(defvar quake-launch-args "+map blockout_demo.bsp"
  "Command line launch arguments for Quake engine.")
(defvar quake-engine "fteqw64"
  "Name of Quake engine executable.")

(defvar quake-progslist '(
                    "~/GitHub/Project-E/qwprogs.dat"
                    "~/GitHub/Project-E/menu.dat"
                    "~/GitHub/Project-E/csprogs.dat")
  "List of progs (.dat) files for Quake mod.")

(provide 'quake)
;;; quake.el ends here
