<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="excludeAlertRef"/>

	<!-- Root template -->
	<xsl:template match="/">
		<testsuites time="0">
			<xsl:apply-templates select="//site" />
		</testsuites>
	</xsl:template>

	<!-- Template for site element -->
	<xsl:template match="site">
		<testsuite name="{@name}" time="0">
			<xsl:apply-templates select="alerts" />
		</testsuite>
	</xsl:template>

	<!-- Template for alerts element -->
	<xsl:template match="alerts">
		<xsl:for-each select="alertitem[riskcode>0]">
			<xsl:if test="not(contains($excludeAlertRef, alertRef))">
				<testcase>
					<xsl:attribute name="name">
						<xsl:value-of select="concat(alertRef, ' : ', name)"/>
					</xsl:attribute>
					<xsl:attribute name="time">0</xsl:attribute>

					<failure type="failure">
						<xsl:attribute name="message">
							<xsl:text disable-output-escaping="no"><![CDATA[<h3>Description</h3>]]></xsl:text>
							<xsl:value-of select="desc"/>
							<xsl:text disable-output-escaping="no"><![CDATA[<h3>Instances</h3>]]></xsl:text>
							<xsl:apply-templates select="instances/instance" />

						</xsl:attribute>
					</failure>					
				</testcase>
			</xsl:if>			
			
		</xsl:for-each>
	</xsl:template>

	<!-- Template for instance element -->
	<xsl:template match="instance">
		<xsl:text disable-output-escaping="no"><![CDATA[<h4>]]></xsl:text>
		<xsl:value-of select="uri"/>
		<xsl:text disable-output-escaping="no"><![CDATA[</h4>]]></xsl:text>
		<xsl:text disable-output-escaping="no"><![CDATA[<p>]]></xsl:text>
		<xsl:value-of select="evidence"/>
		<xsl:text disable-output-escaping="no"><![CDATA[</p>]]></xsl:text>		
	</xsl:template>

</xsl:stylesheet>
