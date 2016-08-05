;;; packages.el --- gtdone layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Yuri de Wit <lemao@terra.local>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `gtdone-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `gtdone/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `gtdone/pre-init-PACKAGE' and/or
;;   `gtdone/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst gtdone-packages
  '(
    org
    org-agenda
    ))

(defun gtdone/post-init-org ()
  (evil-leader/set-key
    "oc" 'org-capture
    "oa" 'org-agenda
    "ol" 'org-store-link
    "ob" 'org-iswitchb
    )

;;  (spacemacs|use-package-add-hook org
;;    :post-config
;;    (progn
      (setq org-directory "~/org/")
      (setq org-enable-github-support t)

      (use-package org-id)
      (use-package org-habit)

      ;; CAPTURE
      (setq org-default-notes-file (concat org-directory "refile.org"))

      ;; CLOCK
      (defvar bh/organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")

      ;; -----------------------------------------------------------------
      ;; GLOBAL
      (setq org-time-stamp-rounding-minutes (quote (1 1)))

      ;; Set default column view headings: Task Effort Clock_Summary
      (setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

      ;; global Effort estimate values
      ;; global STYLE property values for completion
      (setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                          ("STYLE_ALL" . "habit"))))

      (setq org-alphabetical-lists t)

      (setq org-reverse-note-order t)

      (setq org-pretty-entities t)
      (setq org-indent-mode t)
      (setq org-src-fontify-natively t)
      (setq org-ellipsis "⤵")
      (setq org-hide-emphasis-markers t)

      (setq org-fontify-done-headline t)
      (setq org-support-shift-select t)

      (add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)


      ;; -----------------------------------------------------------------
      ;; CAPTURE
      (setq org-capture-templates
            (quote (("t" "todo" entry (file (concat org-directory "refile.org"))
                     "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
                    ("r" "respond" entry (file (concat org-directory "refile.org"))
                     "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
                    ("n" "note" entry (file (concat org-directory "refile.org"))
                     "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
                    ("j" "Journal" entry (file+datetree (concat org-directory "journal.org"))
                     "* %?\n%U\n" :clock-in t :clock-resume t)
                    ("w" "org-protocol" entry (file (concat org-directory "refile.org"))
                     "* TODO Review %c\n%U\n" :immediate-finish t)
                    ("m" "Meeting" entry (file (concat org-directory "refile.org"))
                     "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
                    ("p" "Phone call" entry (file (concat org-directory "refile.org"))
                     "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
                    ("h" "Habit" entry (file (concat org-directory "refile.org"))
                     "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))


      ;; -----------------------------------------------------------------
      ;; AGENDA

      ;; To keep agenda fast
      (setq org-agenda-span 'day)

      (setq org-agenda-files (-uniq
                              (-union
                               (list (expand-file-name org-default-notes-file))
                               (directory-files org-directory t "\.org$")
                               )))

      (setq org-agenda-include-diary nil)
      (setq org-agenda-diary-file (concat org-directory "journal.org"))

      ;; Align tags
      (add-hook 'org-finalize-agenda-hook 'bh/place-agenda-tags)
      ;;(setq org-agenda-tags-column 102)
      (defun bh/place-agenda-tags ()
        "Put the agenda tags by the right border of the agenda window."
        (setq org-agenda-tags-column (- 4 (window-width)))
        (org-agenda-align-tags))
      ;; The following custom-set-faces create the highlights
      (custom-set-faces
       ;; custom-set-faces was added by Custom.
       ;; If you edit it by hand, you could mess it up, so be careful.
       ;; Your init file should contain only one such instance.
       ;; If there is more than one, they won't work right.
       '(org-mode-line-clock ((t (:background "grey75" :foreground "red" :box (:line-width -1 :style released-button)))) t))

      ;; Keep tasks with dates on the global todo lists
      (setq org-agenda-todo-ignore-with-date nil)

      ;; Keep tasks with deadlines on the global todo lists
      (setq org-agenda-todo-ignore-deadlines nil)

      ;; Keep tasks with scheduled dates on the global todo lists
      (setq org-agenda-todo-ignore-scheduled nil)

      ;; Keep tasks with timestamps on the global todo lists
      (setq org-agenda-todo-ignore-timestamp nil)

      ;; Remove completed deadline tasks from the agenda view
      (setq org-agenda-skip-deadline-if-done t)

      ;; Remove completed scheduled tasks from the agenda view
      (setq org-agenda-skip-scheduled-if-done t)

      ;; Remove completed items from search results
      (setq org-agenda-skip-timestamp-if-done t)

      ;; Agenda clock report parameters
      (setq org-agenda-clockreport-parameter-plist
            (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))

      (setq org-agenda-clock-consistency-checks
            (quote (:max-duration "4:00"
                                  :min-duration 0
                                  :max-gap 0
                                  :gap-ok-around ("4:00"))))

      ;; Agenda log mode items to display (closed and state changes by default)
      (setq org-agenda-log-mode-items (quote (closed state)))

      ;; Automatically removing context based tasks with / RET
      (setq org-agenda-auto-exclude-function 'bh/org-auto-exclude-function)

      ;; Do not dim blocked tasks
      (setq org-agenda-dim-blocked-tasks nil)

      ;; Compact the block agenda view
      (setq org-agenda-compact-blocks nil)

      (setq org-agenda-text-search-extra-files '(agenda-archives))

      ;; Custom agenda command definitions
      (setq org-agenda-custom-commands
            (quote (("N" "Notes" tags "NOTE"
                     ((org-agenda-overriding-header "Notes")
                      (org-tags-match-list-sublevels t)))
                    ("h" "Habits" tags-todo "STYLE=\"habit\""
                     ((org-agenda-overriding-header "Habits")
                      (org-agenda-sorting-strategy
                       '(todo-state-down effort-up category-keep))))
                    (" " "Agenda"
                     ((agenda "" nil)
                      (tags "REFILE"
                            ((org-agenda-overriding-header "Tasks to Refile")
                             (org-tags-match-list-sublevels nil)))
                      (tags-todo "-CANCELLED/!"
                                 ((org-agenda-overriding-header "Stuck Projects")
                                  (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-HOLD-CANCELLED/!"
                                 ((org-agenda-overriding-header "Projects")
                                  (org-agenda-skip-function 'bh/skip-non-projects)
                                  (org-tags-match-list-sublevels 'indented)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-CANCELLED/!NEXT"
                                 ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                                  (org-tags-match-list-sublevels t)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                 (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-sorting-strategy
                                   '(todo-state-down effort-up category-keep))))
                      (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                                 ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-non-project-tasks)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                                 ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-project-tasks)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-CANCELLED+WAITING|HOLD/!"
                                 ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-non-tasks)
                                  (org-tags-match-list-sublevels nil)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
                      (tags "-REFILE/"
                            ((org-agenda-overriding-header "Tasks to Archive")
                             (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                             (org-tags-match-list-sublevels nil))))
                     nil))))

      ;; -----------------------------------------------------------------
      ;; TAGS
      ;; Tags with fast selection keys
      (setq org-tag-alist (quote ((:startgroup)
                                  ("@errand" . ?e)
                                  ("@office" . ?o)
                                  ("@home" . ?H)
                                  ("@farm" . ?f)
                                  (:endgroup)
                                  ("WAITING" . ?w)
                                  ("HOLD" . ?h)
                                  ("PERSONAL" . ?P)
                                  ("WORK" . ?W)
                                  ("FARM" . ?F)
                                  ("ORG" . ?O)
                                  ("NORANG" . ?N)
                                  ("crypt" . ?E)
                                  ("NOTE" . ?n)
                                  ("CANCELLED" . ?c)
                                  ("FLAGGED" . ??))))

                                        ;; Allow setting single tags without the menu
      (setq org-fast-tag-selection-single-key (quote expert))

                                        ;; For tag searches ignore tasks with scheduled and deadline dates
      (setq org-agenda-tags-todo-honor-ignore-options t)

      ;; -----------------------------------------------------------------
      ;; TODOS
      (setq org-use-fast-todo-selection t)
      (setq org-treat-S-cursor-todo-selection-as-state-change nil)

      (setq org-todo-keywords
            (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                    (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

      (setq org-todo-keyword-faces
            (quote (("TODO" :foreground "red" :weight bold)
                    ("NEXT" :foreground "blue" :weight bold)
                    ("DONE" :foreground "forest green" :weight bold)
                    ("WAITING" :foreground "orange" :weight bold)
                    ("HOLD" :foreground "magenta" :weight bold)
                    ("CANCELLED" :foreground "forest green" :weight bold)
                    ("MEETING" :foreground "forest green" :weight bold)
                    ("PHONE" :foreground "forest green" :weight bold))))
      (setq org-todo-state-tags-triggers
            (quote (("CANCELLED" ("CANCELLED" . t))
                    ("WAITING" ("WAITING" . t))
                    ("HOLD" ("WAITING") ("HOLD" . t))
                    (done ("WAITING") ("HOLD"))
                    ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                    ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                    ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))


      ;; -----------------------------------------------------------------
      ;; PROJECTS
      (setq org-stuck-projects (quote ("" nil nil "")))


      ;; -----------------------------------------------------------------
      ;; ARCHIVING
      (setq org-archive-mark-done nil)
      (setq org-archive-location "%s_archive::* Archived Tasks")

      ;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
      (setq org-refile-targets (quote ((nil :maxlevel . 4)
                                 (org-agenda-files :maxlevel . 4))))

      ;; Use full outline paths for refile targets - we file directly with IDO
      (setq org-refile-use-outline-path t)

      ;; Targets complete directly with IDO
      (setq org-outline-path-complete-in-steps nil)

      ;; Allow refile to create parent tasks with confirmation
      (setq org-refile-allow-creating-parent-nodes (quote confirm))

      ;; Use IDO for both buffer and file completion and ido-everywhere to t
      (setq org-completion-use-ido t)
      (setq ido-everywhere t)
      (setq ido-max-directory-size 100000)
      (ido-mode (quote both))
      ;; Use the current window when visiting files and buffers with ido
      (setq ido-default-file-method 'selected-window)
      (setq ido-default-buffer-method 'selected-window)
                                        ;; Use the current window for indirect buffer display
      (setq org-indirect-buffer-display 'current-window)


      ;; -----------------------------------------------------------------
      ;; REFILE settings
      (setq org-refile-target-verify-function 'bh/verify-refile-target)


      ;; -----------------------------------------------------------------
      ;; CLOCK

      ;; Resume clocking task when emacs is restarted
      (org-clock-persistence-insinuate)
      ;;
      ;; Show lot of clocking history so it's easy to pick items off the C-F11 list
      (setq org-clock-history-length 23)
      ;; Resume clocking task on clock-in if the clock is open
      (setq org-clock-in-resume t)
      ;; Change tasks to NEXT when clocking in
      (setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
      ;; Separate drawers for clocking and logs
      (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
      ;; Save clock data and state changes and notes in the LOGBOOK drawer
      (setq org-clock-into-drawer t)
      ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
      (setq org-clock-out-remove-zero-time-clocks t)
      ;; Clock out when moving task to a done state
      (setq org-clock-out-when-done t)
      ;; Save the running clock and all clock history when exiting Emacs, load it on startup
      (setq org-clock-persist t)
      ;; Do not prompt to resume an active clock
      (setq org-clock-persist-query-resume nil)
      ;; Enable auto clock resolution for finding open clocks
      (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
      ;; Include current clocking task in clock reports
      (setq org-clock-report-include-clocking-task t)

      (setq bh/keep-clock-running nil)

      ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
      (setq org-clock-out-remove-zero-time-clocks t)


      ;; -----------------------------------------------------------------
      ;; BABEL
      (setq org-confirm-babel-evaluate nil)

      ;; Don't enable this because it breaks access to emacs from my Android phone
      (setq org-startup-with-inline-images nil)

      (setq org-ditaa-jar-path "~/org/contrib/scripts/ditaa.jar")
      (setq org-plantuml-jar-path "~/org//plantuml.jar")

      ;; Make babel results blocks lowercase
      (setq org-babel-results-keyword "results")

      (add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)

      ;; Use fundamental mode when editing plantuml blocks with C-c '
      (add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))

      (org-babel-do-load-languages
       'org-babel-load-languages
       '((R . t)
         (ruby . t)
         (shell . t)
         (C . t)
         (ditaa . t)
         (dot . t)
         (ebnf . t)
         (haskell . t)
         (java . t)
         (ledger . t)
         (latex . t)
         (makefile . t)
         (org . t)
         (plantuml . t)
         (scala . t)
         (sh . t)
         (sql . t)
         (gnuplot . t)
         ;;(restclient . t)
         )
       )

      ;; -----------------------------------------------------------------
      ;; SKELETONS

      ;; Enable abbrev-mode
      (add-hook 'org-mode-hook (lambda () (abbrev-mode 1)))

      ;; Skeletons
      ;;
      ;; sblk - Generic block #+begin_FOO .. #+end_FOO
      (define-skeleton skel-org-block
        "Insert an org block, querying for type."
        "Type: "
        "#+begin_" str "\n"
        _ - \n
        "#+end_" str "\n")

      (define-abbrev org-mode-abbrev-table "sblk" "" 'skel-org-block)

      ;; splantuml - PlantUML Source block
      (define-skeleton skel-org-block-plantuml
        "Insert a org plantuml block, querying for filename."
        "File (no extension): "
        "#+begin_src plantuml :file " str ".png :cache yes\n"
        _ - \n
        "#+end_src\n")

      (define-abbrev org-mode-abbrev-table "splantuml" "" 'skel-org-block-plantuml)

      (define-skeleton skel-org-block-plantuml-activity
        "Insert a org plantuml block, querying for filename."
        "File (no extension): "
        "#+begin_src plantuml :file " str "-act.png :cache yes :tangle " str "-act.txt\n"
        (bh/plantuml-reset-counters)
        "@startuml\n"
        "skinparam activity {\n"
        "BackgroundColor<<New>> Cyan\n"
        "}\n\n"
        "title " str " - \n"
        "note left: " str "\n"
        "(*) --> \"" str "\"\n"
        "--> (*)\n"
        _ - \n
        "@enduml\n"
        "#+end_src\n")

      (defvar bh/plantuml-if-count 0)

      (defun bh/plantuml-if ()
        (incf bh/plantuml-if-count)
        (number-to-string bh/plantuml-if-count))

      (defvar bh/plantuml-loop-count 0)

      (defun bh/plantuml-loop () 
        (incf bh/plantuml-loop-count)
        (number-to-string bh/plantuml-loop-count))

      (defun bh/plantuml-reset-counters ()
        (setq bh/plantuml-if-count 0
              bh/plantuml-loop-count 0)
        "")

      (define-abbrev org-mode-abbrev-table "sact" "" 'skel-org-block-plantuml-activity)

      (define-skeleton skel-org-block-plantuml-activity-if
        "Insert a org plantuml block activity if statement"
        "" 
        "if \"\" then\n"
        "  -> [condition] ==IF" (setq ifn (bh/plantuml-if)) "==\n"
        "  --> ==IF" ifn "M1==\n"
        "  -left-> ==IF" ifn "M2==\n"
        "else\n"
        "end if\n"
        "--> ==IF" ifn "M2==")

      (define-abbrev org-mode-abbrev-table "sif" "" 'skel-org-block-plantuml-activity-if)

      (define-skeleton skel-org-block-plantuml-activity-for
        "Insert a org plantuml block activity for statement"
        "Loop for each: " 
        "--> ==LOOP" (setq loopn (bh/plantuml-loop)) "==\n"
        "note left: Loop" loopn ": For each " str "\n"
        "--> ==ENDLOOP" loopn "==\n"
        "note left: Loop" loopn ": End for each " str "\n" )

      (define-abbrev org-mode-abbrev-table "sfor" "" 'skel-org-block-plantuml-activity-for)

      (define-skeleton skel-org-block-plantuml-sequence
        "Insert a org plantuml activity diagram block, querying for filename."
        "File appends (no extension): "
        "#+begin_src plantuml :file " str "-seq.png :cache yes :tangle " str "-seq.txt\n"
        "@startuml\n"
        "title " str " - \n"
        "actor CSR as \"Customer Service Representative\"\n"
        "participant CSMO as \"CSM Online\"\n"
        "participant CSMU as \"CSM Unix\"\n"
        "participant NRIS\n"
        "actor Customer"
        _ - \n
        "@enduml\n"
        "#+end_src\n")

      (define-abbrev org-mode-abbrev-table "sseq" "" 'skel-org-block-plantuml-sequence)

      ;; sdot - Graphviz DOT block
      (define-skeleton skel-org-block-dot
        "Insert a org graphviz dot block, querying for filename."
        "File (no extension): "
        "#+begin_src dot :file " str ".png :cache yes :cmdline -Kdot -Tpng\n"
        "graph G {\n"
        _ - \n
        "}\n"
        "#+end_src\n")

      (define-abbrev org-mode-abbrev-table "sdot" "" 'skel-org-block-dot)

      ;; sditaa - Ditaa source block
      (define-skeleton skel-org-block-ditaa
        "Insert a org ditaa block, querying for filename."
        "File (no extension): "
        "#+begin_src ditaa :file " str ".png :cache yes\n"
        _ - \n
        "#+end_src\n")

      (define-abbrev org-mode-abbrev-table "sditaa" "" 'skel-org-block-ditaa)

      ;; selisp - Emacs Lisp source block
      (define-skeleton skel-org-block-elisp
        "Insert a org emacs-lisp block"
        ""
        "#+begin_src emacs-lisp\n"
        _ - \n
        "#+end_src\n")

      (define-abbrev org-mode-abbrev-table "selisp" "" 'skel-org-block-elisp)


      ;; -----------------------------------------------------------------
      ;; REMINDERS

      ;; Rebuild the reminders everytime the agenda is displayed
      (add-hook 'org-finalize-agenda-hook 'bh/org-agenda-to-appt 'append)

      ;; This is at the end of my .emacs - so appointments are set up when Emacs starts
      (bh/org-agenda-to-appt)

      ;; Activate appointments so we get notifications
      (appt-activate t)

      ;; If we leave Emacs running overnight - reset the appointments one minute after midnight
      (run-at-time "24:01" nil 'bh/org-agenda-to-appt)


;;      )
;;    )
  )

;;; packages.el ends here
