<?xml version="1.0" encoding="UTF-8" ?>

<!--
Copyright (C) 2016 - 2017 Schimon Jehuda. Released under MIT license
Feeds rendered using this XSLT stylesheet, or it's derivatives, must
include https://sjehuda.github.io/ in attribute name='generator' of
element <meta/> inside of html element </head>
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output
    method = 'html'
    indent = 'yes'
    omit-xml-decleration='no' />
    
    <!-- Atom 1.0 Syndication Format -->
    <xsl:include href='atom2html.xslt'/>
    
    <!-- extract filename from given url string -->
    <xsl:include href='extract-filename.xslt'/>
    
    <!-- set page metadata -->
    <xsl:include href='metadata.xslt'/>
    
    <!-- RSS 2.0 Syndication Format -->
    <xsl:include href='rss2html.xslt'/>
    
    <!-- transform filesize from given length string -->
    <xsl:include href='transform-filesize.xslt'/>
    
</xsl:stylesheet>
