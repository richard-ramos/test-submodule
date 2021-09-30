mode = ScriptMode.Verbose

version       = "0.1.0"
author        = "Richard"
description   = "..."
license       = "MIT"

requires "nim >= 1.2.0"

import strutils

const release_opts =
  " --define:danger" &
  " --define:strip" &
  " --hints:off" &
  " --opt:size" &
  " --passC:-flto" &
  " --passL:-flto"

const debug_opts =
  " --debugger:native" &
  " --define:chronicles_line_numbers" &
  " --define:debug" &
  " --linetrace:on" &
  " --stacktrace:on"

proc buildAndRun(name: string,
                 srcDir = "./",
                 outDir = "./build/",
                 params = "",
                 cmdParams = "",
                 lang = "c") =
  mkDir outDir
  exec "nim " &
    lang &
    (if getEnv("RELEASE").strip != "false": release_opts else: debug_opts) &
    " --nimcache:nimcache/" & (if getEnv("RELEASE").strip != "false": "release/" else: "debug/") & name &
    " --skipParentCfg " &
    " --out:" & outDir & name &
    " " & srcDir & name & ".nim"
  exec outDir & name

task build, "Build and run main.nim":
  rmDir "./build/"
  buildAndRun "main"
