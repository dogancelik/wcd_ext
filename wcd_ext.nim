import os
import strutils
import logging
import strformat

var consoleLog = newConsoleLogger(useStderr = true)
addHandler(consoleLog)

const
    SkipChars: seq[char] = @"-+="

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
    params: seq[TaintedString] = commandLineParams()
    last: seq[TaintedString] = params[params.high].split('\\')
    joined: TaintedString = ""
    firstChar: char = params[params.low][0]

if firstChar in SkipChars:
    discard
else:
    for n in last.low .. last.high:
        var
            addToLast = (n < last.high) or (WildcardLast == true and n == last.high)
        if PrependWildcard == true and addToLast:
            last[n] = '*' & last[n]
        if AppendWildcard == true and addToLast:
            last[n] = last[n] & '*'

    joined = last.join("\\")
    if PrependSlash == true:
        joined = '\\' & joined

    params[params.high] = joined

if IsDebug:
    debug(&"params: {params}")
echo params.join(" ")
