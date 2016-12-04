<?xml version="1.0" encoding="UTF-8" ?>

<!--
Copyright (C) 2016 - 2017 Schimon Jehuda. Released under MIT license
Feeds rendered using this XSLT stylesheet, or it's derivatives, must
include https://sjehuda.github.io/ in attribute name='generator' of
element <meta/> inside of html element </head>
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- extract filename from given url string -->
    <xsl:template name='extract-filename'>
        <xsl:param name='url'/>
        <xsl:choose>
            <xsl:when test='contains($url,"/")'>
                <xsl:call-template name='extract-filename'>
                    <xsl:with-param name='url' select='substring-after($url,"/")'/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select='$url'/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
