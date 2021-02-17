import os
import strutils

const
    PrependSlash = true
    PrependWildcard = false
    AppendWildcard = true
    WildcardLast = true
    SkipChars: seq[char] = @"-+="

var
    params: seq[TaintedString] = commandLineParams()
    last: seq[TaintedString] = params[params.high].split('\\')
    joined: TaintedString = ""
    firstChar: char = params[params.high][0]

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

echo params.join(" ")
