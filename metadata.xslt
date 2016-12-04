<?xml version="1.0" encoding="UTF-8" ?>

<!--
Copyright (C) 2016 - 2017 Schimon Jehuda. Released under MIT license
Feeds rendered using this XSLT stylesheet, or it's derivatives, must
include https://sjehuda.github.io/ in attribute name='generator' of
element <meta/> inside of html element </head>
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- set page metadata -->
    <xsl:template name='metadata'>
        <xsl:param name='name'/>
        <xsl:param name='content'/>
        <xsl:if test='$content and not($content="")'>
            <xsl:element name='meta'>
                <xsl:attribute name='name'>
                    <xsl:value-of select='$name'/>
                </xsl:attribute>
                <xsl:attribute name='content'>
                    <xsl:value-of select='$content'/>
                </xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
