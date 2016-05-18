<?xml version="1.0" encoding="utf-8"?>

<!--

  XSL Transform to convert OAI 2.0 responses into XHTML

  By Christopher Gutteridge, University of Southampton
  
  Modified by J W Shepherdson 03/07/2015
  - DC Element lables now match http://www.ddialliance.org/resources/tools/dc
  - all labels use sentence case
  - add 'Home' option to top menu
  
  Modified by S Hassan 11/05/2016  

-->

<!-- 
  
Copyright (c) 2000-2004 University of Southampton, UK. SO17 1BJ.

EPrints 2 is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

EPrints 2 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with EPrints 2; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

-->

   
<!--
  
  All the elements really needed for EPrints are done but if
  you want to use this XSL for other OAI archive you may want
  to make some minor changes or additions.

  Not Done
    The 'about' section of 'record'
    The 'compession' part of 'identify'
    The optional attributes of 'resumptionToken'
    The optional 'setDescription' container of 'set'

  All the links just link to oai_dc versions of records.

-->
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
>

<xsl:output method="html"/>



<xsl:template name="style">

td.value {
	vertical-align: top;
  font-size: 13px;
  padding-left: 20px;
}

td.key {
	text-align: left;
	white-space: nowrap;
	font-weight: bold;
	vertical-align: top;
  font-size: 13px;
  padding: 0 0 10px 0;
}

td.key:after {
  content: ":";
}

.dcdata td.key {
	background-color: #ffffe0;
}

body { 
  background-color: #ffffff;
  color: #231f20; <!-- was #333333;  changed by JWS 03/07/2015 -->
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 13px;
  line-height: 20px;
  margin: 20px;
}

h1, h2, h3 {
	clear: left;
}

h1 {
	border: solid #231f20;
  border-width: 1px 0;
  font-family: 'MuseoSans-500', serif;
  font-size: 23px;
  font-weight: normal;
  margin: -101px 0 86px 182px;
  padding: 8px 1px;
  color: #5b6770;
}

@-moz-document url-prefix() {
     h1 {margin-top: -107px;}
}

h2 {
	border-top: 2px solid #231f20;
  font-size: 12px;
  font-weight: bold;
  line-height: 20px;
  margin-top: 20px !important;
  padding-top: 13px;
  text-transform: uppercase;
}

h3 {
	font-size: 15px;
}

a, a:hover, a:visited {
  color: #294471;
  text-decoration: underline;  
}

.link, .link:hover, .link:visited {
	padding: 0 5px 0 5px;
	text-decoration: underline;
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	color: #294471;
}

.oaiRecord, .oaiRecordTitle {
	background-color: #eee;
	border-style: solid;
	border-color: #ccc;
}

h2.oaiRecordTitle {
	background-color: #ccc;
	font-size: 15px;
	font-weight: bold;
	padding: 10px;
	border-width: 1px 1px 0px 1px;
	margin: 0px;
}

.oaiRecord {
	margin-bottom: 3em;
	border-width: 1px;
	padding: 10px;
}

.results {
	margin-bottom: 1.5em;
}

.xmlSource {
  border-color: #ccc !important;
  font-size: 100% !important;
}

.nav {
    border-bottom: 1px solid #231f20;
    border-top: 1px solid #231f20;
    font-size: .95em;
    list-style: none;
    margin: 0 0 31px 0;
    position: relative;
    clear: both;
}

.nav li {
    display: inline-block;
    vertical-align: top;
}

.nav a {
    border-top: 6px #fff solid;
    color: #000000 !important;
    display: inline-block;
    float: none;
    font-weight: bold;
    line-height: 10px;
    margin: 0 25px;
    padding: 11px 0;
    text-decoration: none;
    font-size: 12px;
}

.nav a.inner-link {
    border: 0;
    padding-top: 0;
    margin-top: -5px;
}

.nav a.inner-link:hover { text-decoration: underline; }

.nav a:hover {
    border-color: #333333;
    text-decoration: none;
}

