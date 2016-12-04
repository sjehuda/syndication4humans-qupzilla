<?xml version="1.0" encoding="UTF-8" ?>

<!--
Copyright (C) 2016 - 2017 Schimon Jehuda. Released under MIT license
Feeds rendered using this XSLT stylesheet, or it's derivatives, must
include https://sjehuda.github.io/ in attribute name='generator' of
element <meta/> inside of html element </head>
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- transform filesize from given length string -->
    <xsl:template name='transform-filesize'>
        <xsl:param name='length'/>
        <!-- TODO consider xsl:decimal-format and xsl:number -->
        <xsl:choose>
            <!-- TODO consider removal of Byte -->
            <xsl:when test='$length &lt; 2'>
                <xsl:value-of select='$length'/>
                Byte
            </xsl:when>
            <xsl:when test='floor($length div 1024) &lt; 1'>
                <xsl:value-of select='$length'/>
                Bytes
            </xsl:when>
            <xsl:when test='floor($length div (1024 * 1024)) &lt; 1'>
                <xsl:value-of select='floor($length div 1024)'/>.<xsl:value-of select='substring($length mod 1024,0,2)'/>
                KiB
            </xsl:when>
            <xsl:when test='floor($length div (1024 * 1024 * 1024)) &lt; 1'>
                <xsl:value-of select='floor($length div (1024 * 1024))'/>.<xsl:value-of select='substring($length mod (1024 * 1024),0,2)'/>
                MiB
            </xsl:when>
            <xsl:otherwise>
                <!-- P2P links -->
                <xsl:value-of select='floor($length div (1024 * 1024 * 1024))'/>.<xsl:value-of select='substring($length mod (1024 * 1024 * 1024),0,2)'/>
                GiB
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
