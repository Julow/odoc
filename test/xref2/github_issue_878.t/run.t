  $ ocamlc -bin-annot -I . a.mli b.mli

  $ odoc compile --pkg test -I . b.cmti
  $ odoc compile --pkg test a.cmti

  $ odoc html --indent -I . -o html a.odoc
  $ odoc html --indent -I . -o html b.odoc

Also works with these:

$ odoc link -I . a.odoc
$ odoc link -I . b.odoc
$ odoc html-generate --indent -o html a.odocl
$ odoc html-generate --indent -o html b.odocl

  $ cat html/test/B/index.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head><title>B (test.B)</title><meta charset="utf-8"/>
    <link rel="stylesheet" href="../../odoc.css"/>
    <meta name="generator" content="odoc %%VERSION%%"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <script src="../../highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
   </head>
   <body class="odoc">
    <nav class="odoc-nav"><a href="../index.html">Up</a> – 
     <a href="../index.html">test</a> &#x00BB; B
    </nav>
    <header class="odoc-preamble"><h1>Module <code><span>B</span></code></h1>
    </header>
    <div class="odoc-content">
     <div class="odoc-include">
      <details open="open">
       <summary class="spec include">
        <code>
         <span><span class="keyword">include</span> 
          <a href="../A/module-type-A/index.html">A.A</a>
         </span>
        </code>
       </summary>
       <div class="odoc-spec">
        <div class="spec type anchored" id="type-t">
         <a href="#type-t" class="anchor"></a>
         <code><span><span class="keyword">type</span> t</span></code>
        </div>
       </div>
      </details>
     </div>
    </div>
   </body>
  </html>

  $ cat html/test/A/module-type-A/index.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head><title>A (test.A.A)</title><meta charset="utf-8"/>
    <link rel="stylesheet" href="../../../odoc.css"/>
    <meta name="generator" content="odoc %%VERSION%%"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <script src="../../../highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
   </head>
   <body class="odoc">
    <nav class="odoc-nav"><a href="../index.html">Up</a> – 
     <a href="../../index.html">test</a> &#x00BB; <a href="../index.html">A</a>
      &#x00BB; A
    </nav>
    <header class="odoc-preamble">
     <h1>Module type <code><span>A.A</span></code></h1>
    </header>
    <div class="odoc-content">
     <div class="odoc-spec">
      <div class="spec type anchored" id="type-t">
       <a href="#type-t" class="anchor"></a>
       <code><span><span class="keyword">type</span> t</span></code>
      </div><div class="spec-doc"><p>Pliz keep me.</p></div>
     </div>
    </div>
   </body>
  </html>

  $ cat html/test/A/index.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head><title>A (test.A)</title><meta charset="utf-8"/>
    <link rel="stylesheet" href="../../odoc.css"/>
    <meta name="generator" content="odoc %%VERSION%%"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <script src="../../highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
   </head>
   <body class="odoc">
    <nav class="odoc-nav"><a href="../index.html">Up</a> – 
     <a href="../index.html">test</a> &#x00BB; A
    </nav>
    <header class="odoc-preamble"><h1>Module <code><span>A</span></code></h1>
    </header>
    <div class="odoc-content">
     <div class="odoc-spec">
      <div class="spec module-type anchored" id="module-type-A">
       <a href="#module-type-A" class="anchor"></a>
       <code>
        <span><span class="keyword">module</span> 
         <span class="keyword">type</span> 
         <a href="module-type-A/index.html">A</a>
        </span>
        <span> = <span class="keyword">sig</span> ... 
         <span class="keyword">end</span>
        </span>
       </code>
      </div>
     </div>
     <div class="odoc-include">
      <details open="open">
       <summary class="spec include">
        <code>
         <span><span class="keyword">include</span> 
          <a href="module-type-A/index.html">A</a>
         </span>
        </code>
       </summary>
       <div class="odoc-spec">
        <div class="spec type anchored" id="type-t">
         <a href="#type-t" class="anchor"></a>
         <code><span><span class="keyword">type</span> t</span></code>
        </div><div class="spec-doc"><p>Pliz keep me.</p></div>
       </div>
      </details>
     </div>
    </div>
   </body>
  </html>
