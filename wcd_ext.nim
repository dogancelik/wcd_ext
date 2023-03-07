import os
import strutils
import logging
import strformat

include modify_params

var consoleLog = newConsoleLogger(useStderr = true)
addHandler(consoleLog)

let
    IsDebug = getEnv("WCDEXT_DEBUG", "1").parseBool
    PrependSlash = getEnv("WCDEXT_PREPEND_SLASH", "1").parseBool
    PrependWildcard = getEnv("WCDEXT_PREPEND_WILDCARD", "0").parseBool
    AppendWildcard = getEnv("WCDEXT_APPEND_WILDCARD", "1").parseBool
    WildcardLast = getEnv("WCDEXT_WILDCARD_LAST", "1").parseBool

if IsDebug:
    debug(&"IsDebug: {IsDebug}")
    debug(&"PrependSlash: {PrependSlash}")
    debug(&"PrependWildcard: {PrependWildcard}")
    debug(&"AppendWildcard: {AppendWildcard}")
    debug(&"WildcardLast: {WildcardLast}")

var
    params: seq[string] = commandLineParams()
    pathSeq: seq[string] = params
    firstParam: string = params[params.low]
    firstChar: char = firstParam[0]
    joined: string = ""

if firstChar in SkipChars:
    pathSeq = params[params.low+1 .. params.high]

joined = combinePaths(pathSeq, IsDebug, PrependSlash, PrependWildcard, AppendWildcard, WildcardLast)

if firstChar in SkipChars:
    if pathSeq.high - pathSeq.low == -1:
        joined = &"{firstParam}"
    else:
        joined = &"{firstParam} {joined}"
else:
    joined = &"{joined}"

echo joined
