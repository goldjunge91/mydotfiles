# TODO

Offene Punkte in `my_dotfiles/`. Reihenfolge nach Dringlichkeit.

## Blocker

- [ ] **Git-Signatur entscheiden.** `config/git/config:127` setzt `gpgsign = true`,
      aber `:4` (`signingkey`) ist auskommentiert und `:124` zeigt auf
      `/Applications/1Password.app/.../op-ssh-sign` — 1Password steht nicht im Caskfile.
      Jeder `git commit` bricht mit einem Signaturfehler ab.
      - Option A: `gpgsign = false`, dazu `:121-125` auskommentieren
      - Option B: `:124` entfernen (Git ruft dann `ssh-keygen -Y sign` selbst auf),
        `user.signingkey = ~/.ssh/id_ed25519_signing.pub` setzen, Key auf GitHub
        unter *SSH and GPG keys → Signing keys* eintragen

- [ ] **`[github] user = webpro`** in `config/git/config:7`. Webpros Benutzername.
      `gh` geht damit davon aus, dass du webpro bist.

- [ ] **Repo-Struktur klären.** `remote-install.sh:5` klont nach `~/.dotfiles`,
      `Makefile:52-53` stowt `runcom` und `config` aus dem Repo-Root. Unsere Dateien
      liegen eine Ebene tiefer. Entweder wird der Inhalt von `my_dotfiles/` zur
      Repo-Wurzel, oder `DOTFILES_DIR` zeigt darauf.

## Hoch

- [ ] **`config/git/config:130`** — `helper = !/opt/homebrew/bin/gh auth git-credential`
      ist fest auf Apple Silicon verdrahtet. Auf einem Intel-Mac existiert der Pfad nicht.

- [ ] **`config/git/config:125`** — `allowedSignersFile` zeigt auf
      `~/.config/git/allowed_signers`. Die Datei existiert nicht.

- [ ] **`config/git/config:84,90,96,102`** — Diff- und Merge-Tools setzen auf `code`,
      aber `cask "visual-studio-code"` ist auskommentiert.

- [ ] **`.github/workflows/` ist leer.** Bei webpro liegen dort `dotfiles-installation.yml`,
      `markdown-link-check.yml`, `markdown-link-check.json`. Ohne sie gibt es keine CI.

- [ ] **`test/` ist leer.** Bei webpro `bin.bats` und `function.bats`.
      `bin/dot:39` ruft `bats "$DOTFILES_DIR"/test/*.bats` auf und bekommt ein leeres
      Glob → garantierter Fehler.

- [ ] **npm-Kette prüfen.** `install/npmfile` ist leer, dadurch fehlen fünf Aufrufe:
      - `bin/json:23` → `underscore`
      - `system/.function_network:5` → `get-port`
      - `system/.function_network:11` → `ws`
      - `system/.alias:55-56` → `npm-check-updates`
      - `system/.alias:71` → `remark`, `remark-preset-webpro`

## Mittel

- [ ] **`config/.curlrc` wird nie gelesen.** Wird nach `~/.config/.curlrc` gestowt.
      Curl liest nur `$CURL_HOME/.curlrc` oder `~/.curlrc`.

- [ ] **`system/.pnpm:2`** — `export PNPM_HOME="$XDG_DATA_HOME/pnpm"`.
      `XDG_DATA_HOME` wird nirgends gesetzt, ergibt effektiv `/pnpm`.

- [ ] **`system/.function_git:8-9`** — echter Bug: `git c user/repo meindir` übergibt
      `meindir` doppelt an `git clone` → „too many arguments".

- [ ] **`system/.function_text:32`** — echter Bug: `line datei 1 2` rechnet `1 - 2 = -1`
      und `sed -n "-1,3p"` scheitert. `$FILE` ist außerdem unquoted.

- [ ] **`system/.grep:4-20`** — baut den Alias über `GREP_OPTIONS`. Apple hat die
      Unterstützung in macOS 12 entfernt, der Alias läuft vermutlich ins Leere.

- [ ] **`system/macos/.alias:53`** — `sysctl -n machdep.cpu.brand_string` existiert
      auf Apple Silicon nicht.

