<?xml version="1.0" encoding="UTF-8" ?>

<!--
Copyright (C) 2016 - 2017 Schimon Jehuda. Released under MIT license
Feeds rendered using this XSLT stylesheet, or it's derivatives, must
include https://sjehuda.github.io/ in attribute name='generator' of
element <meta/> inside of html element </head>
-->

<xsl:stylesheet version='1.0' 
xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
xmlns:media='http://search.yahoo.com/mrss/'
xmlns:itunes='http://www.itunes.com/dtds/podcast-1.0.dtd'
xmlns:georss='http://www.georss.org/georss'
xmlns:geo='http://www.w3.org/2003/01/geo/wgs84_pos#'
xmlns:content='http://purl.org/rss/1.0/modules/content/'
xmlns:atom10='http://www.w3.org/2005/Atom'
xmlns:atom='http://www.w3.org/2005/Atom'>
    <!-- RSS 2.0 Syndication Format -->
    <xsl:output
    media-type='application/rss+xml' />
    <xsl:template match='/rss'>
        <!-- index right-to-left language codes -->
        <xsl:variable name='rtl'
        select='channel/language[
        contains(text(),"ar") or 
        contains(text(),"fa") or 
        contains(text(),"he") or 
        contains(text(),"ji") or 
        contains(text(),"ku") or 
        contains(text(),"ur") or 
        contains(text(),"yi")]'/>
        <html>
            <head>
                <xsl:call-template name='metadata'>
                    <xsl:with-param name='name' select='"description"' />
                    <xsl:with-param name='content' select='channel/description' />
                </xsl:call-template>
                <xsl:call-template name='metadata'>
                    <xsl:with-param name='name' select='"generator"' />
                    <xsl:with-param name='content' select='"syndication4humans https://sjehuda.github.io/"' />
                </xsl:call-template>
                <xsl:call-template name='metadata'>
                    <xsl:with-param name='name' select='"mimetype"' />
                    <xsl:with-param name='content' select='"application/rss+xml"' />
                </xsl:call-template>
                <title>
                    <xsl:choose>
                        <xsl:when test='channel/title and not(channel/title="")'>
                            <xsl:value-of select='channel/title'/>
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
                    <xsl:if test='channel/image'>
                        <div id='logo'>
                            <xsl:element name='a'>
                                <xsl:attribute name='href'>
                                    <xsl:value-of select='channel/image/link'/>
                                </xsl:attribute>
                                <xsl:element name='img'>
                                    <xsl:attribute name='src'>
                                        <xsl:value-of select='channel/image/url'/>
                                    </xsl:attribute>
                                    <xsl:attribute name='alt'>
                                        <!-- xsl:value-of select='channel/image/title'/ -->
                                        <xsl:text>logo</xsl:text>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:element>
                        </div>
                    </xsl:if>
                    <!-- feed title -->
                    <div id='title'>
                        <xsl:choose>
                            <xsl:when test='channel/title and not(channel/title="")'>
                                <xsl:attribute name='title'>
                                    <xsl:value-of select='channel/title'/>
                                </xsl:attribute>
                                <xsl:value-of select='channel/title'/>
                            </xsl:when>
                            <xsl:otherwise>
                                <div class='empty'></div>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <!-- feed subtitle -->
                    <xsl:choose>
                        <xsl:when test='channel/itunes:subtitle'>
                            <div id='subtitle'>
                                <xsl:attribute name='title'>
                                    <xsl:value-of select='channel/itunes:subtitle'/>
                                </xsl:attribute>
                                <xsl:value-of select='channel/itunes:subtitle'/>
                            </div>
                        </xsl:when>
                        <xsl:when test='channel/description'>
                            <div id='subtitle'>
                                <xsl:attribute name='title'>
                                    <xsl:value-of select='channel/description'/>
                                </xsl:attribute>
                                <xsl:value-of select='channel/description'/>
                            </div>
                        </xsl:when>
                    </xsl:choose>
                    <!-- feed entry -->
                    <xsl:for-each select='channel/item'>
                        <div class='entry'>
                            <!-- entry title -->
                            <xsl:choose>
                                <xsl:when test='itunes:subtitle'>
                                    <div class='title'>
                                        <xsl:element name='a'>
                                            <xsl:attribute name='href'>
                                                <xsl:value-of select='link'/>
                                            </xsl:attribute>
                                            <xsl:attribute name='title'>
                                                <xsl:value-of select='itunes:subtitle'/>
                                            </xsl:attribute>
                                            <xsl:value-of select='itunes:subtitle'/>
                                        </xsl:element>
                                    </div>
                                </xsl:when>
                                <xsl:when test='title'>
                                    <div class='title'>
                                        <xsl:element name='a'>
                                            <xsl:attribute name='href'>
                                                <xsl:value-of select='link'/>
                                            </xsl:attribute>
                                            <xsl:attribute name='title'>
                                                <xsl:value-of select='title'/>
                                            </xsl:attribute>
                                            <xsl:value-of select='title'/>
                                        </xsl:element>
                                    </div>
                                </xsl:when>
                                <xsl:otherwise>
                                    <div class='warning rss2 title'></div>
                                </xsl:otherwise>
                            </xsl:choose>
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
                            <xsl:if test='pubDate'>
                                <div class='published'>
                                    <xsl:value-of select='pubDate'/>
                                </div>
                            </xsl:if>
                            <!-- entry content -->
                            <xsl:choose>
                                <!-- complete text post -->
                                <xsl:when test='content:encoded'>
                                    <div class='content'>
                                        <xsl:value-of select='content:encoded' disable-output-escaping='yes'/>
                                    </div>
                                </xsl:when>
                                <!-- description of post -->
                                <xsl:when test='description'>
                                    <div class='content'>
                                        <xsl:value-of select='description' disable-output-escaping='yes'/>
                                    </div>
                                </xsl:when>
                                <!-- itunes text post -->
                                <xsl:when test='itunes:summary'>
                                    <div class='content'>
                                        <xsl:value-of select='itunes:summary' disable-output-escaping='yes'/>
                                    </div>
                                </xsl:when>
                                <xsl:otherwise>
                                    <div class='warning rss2 description'></div>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- entry enclosure -->
                            <xsl:if test='enclosure or media:content'>
                                <div class='enclosure' title='Right-click and Save link as…'>
                                    <xsl:for-each select='enclosure'>
                                        <xsl:element name='span'>
                                            <xsl:attribute name='icon'>
                                                <xsl:value-of select='substring-before(@type,"/")'/>
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
                    </xsl:for-each>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
