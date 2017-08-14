<?xml version="1.0" encoding="UTF-8" ?>

<!--
Copyright (C) 2016 - 2017 Schimon Jehuda. Released under MIT license
Feeds rendered using this XSLT stylesheet, or it's derivatives, must
include https://sjehuda.github.io/ in attribute name='generator' of
element <meta/> inside of html element </head>
-->

<xsl:stylesheet version='1.0' 
xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
xmlns:xml='http://www.w3.org/TR/xmlbase/'
xmlns:media='http://search.yahoo.com/mrss/'
xmlns:georss='http://www.georss.org/georss'
xmlns:geo='http://www.w3.org/2003/01/geo/wgs84_pos#'
xmlns:atom10='http://www.w3.org/2005/Atom'
xmlns:atom='http://www.w3.org/2005/Atom'>
    <!-- Atom 1.0 Syndication Format -->
    <xsl:output
    media-type='application/atom+xml' />
    <xsl:template match='/atom:feed'>
        <!-- index right-to-left language codes -->
        <!-- TODO http://www.w3.org/TR/xpath/#function-lang -->
        <xsl:variable name='rtl'
        select='@xml:lang[
        contains(self::node(),"ar") or 
        contains(self::node(),"fa") or 
        contains(self::node(),"he") or 
        contains(self::node(),"ji") or 
        contains(self::node(),"ku") or 
        contains(self::node(),"ur") or 
        contains(self::node(),"yi")]'/>
        <html>
            <head>
                <xsl:call-template name='metadata'>
                    <xsl:with-param name='name' select='"description"' />
                    <xsl:with-param name='content' select='atom:subtitle' />
                </xsl:call-template>
                <xsl:call-template name='metadata'>
                    <xsl:with-param name='name' select='"generator"' />
                    <xsl:with-param name='content' select='"syndication4humans https://sjehuda.github.io/"' />
                </xsl:call-template>
                <xsl:call-template name='metadata'>
                    <xsl:with-param name='name' select='"mimetype"' />
                    <xsl:with-param name='content' select='"application/atom+xml"' />
                </xsl:call-template>
                <title>
                    <xsl:choose>
                        <xsl:when test='atom:title and not(atom:title="")'>
                            <xsl:value-of select='atom:title'/>
                        </xsl:when>
                        <xsl:otherwise>QupZilla Feed Viewer</xsl:otherwise>
                    </xsl:choose>
                </title>
                <!-- TODO media='print' -->
                <link href='syndication.css' rel='stylesheet' type='text/css' media='screen'/>
                <!-- whether language code is of direction right-to-left -->
                <xsl:if test='$rtl'>
                    <link href='syndication-rtl.css' rel='stylesheet' type='text/css' />
                </xsl:if>
            </head>
            <body>
                <div id='feed'>
                    <!-- feed logo -->
                    <xsl:if test='atom:logo'>
                        <div id='logo'>
                            <xsl:element name='a'>
                                <xsl:attribute name='href'>
                                    <xsl:value-of select='atom:link[contains(@rel,"alternate")]/@href'/>
                                </xsl:attribute>
                                <xsl:element name='img'>
                                    <xsl:attribute name='src'>
                                        <xsl:value-of select='atom:logo'/>
                                    </xsl:attribute>
                                    <xsl:attribute name='alt'>
                                        <!-- xsl:value-of select='atom:subtitle'/ -->
                                        <xsl:text>logo</xsl:text>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:element>
                        </div>
                    </xsl:if>
                    <!-- feed title -->
                    <div id='title'>
                        <xsl:choose>
                            <xsl:when test='atom:title and not(atom:title="")'>
                                <xsl:attribute name='title'>
                                    <xsl:value-of select='atom:title'/>
                                </xsl:attribute>
                                <xsl:value-of select='atom:title'/>
                            </xsl:when>
                            <xsl:otherwise>
                                <div class='empty'></div>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <!-- feed subtitle -->
                    <div id='subtitle'>
                        <xsl:attribute name='title'>
                            <xsl:value-of select='atom:subtitle'/>
                        </xsl:attribute>
                        <xsl:value-of select='atom:subtitle'/>
                    </div>
                    <!-- feed entry -->
                    <xsl:for-each select='atom:entry'>
                        <div class='entry'>
                            <!-- entry title -->
                            <xsl:if test='atom:title'>
                                <div class='title'>
                                    <xsl:element name='a'>
                                        <xsl:attribute name='href'>
                                            <xsl:value-of select='atom:link[contains(@rel,"alternate")]/@href'/>
                                        </xsl:attribute>
                                        <xsl:attribute name='title'>
                                            <xsl:value-of select='atom:title'/>
                                        </xsl:attribute>
                                        <xsl:value-of select='atom:title'/>
                                    </xsl:element>
                                </div>
                            </xsl:if>
                            <!-- geographic location -->
                            <xsl:choose>
                                <xsl:when test='geo:lat and geo:long'>
                                    <xsl:variable name='lat' select='geo:lat'/>
                                    <xsl:variable name='lng' select='geo:long'/>
                                    <span class='geolocation'>
                                        <a href='geo:{$lat},{$lng}'>⚲</a>
                                    </span>
                                </xsl:when>
                                <xsl:when test='geo:Point'>
                                    <xsl:variable name='lat' select='geo:Point/geo:lat'/>
                                    <xsl:variable name='lng' select='geo:Point/geo:long'/>
                                    <span class='geolocation'>
                                        <a href='geo:{$lat},{$lng}'>⚲</a>
                                    </span>
                                </xsl:when>
                                <xsl:when test='georss:point'>
                                    <xsl:variable name='lat' select='substring-before(georss:point, " ")'/>
                                    <xsl:variable name='lng' select='substring-after(georss:point, " ")'/>
                                    <xsl:variable name='name' select='georss:featurename'/>
                                    <span class='geolocation'>
                                        <a href='geo:{$lat},{$lng}' title='{$name}'>⚲</a>
                                    </span>
                                </xsl:when>
                            </xsl:choose>
                            <!-- entry date -->
                            <xsl:choose>
                                <xsl:when test='atom:updated'>
                                    <div class='updated'>
                                        <xsl:value-of select='atom:updated'/>
                                    </div>
                                </xsl:when>
                                <xsl:when test='atom:published'>
                                    <div class='published'>
                                        <xsl:value-of select='atom:published'/>
                                    </div>
                                </xsl:when>
                                <xsl:otherwise>
                                    <div class='warning atom1 published'></div>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- entry content -->
                            <!-- entry summary of GitLab Atom Syndication Feeds -->
                            <xsl:if test='atom:content or atom:summary'>
                                <div class='content'>
                                    <xsl:choose>
                                        <xsl:when test='atom:summary[contains(@type,"text")]'>
                                            <xsl:attribute name='type'>
                                                <xsl:value-of select='atom:summary/@type'/>
                                            </xsl:attribute>
                                            <xsl:value-of select='atom:summary'/>
                                        </xsl:when>
                                        <xsl:when test='atom:summary[contains(@type,"base64")]'>
                                            <!-- TODO add xsl:template to handle inline media -->
                                        </xsl:when>
                                        <xsl:when test='atom:content[contains(@type,"text")]'>
                                            <xsl:attribute name='type'>
                                                <xsl:value-of select='atom:content/@type'/>
                                            </xsl:attribute>
                                            <xsl:value-of select='atom:content'/>
                                        </xsl:when>
                                        <xsl:when test='atom:content[contains(@type,"base64")]'>
                                            <!-- TODO add xsl:template to handle inline media -->
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test='atom:summary and not(atom:summary="")'>
                                                    <xsl:value-of select='atom:summary' disable-output-escaping='yes'/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select='atom:content' disable-output-escaping='yes'/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                            </xsl:if>
                            <!-- entry enclosure -->
                            <xsl:if test='atom:link[contains(@rel,"enclosure")]'>
                                <div class='enclosure' title='Right-click and Save link as…'>
                                    <xsl:for-each select='atom:link[contains(@rel,"enclosure")]'>
                                        <xsl:element name='span'>
                                            <xsl:attribute name='icon'>
                                                <xsl:value-of select='substring-before(@type,"/")'/>
                                            </xsl:attribute>
                                        </xsl:element>
                                        <xsl:element name='a'>
                                            <xsl:attribute name='href'>
                                                <xsl:value-of select='@href'/>
                                            </xsl:attribute>
                                            <xsl:attribute name='download'/>
                                            <xsl:call-template name='extract-filename'>
                                                <xsl:with-param name='url' select='@href' />
                                            </xsl:call-template>
                                        </xsl:element>
                                        <xsl:element name='span'>
                                            <xsl:attribute name='class'>
                                                <xsl:value-of select='substring-before(@type,"/")'/>
                                            </xsl:attribute>
                                        </xsl:element>
                                        <xsl:if test='@length &gt; 0'>
                                            <xsl:call-template name='transform-filesize'>
                                                <xsl:with-param name='length' select='@length' />
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:element name='br'/>
                                    </xsl:for-each>
                                    <xsl:for-each select='media:content'>
                                        <xsl:element name='span'>
                                            <xsl:attribute name='icon'>
                                                <xsl:value-of select='@medium'/>
                                            </xsl:attribute>
                                        </xsl:element>
                                        <xsl:element name='a'>
                                            <xsl:attribute name='href'>
                                                <xsl:value-of select='@url'/>
                                            </xsl:attribute>
                                            <xsl:attribute name='download'/>
                                            <xsl:call-template name='extract-filename'>
                                                <xsl:with-param name='url' select='@url' />
                                            </xsl:call-template>
                                        </xsl:element>
                                        <xsl:element name='span'>
                                            <xsl:attribute name='class'>
                                                <xsl:value-of select='@medium'/>
                                            </xsl:attribute>
                                        </xsl:element>
                                        <xsl:if test='@fileSize &gt; 0'>
                                            <xsl:call-template name='transform-filesize'>
                                                <xsl:with-param name='length' select='@fileSize' />
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:element name='br'/>
                                    </xsl:for-each>
                                </div>
                            </xsl:if>
                        </div>
                        <!-- entry id -->
                        <xsl:if test='not(atom:id)'>
                            <div class='warning atom1 id'></div>
                        </xsl:if>
                    </xsl:for-each>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