- [ ] **`system/macos/.alias:14-15`** — `canary` und `firefox` zeigen auf Apps,
      die nicht im Caskfile stehen.

- [ ] **`$VISUAL_GIT` wird nirgends gesetzt.** Betrifft `system/macos/.alias:11`,
      `system/macos/.function:9-11` und `bin/dot:34-35`.

- [ ] **`ipl` doppelt definiert.** `system/.alias:61` (gut) und
      `system/macos/.alias:7` (ifconfig, deprecated). Die schlechtere gewinnt.

- [ ] **`bin/json:13-21`** — ist das Argument weder URL noch existierende Datei,
      bleibt `INPUT` leer. Keine Fehlermeldung.

## Aufräumen

- [ ] **`system/.function_network:23`** — `transfer()` lädt Dateien auf einen
      öffentlichen Drittanbieter-Dienst hoch. Wenn nicht genutzt, raus.
      `:24` setzt `tmpfile` ohne `local`.

- [ ] **`system/.alias:69,71`** — `$GITHUB_TOKEN` und `remark-preset-webpro` sind
      webpro-Spezifika. `:68` testet gegen `speed.transip.nl`.

- [ ] **`system/.alias:7,54`** — `mux` (tmuxinator) und `p` (pnpm) zeigen auf
      Programme, die nicht installiert sind.

- [ ] **`macos/defaults.sh:29`** — Endlosschleife für den sudo-Timestamp. Wird
      gesourct, läuft sie nach `dot macos` im Hintergrund weiter.

- [ ] **`macos/defaults.sh:75-76`** — `sudo nvram StartupMute=%01` schaltet den
      Startton auf T1/T2-Macs dauerhaft und praktisch nicht widerruflich stumm.

- [ ] **`macos/defaults.sh:379-381`** — `killall` schließt offene Apps,
      darunter Mail, Safari und Calendar.

- [ ] **`macos/defaults.sh:332-333`** — Terminal-Profil „Pro" existiert auf einem
      frischen System nicht.

- [ ] **`remote-install.sh:17`** — `wget --no-check-certificate` schaltet die
      TLS-Prüfung ab. `:25` nutzt `eval`, `:15` hat kein `curl -f`, `:24` legt
      das Zielverzeichnis vor `git clone` an (nicht idempotent).

- [ ] **`runcom/.bash_profile:8`** — `-x readlink` prüft `./readlink` im aktuellen
      Verzeichnis statt im PATH. `:10` nutzt `$PWD` statt des Skriptverzeichnisses.

- [ ] **Kein Terminal-Emulator im Caskfile.** macOS bringt nur Terminal.app mit.

- [ ] **`dotfiles/` im übergeordneten Repo** enthält noch 118 alte Fish-Dateien,
      darunter `dot.fish`, das mit `bin/dot` kollidiert.

- [ ] **`.gitignore` des übergeordneten Repos** deckt `example/`, `muell/` und
      `.tmp-analysis/` nicht ab.

## Noch nicht lesbar geprüft

- [ ] `system/.env` — durch eine `private_files`-Regel gesperrt
- [ ] `runcom/.inputrc`

## Erledigt

- `config/git/config:2-3` — Name und E-Mail auf eigenen GitHub-Account gesetzt
- `config/git/config:4` — fremder Signaturschlüssel auskommentiert
- `macos/defaults.sh:1-3` — `COMPUTER_NAME`, `LANGUAGES`, `LOCALE` angepasst
- `install/duti` — komplett auskommentiert, passt zum Caskfile
- `install/Codefile` — alle VS-Code-Extensions auskommentiert
- `install/Rustfile`, `npmfile`, `pacmanfile` — geleert
- `Makefile:85` — `rust-packages` und `node-packages` aus der Kette genommen
- `install/Brewfile` — `rust` entfernt
- `install/Caskfile` — bewusst kuratiert
- `macos/dock.sh`, `macos/defaults-chrome.sh` — auskommentiert
- `bin/column` — nicht übernommen (harter `/opt/homebrew`-Symlink)