.nav a.current { border-color: #333333; }

.nav a:hover.purple, .nav a.purple.current { border-color: #702082 !important; }

.nav a:hover.blue, .nav a.blue.current { border-color: #0085ca !important; }

.nav a:hover.green, .nav a.green.current { border-color: #00965e !important; }

.nav a:hover.orange, .nav a.orange.current { border-color: #b74012 !important; }

.nav a:hover.red, .nav a.red.current { border-color: #ef3340 !important; }

.nav a:hover.pink, .nav a.pink.current { border-color: #e10098 !important; }

p.intro {
	font-size: 13px;
  background: #eee;
  border: 1px solid #ccc;
  padding: 10px;
  margin-bottom: 20px;
}

.footer {
  border-top: 1px solid #231f20;
  padding-top: 20px;
  margin-top: 20px;
}

hr {
  border: 0;
  height: 2px;
  background-color: #231f20;
  margin-bottom: 10px;
}

<xsl:call-template name='xmlstyle' />
</xsl:template>

<xsl:variable name='identifier' select="substring-before(concat(substring-after(/oai:OAI-PMH/oai:request,'identifier='),'&amp;'),'&amp;')" />

<xsl:template match="/">
<html>
  <head>
    <title>OAI-PMH request results</title>
    <style><xsl:call-template name="style"/></style>
  </head>
  <body>
    <div class="header"><a href="http://www.ukdataservice.ac.uk/"><img src="../images/ukds-logo.jpg" alt="UK Data Sevice" border="0"></img></a><h1>OAI-PMH Request results</h1></div>
    <!--<p class="intro">You are viewing an HTML version of the XML OAI response. To see the underlying XML use your web browsers view source option. More information about this XSLT is at the <a href="#moreinfo">bottom of the page</a>.</p>-->
    <hr/>
    <xsl:apply-templates select="/oai:OAI-PMH" />
    <!--<xsl:call-template name="quicklinks"/>-->
    <!--<h2 name="moreinfo">About the XSLT</h2>
    <p>An XSLT file has converted the <a href="http://www.openarchives.org">OAI-PMH 2.0</a> responses into XHTML which looks nice in a browser which supports XSLT such as Mozilla, Firebird and Internet Explorer. 
	The XSLT file was created by <a href="http://www.ecs.soton.ac.uk/people/cjg">Christopher Gutteridge</a> at the University of Southampton as part of the <a href="http://software.eprints.org">GNU EPrints system</a>, and is freely redistributable under the <a href="http://www.gnu.org">GPL</a>.</p><p>If you want to use the XSL file on your own OAI interface you may but due to the way XSLT works you must install the XSL file on the same server as the OAI script, you can't just link to this copy.</p>
	<p>For more information or to download the XSL file please see the <a href="http://software.eprints.org/xslt.php">OAI to XHTML XSLT homepage</a>.</p>-->
    <div class="footer">
	<!--
	<a href="http://www.openarchives.org"><img border="0" src="http://www.openarchives.org/images/OA100.gif"></img></a>
	-->
	<a href="http://www.esrc.ac.uk/"> <img src="http://ukdataservice.ac.uk/images/ukdataservice/esrc-logo-50.jpg" alt="ESRC 50th Anniversary" /></a>
	</div>
	<div>
	<br />
		The UK Data Service is funded by the ESRC with contributions from the University of Essex and the University of Manchester.<br />&#xA9; Copyright 2012-2015 University of Essex and University of Manchester. All rights reserved.
	</div>
	 <div>
	 <br />
        Last modified: 2016-05-11
    </div>
  </body>
</html>
</xsl:template>

<xsl:template match="/oai:OAI-PMH">
  <table class="values">
    <tr><td class="key">Date stamp of response</td>
    <td class="value"><xsl:value-of select="oai:responseDate"/></td></tr>
    <tr><td class="key">Request URL</td>
    <td class="value"><xsl:value-of select="oai:request"/></td></tr>
  </table>
<!--  verb: [<xsl:value-of select="oai:request/@verb" />]<br /> -->
  <xsl:choose>
    <xsl:when test="oai:error">
      <h2>OAI Error(s)</h2>
      <p>The request could not be completed due to the following error or errors.</p>
      <div class="results">
        <xsl:apply-templates select="oai:error"/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <p>Request was of type <xsl:value-of select="oai:request/@verb"/>.</p>
      <div class="results">
        <xsl:apply-templates select="oai:Identify" />
        <xsl:apply-templates select="oai:GetRecord"/>
        <xsl:apply-templates select="oai:ListRecords"/>
        <xsl:apply-templates select="oai:ListSets"/>
        <xsl:apply-templates select="oai:ListMetadataFormats"/>
        <xsl:apply-templates select="oai:ListIdentifiers"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- ERROR -->

<xsl:template match="/oai:OAI-PMH/oai:error">
  <table class="values">
    <tr><td class="key">Error code</td>
    <td class="value"><xsl:value-of select="@code"/></td></tr>
  </table>
  <p class="error"><xsl:value-of select="." /></p>
</xsl:template>

<!-- IDENTIFY -->

<xsl:template match="/oai:OAI-PMH/oai:Identify">
  <table class="values">
    <tr><td class="key">Repository name</td>
    <td class="value"><xsl:value-of select="oai:repositoryName"/></td></tr>
    <tr><td class="key">Base URL</td>
    <td class="value"><xsl:value-of select="oai:baseURL"/></td></tr>
    <tr><td class="key">Protocol version</td>
    <td class="value"><xsl:value-of select="oai:protocolVersion"/></td></tr>
    <tr><td class="key">Earliest datestamp</td>
    <td class="value"><xsl:value-of select="oai:earliestDatestamp"/></td></tr>
    <tr><td class="key">Deleted record policy</td>
    <td class="value"><xsl:value-of select="oai:deletedRecord"/></td></tr>
    <tr><td class="key">Granularity</td>
    <td class="value"><xsl:value-of select="oai:granularity"/></td></tr>
    <xsl:apply-templates select="oai:adminEmail"/>
  </table>
  <xsl:apply-templates select="oai:description"/>
<!--no warning about unsupported descriptions -->
</xsl:template>

<xsl:template match="/oai:OAI-PMH/oai:Identify/oai:adminEmail">
    <tr><td class="key">Admin email</td>
    <td class="value"><xsl:value-of select="."/></td></tr>
</xsl:template>

<!--
   Identify / Unsupported Description
-->

<xsl:template match="oai:description/*" priority="-100">
  <h2>Unsupported description type</h2>
  <p>The XSL currently does not support this type of description.</p>
  <div class="xmlSource">
    <xsl:apply-templates select="." mode='xmlMarkup' />
  </div>
</xsl:template>


<!--
   Identify / OAI-Identifier
-->

<xsl:template match="id:oai-identifier" xmlns:id="http://www.openarchives.org/OAI/2.0/oai-identifier">
  <h2>OAI-Identifier</h2>
  <table class="values">
    <tr><td class="key">Scheme</td>
    <td class="value"><xsl:value-of select="id:scheme"/></td></tr>
    <tr><td class="key">Repository identifier</td>
    <td class="value"><xsl:value-of select="id:repositoryIdentifier"/></td></tr>
    <tr><td class="key">Delimiter</td>
    <td class="value"><xsl:value-of select="id:delimiter"/></td></tr>
    <tr><td class="key">Sample OAI identifier</td>
    <td class="value"><xsl:value-of select="id:sampleIdentifier"/></td></tr>
  </table>
</xsl:template>


<!--
   Identify / EPrints
-->

<xsl:template match="ep:eprints" xmlns:ep="http://www.openarchives.org/OAI/1.1/eprints">
  <h2>EPrints description</h2>
  <h3>Content</h3>
  <xsl:apply-templates select="ep:content"/>
  <xsl:if test="ep:submissionPolicy">
    <h3>Submission policy</h3>
    <xsl:apply-templates select="ep:submissionPolicy"/>
  </xsl:if>
  <h3>Metadata policy</h3>
  <xsl:apply-templates select="ep:metadataPolicy"/>
  <h3>Data policy</h3>
  <xsl:apply-templates select="ep:dataPolicy"/>
  <xsl:if test="ep:content">
    <h3>Content</h3>
    <xsl:apply-templates select="ep:content"/>
  </xsl:if>
  <xsl:apply-templates select="ep:comment"/>
</xsl:template>

<xsl:template match="ep:content|ep:dataPolicy|ep:metadataPolicy|ep:submissionPolicy" xmlns:ep="http://www.openarchives.org/OAI/1.1/eprints">
  <xsl:if test="ep:text">
    <p><xsl:value-of select="ep:text" /></p>
  </xsl:if>
  <xsl:if test="ep:URL">
    <div><a href="{ep:URL}"><xsl:value-of select="ep:URL" /></a></div>
  </xsl:if>
</xsl:template>

<xsl:template match="ep:comment" xmlns:ep="http://www.openarchives.org/OAI/1.1/eprints">
  <h3>Comment</h3>
  <div><xsl:value-of select="."/></div>
</xsl:template>


<!--
   Identify / Friends
-->

<xsl:template match="fr:friends" xmlns:fr="http://www.openarchives.org/OAI/2.0/friends/">
  <h2>Friends</h2>
  <ul>
    <xsl:apply-templates select="fr:baseURL"/>
  </ul>
</xsl:template>

<xsl:template match="fr:baseURL" xmlns:fr="http://www.openarchives.org/OAI/2.0/friends/">
  <li><xsl:value-of select="."/> 
<xsl:text> </xsl:text>
<a class="link" href="{.}?verb=Identify">Identify</a></li>
</xsl:template>


<!--
   Identify / Branding
-->

<xsl:template match="br:branding" xmlns:br="http://www.openarchives.org/OAI/2.0/branding/">
  <h2>Branding</h2>
  <xsl:apply-templates select="br:collectionIcon"/>
  <xsl:apply-templates select="br:metadataRendering"/>
</xsl:template>

<xsl:template match="br:collectionIcon" xmlns:br="http://www.openarchives.org/OAI/2.0/branding/">
  <h3>Icon</h3>
  <xsl:choose>
    <xsl:when test="link!=''">
      <a href="{br:link}"><img src="{br:url}" alt="{br:title}" width="{br:width}" height="{br:height}" border="0" /></a>
    </xsl:when>
    <xsl:otherwise>
      <img src="{br:url}" alt="{br:title}" width="{br:width}" height="{br:height}" border="0" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="br:metadataRendering" xmlns:br="http://www.openarchives.org/OAI/2.0/branding/">
  <h3>Metadata rendering rule</h3>
  <table class="values">
    <tr><td class="key">URL</td>
    <td class="value"><xsl:value-of select="."/></td></tr>
    <tr><td class="key">Namespace</td>
    <td class="value"><xsl:value-of select="@metadataNamespace"/></td></tr>
    <tr><td class="key">Mime type</td>
    <td class="value"><xsl:value-of select="@mimetype"/></td></tr>
  </table>
</xsl:template>



<!--
   Identify / Gateway
-->

<xsl:template match="gw:gateway" xmlns:gw="http://www.openarchives.org/OAI/2.0/gateway/x">
  <h2>Gateway information</h2>
  <table class="values">
    <tr><td class="key">Source</td>
    <td class="value"><xsl:value-of select="gw:source"/></td></tr>
    <tr><td class="key">Description</td>
    <td class="value"><xsl:value-of select="gw:gatewayDescription"/></td></tr>
    <xsl:apply-templates select="gw:gatewayAdmin"/>
    <xsl:if test="gw:gatewayURL">
      <tr><td class="key">URL</td>
      <td class="value"><xsl:value-of select="gw:gatewayURL"/></td></tr>
    </xsl:if>
    <xsl:if test="gw:gatewayNotes">
      <tr><td class="key">Notes</td>
      <td class="value"><xsl:value-of select="gw:gatewayNotes"/></td></tr>
    </xsl:if>
  </table>
</xsl:template>

<xsl:template match="gw:gatewayAdmin" xmlns:gw="http://www.openarchives.org/OAI/2.0/gateway/">
  <tr><td class="key">Admin</td>
  <td class="value"><xsl:value-of select="."/></td></tr>
</xsl:template>


<!-- GetRecord -->

<xsl:template match="oai:GetRecord">
  <xsl:apply-templates select="oai:record" />
</xsl:template>

<!-- ListRecords -->

<xsl:template match="oai:ListRecords">
  <xsl:apply-templates select="oai:record" />
  <xsl:apply-templates select="oai:resumptionToken" />
</xsl:template>

<!-- ListIdentifiers -->

<xsl:template match="oai:ListIdentifiers">
  <xsl:apply-templates select="oai:header" />
  <xsl:apply-templates select="oai:resumptionToken" />
</xsl:template>

<!-- ListSets -->

<xsl:template match="oai:ListSets">
  <xsl:apply-templates select="oai:set" />
  <xsl:apply-templates select="oai:resumptionToken" />
</xsl:template>

<xsl:template match="oai:set">
  <h2>Set</h2>
  <table class="values">
    <tr><td class="key">Set name</td>
    <td class="value"><xsl:value-of select="oai:setName"/></td></tr>
    <xsl:apply-templates select="oai:setSpec" />
  </table>
</xsl:template>

<!-- ListMetadataFormats -->

<xsl:template match="oai:ListMetadataFormats">
  <xsl:choose>
    <xsl:when test="$identifier">
      <p>This is a list of metadata formats available for the record "<xsl:value-of select='$identifier' />". Use these links to view the metadata: <xsl:apply-templates select="oai:metadataFormat/oai:metadataPrefix" /></p>
    </xsl:when>
    <xsl:otherwise>
      <p>This is a list of metadata formats available from this archive.</p>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="oai:metadataFormat" />
</xsl:template>

<xsl:template match="oai:metadataFormat">
  <h2>Metadata format</h2>
  <table class="values">
    <tr><td class="key">metadataPrefix</td>
    <td class="value"><xsl:value-of select="oai:metadataPrefix"/></td></tr>
    <tr><td class="key">metadataNamespace</td>
    <td class="value"><xsl:value-of select="oai:metadataNamespace"/></td></tr>
    <tr><td class="key">schema</td>
    <td class="value"><a href="{oai:schema}"><xsl:value-of select="oai:schema"/></a></td></tr>
  </table>
</xsl:template>

<xsl:template match="oai:metadataPrefix">
      <xsl:text> </xsl:text><a class="link" href="?verb=GetRecord&amp;metadataPrefix={.}&amp;identifier={$identifier}"><xsl:value-of select='.' /></a>
</xsl:template>

<!-- record object -->

<xsl:template match="oai:record">
  <h2 class="oaiRecordTitle">OAI record: <xsl:value-of select="oai:header/oai:identifier"/></h2>
  <div class="oaiRecord">
    <xsl:apply-templates select="oai:header" />
    <xsl:apply-templates select="oai:metadata" />
    <xsl:apply-templates select="oai:about" />
  </div>
</xsl:template>

<xsl:template match="oai:header">
  <h3>OAI record header</h3>
  <table class="values">
    <tr><td class="key">OAI identifier</td>
    <td class="value">
      <xsl:value-of select="oai:identifier"/>
      <xsl:text> </xsl:text><a class="link" href="?verb=GetRecord&amp;metadataPrefix=oai_dc&amp;identifier={oai:identifier}">oai_dc</a>
      <xsl:text> </xsl:text><a class="link" href="?verb=ListMetadataFormats&amp;identifier={oai:identifier}">formats</a>
    </td></tr>
    <tr><td class="key">Date stamp</td>
    <td class="value"><xsl:value-of select="oai:datestamp"/></td></tr>
  <xsl:apply-templates select="oai:setSpec" />
  </table>
  <xsl:if test="@status='deleted'">
    <p>This record has been deleted.</p>
  </xsl:if>
</xsl:template>


<xsl:template match="oai:about">
  <p>"about" part of record container not supported by the XSL</p>
</xsl:template>

<xsl:template match="oai:metadata">
  <div class="metadata">
    <xsl:apply-templates select="*" />
  </div>
</xsl:template>




<!-- oai setSpec object -->

<xsl:template match="oai:setSpec">
  <tr><td class="key">Set specification</td>
  <td class="value"><xsl:value-of select="."/>
    <xsl:text> </xsl:text><a class="link" href="?verb=ListIdentifiers&amp;metadataPrefix=oai_dc&amp;set={.}">Identifiers</a>
    <xsl:text> </xsl:text><a class="link" href="?verb=ListRecords&amp;metadataPrefix=oai_dc&amp;set={.}">Records</a>
  </td></tr>
</xsl:template>



<!-- oai resumptionToken -->

<xsl:template match="oai:resumptionToken">
   <p>There are more results.</p>
   <table class="values">
     <tr><td class="key">resumptionToken:</td>
     <td class="value"><xsl:value-of select="."/>
<xsl:text> </xsl:text>
<a class="link" href="?verb={/oai:OAI-PMH/oai:request/@verb}&amp;resumptionToken={.}">Resume</a></td></tr>
   </table>
</xsl:template>

<!-- unknown metadata format -->

<xsl:template match="oai:metadata/*" priority='-100'>
  <h3>Unknown metadata format</h3>
  <div class="xmlSource">
    <xsl:apply-templates select="." mode='xmlMarkup' />
  </div>
</xsl:template>

<!-- oai_dc record -->

<xsl:template match="oai_dc:dc"  xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" >
  <div class="dcdata">
    <h3>Dublin core metadata (oai_dc)</h3>
    <table class="dcdata">
      <xsl:apply-templates select="*" />
    </table>
  </div>
</xsl:template>

<xsl:template match="dc:title" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Title</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:creator" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Creator</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:subject" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Subject</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:description" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Description</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:publisher" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Publisher</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:contributor" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Contributor</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:date" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Date</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:type" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Type</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:format" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Format</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:identifier" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Identifier</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:source" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Source</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:language" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Language</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:relation" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Relation</td><td class="value">
  <xsl:choose>
    <xsl:when test='starts-with(.,"http" )'>
      <xsl:choose>
        <xsl:when test='string-length(.) &gt; 50'>
          <a class="link" href="{.}">URL</a>
          <i> URL not shown as it is very long.</i>
        </xsl:when>
        <xsl:otherwise>
          <a href="{.}"><xsl:value-of select="."/></a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</td></tr></xsl:template>

<xsl:template match="dc:coverage" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Coverage</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<xsl:template match="dc:rights" xmlns:dc="http://purl.org/dc/elements/1.1/">
<tr><td class="key">Rights</td><td class="value"><xsl:value-of select="."/></td></tr></xsl:template>

<!-- XML Pretty Maker -->

<xsl:template match="node()" mode='xmlMarkup'>
  <div class="xmlBlock">
    &lt;<span class="xmlTagName"><xsl:value-of select='name(.)' /></span><xsl:apply-templates select="@*" mode='xmlMarkup'/>&gt;<xsl:apply-templates select="node()" mode='xmlMarkup' />&lt;/<span class="xmlTagName"><xsl:value-of select='name(.)' /></span>&gt;
  </div>
</xsl:template>

<xsl:template match="text()" mode='xmlMarkup'><span class="xmlText"><xsl:value-of select='.' /></span></xsl:template>

<xsl:template match="@*" mode='xmlMarkup'>
  <xsl:text> </xsl:text><span class="xmlAttrName"><xsl:value-of select='name()' /></span>="<span class="xmlAttrValue"><xsl:value-of select='.' /></span>"
</xsl:template>

<xsl:template name="xmlstyle">
.xmlSource {
	font-size: 70%;
	border: solid #c0c0a0 1px;
	background-color: #ffffe0;
	padding: 2em 2em 2em 0em;
}
.xmlBlock {
	padding-left: 2em;
}
.xmlTagName {
	color: #800000;
	font-weight: bold;
}
.xmlAttrName {
	font-weight: bold;
}
.xmlAttrValue {
	color: #0000c0;
}
</xsl:template>

</xsl:stylesheet>

