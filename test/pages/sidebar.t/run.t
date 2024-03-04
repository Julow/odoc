  $ ocamlc -c -bin-annot module1.mli module2.mli

  $ odoc compile --pkg test -c page-page1 -c page-page2 -c Module1 -c Module2 root.mld
  $ odoc compile --parent page-root -I . page1.mld
  $ odoc compile --parent page-root -I . page2.mld
  $ odoc compile --parent page-root -I . module1.cmti
  $ odoc compile --parent page-root -I . module2.cmti

  $ odoc link -I . page-page1.odoc
  $ odoc html-generate --indent -o html page-page1.odocl

  $ cat html/test/root/page1.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head><title>page1 (test.root.page1)</title><meta charset="utf-8"/>
    <link rel="stylesheet" href="../../odoc.css"/>
    <meta name="generator" content="odoc %%VERSION%%"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <script src="../../highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
   </head>
   <body class="odoc">
    <nav class="odoc-nav"><a href="index.html">Up</a> – 
     <a href="../index.html">test</a> &#x00BB; <a href="index.html">root</a>
      &#x00BB; page1
    </nav>
    <header class="odoc-preamble">
     <h1 id="page1"><a href="#page1" class="anchor"></a>Page1</h1>
    </header>
    <nav class="odoc-toc">
     <ul><li><a href="#heading-1">Heading 1</a></li>
      <li><a href="#heading-2">Heading 2</a></li>
     </ul>
    </nav>
    <div class="odoc-content">
     <h2 id="heading-1"><a href="#heading-1" class="anchor"></a>Heading 1</h2>
     <h2 id="heading-2"><a href="#heading-2" class="anchor"></a>Heading 2</h2>
    </div>
   </body>
  </html>
