# Salesforce_CRM_Data_Analytics
Salesforce, Inc. is an American cloud-based software company headquartered in San Francisco, California. It provides customer relationship management software and applications focused on sales, customer service, marketing automation, analytics, and application development.

Problem Statments:

Opportunity Dashboard KPI's
-Expected Amount
-Active Opportunities
-Conversion Rate
-Win Rate
-Loss
-Trend Analysis
  1.Running Total Expected Vs Commit Forecast Amount over Time
  2.Running Total Active Vs Total Opportunities over Time
  3.Closed Won Vs Total Opportunities over Time
  4.Closed Won vs Total Closed over Time
-Expected Amount by Opportunity Type
-Opportunities by Industry

Leads Dashboard KPI's
-Total Lead
-Expected Amount from Converted Leads
-Conversion Rate
-Converted Accounts
-Converted Opportunities
-Lead By Source
-Lead By industry

Using SQL, views are created using joins in Microsoft SQL Server which are used further in Power BI for visualization. As some of the columns contains null values they have been taken care in SQL itself using coalesce().

Power Bi is directly connected to SQL server using import query method. Bar Chart,Area chart,Cards,Line Chart,Slider,filters and buttons has been used to create the Dashboard. All the trend analysis in Opportunity Dashboard has been achieved using new measures and quick measures. For KPI cards in both Leads and Opportunity Dashboard DAX function is used.Both the Dashboard has 1 date slider and 1 industry filter which directly affects the appropriate visuals. Finally Buttons is used to navigate to Leads and Opportunity Dashboard bi-directionally
