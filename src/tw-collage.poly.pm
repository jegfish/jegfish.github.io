#lang pollen

◊(define TiddlyWiki ◊jn["tw"]{TiddlyWiki})
◊(define Pollen ◊jn["pollen"]{Pollen})

◊title{TiddlyWiki Collage}

This page is not really about ◊link["https://tiddlywiki.com/"]{TiddlyWiki}.

TiddlyWiki is one of my favorite pieces of software, one that I feel more people
should know about. It's not perfect, but I consistently encounter situations
that involve organizing information where I think, "TiddlyWiki could do this
quite nicely", or "I wish TiddlyWiki's infrastructure was a bit different so I
could use it for this problem".

I don't use it all that frequently. There are aspects that push me, in
particular, away; not necessarily deficiencies, just things that aren't right
for me. I do think there is room for improvements to TiddlyWiki, or an
alternative. This page is me collecting links and thoughts about tools that feel
similar to TiddlyWiki, to try to find tools I may like.

◊h2{Examples}

Brief mentions:
◊ul{
◊li{Emacs}
}

◊def-jn["tw"]{
◊h3{TiddlyWiki}

◊url{https://tiddlywiki.com/}
}

◊def-jn["smalltalk"]{
◊h3{Smalltalk}

◊url{https://en.wikipedia.org/wiki/Smalltalk}
}

◊def-jn["spreadsheets"]{
◊h3{Spreadsheets}
}

◊def-jn["grist"]{
◊h4{Grist}

◊url{https://www.getgrist.com/}
}

◊def-jn["pollen"]{
◊h3{Pollen}

◊url{https://docs.racket-lang.org/pollen/}
}

◊h3{Acme text editor}

◊url{https://en.wikipedia.org/wiki/Acme_(text_editor)}

Russ Cox's video ◊hyperlink["https://youtu.be/dP1xVpMPn8M?si=18yGfs0poInHQgat"]{◊em{A Tour of the Acme Editor}} is a nice demo of some of what's special about Acme.

◊h2{Themes}

◊def-jn["inc-enh"]{
◊h3{Incremental enhancement and ease of use}
}

◊TiddlyWiki can be used right away as a personal wiki. You can start
creating pages, linking between them, breaking ideas down in a non-linear
fashion. Sure, it doesn't have WYSIWYG editing (at least by default), and uses
its own markup language, but effectively the beginning of the learning curve is
flat.

◊jn["spreadsheets"]{Spreadsheet software} shares this. Without any prior
experience, you can begin laying out information and data. Then, you can slowly
introduce formulas, slowly learn new formulas.

In ◊|Pollen|, you can write semantic markup without pre-defining it. On this
website (which is currently made with Pollen), I write ◊v["◊codeblock{...}"] to
markup blocks of code. Sometimes I'll write ◊v["◊stdin{...}"] instead, to
indicate that the contents represent something to be typed into a ◊g{REPL}. As
of writing, I don't perform any alternative styling for this, but I could in the
future. If I didn't define the ◊v["◊stdin"] function, Pollen would ignore it and
pass the text through unmodified, rather than crashing.

This brings up a common aspect of incremental enhancement: separation. Lack of
knowledge of a necessary formula does not block you from adding to your
spreadsheet. Perhaps this is inherent to the meaning of "incremental". Though I
feel a semi-valid interpretation of "incremental" could lose this, and allow you
to work on unrelated additions, but block you from working on the aspect that
will eventually require a formula you don't know.

◊hr[]

I know how to code. I've used Vim and Emacs. I use Linux and command line tools
frequently. Nonetheless, tools like ◊TiddlyWiki and
◊jn["spreadsheets"]{spreadsheets} still attract me.

Are they more usable? I would certainly say no-code-ish tools tend to be more
inviting. Maybe in the long run something like Emacs can catch up in terms of
how quickly you can accomplish tasks. But there's something I miss from
TiddlyWiki when working with Emacs, I think it is the ◊jn["rich-if"]{richer
interface}.

Currently, I believe the key idea here is ◊em{expressiveness}.

I'm not yet as familiar with ◊Pollen as other tools, but so far I have felt a
similar level of ◊jn["inc-enh"]{incremental enhancement} when working with with
it. When I want to do something but don't know how, it usually turns out to be a
short call to one of the provided functions, or a short custom function. It's
"""real""" coding, but the functions are usually ≤5 lines.

◊wip{
◊def-jn["rich-if"]{
◊h3{Rich interface? Fluency?}
}

Not just "mouse is better", "visual is better". I feel like it's about options.

Though there is something special about the mouse IMO. Acme doesn't really have many keyboard shortcuts; I haven't really used it in anger, but I'm not necessarily against its lack of shortcuts.

Maybe if you have to pick one between mouse and keyboard focused, mouse tends to be better? Not sure I'm really talking about mice specifically here. Though I'm not sure that TiddlyWiki would necessarily be great to use if you can't use a mouse.

Some environments kind of get you both with programmability hooks?

I like both. Keyboard-driven interfaces can really drive fluency. But when using TiddlyWiki I can also feel fluent.

Maybe there's something here that is separate, maybe it's not about mouse vs keyboard? But then what is Emacs missing (at least in my usage of it) that TiddlyWiki has? I'm not sure if I know of any keyboard-driven interfaces that make me feel the same way that TiddlyWiki makes me feel. Maybe Emacs could be it, but I just am not as expert with Emacs as I am with TiddlyWiki? That feels weird to say, but I think it is true. Sure, I know Vim bindings pretty well and am using evil-mode, and I even know Emacs binds pretty well, but that's not really programmability. With TiddlyWiki I know WikiText to some level, but I only know Emacs Lisp at the basic level of a configuration language.

Maybe it's ◊strong{fluency}? And maybe I don't feel that with Emacs because I don't know
Emacs Lisp? I guess I feel it a bit with Pollen. Where I encounter a problem,
something I want to do, and I feel like I know how to approach it; I feel
confident that I can figure it out.
}
