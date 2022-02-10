/*
Knorg :  personal knowledge organizer
---------------------

MIT License

Copyright (c) 2021-2022 Albert Berger

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--------------------
Author: Albert Berger [/com/gmail/alberger]
Github: https://github.com/al-berger/knorg
*/

/*
    This program demonstrates basics of using the Transd programming language for
    working with weakly structured data aggregates.
*/

#lang transd


MainModule: {
    base: TSDBase(),
    kb: "../res/1.ko",
    cnt: 0,
    primKey: ["@__cnt__"],

    kmToTsd: (λ const sf String() 
        locals: s "" nqj "" currel "" curpred ""
        (or (starts-with sf "#") (throw "Object field must start with '#'."))
        (with list (split sf) lidx 1
            (strip (= s (get list 0))  "# \t" " \n\t\r")
            (= nqj (+ "\"" s "\" : {"))
            (for ln in Range(in: list 1 -0) do
                (if (match ln "^\\s*$") continue)
                (if (match ln "^\\s*\\*.*")
                    (if (size currel) (+= nqj "`,"))
                    (strip (= currel ln) "* \t" " \n\t\r")
                    (+= nqj currel " : `")
                    (= curpred "")
                else (if (not currel)
                        (throw "Relation field must begin with '*'"))
                    //(if (size curpred) (+= nqj "`"))
                    (+= nqj " " ln)
                    (+= curpred ln)
                )
            )
            (if (size curpred) (+= nqj "`,"))
            (+= nqj (get primKey 0) " : " String((+= cnt 1)))
            (+= nqj " }")
        )
        (ret nqj)
    ),

    _start: (λ locals: sf String() 
        (with rootdir (substr @sourceFile from: 0 to: after: last: "/")
                (= kb (+ rootdir kb)))

        (with fs FileStream() 
            (open-r fs kb)
            (= sf (read-text fs))
        )
        (set-prim-key base primKey)
        (with pos (find sf "#") sobj "" sflen (size sf) nqjobj "" 
            (while (neq pos sflen)
                (= sobj (substr sf from: pos to: "#"))
                (+= pos (size sobj))
                (= nqjobj (kmToTsd sobj))
                (with obj Object( nqjobj true )
                    (add-object base obj)
                )
            )
        )
        (build-index base "Topic")
        (build-index base "Definition")
		(with rows (tql base select: ["@name","Definition|=def"]
                as: [[String(), String()]]
                where: "Definition <> null"
                satisfying: (λ def String() (ret true)))
            (for r in rows do
                (lout "subject: " (get r 0))
                (lout "definition: " (subn (get r 1) 0 50) "\n")
            )
        )
    )
    





}
