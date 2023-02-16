use CRM_project;

--Closed Won opprtunites by Lead_source
select ot.Lead_Source , count(ot.opportunity_Id) as No_of_leads
from OpportunityTable as ot
where ot.stage = 'Closed Won'
group by ot.Lead_Source 
order by No_of_leads desc

--Closed Lost opportunities by Reasons
select ot.closed_lost_reason, count(ot.opportunity_id) as Reasons_count
from OpportunityTable as ot 
where ot.stage = 'Closed Lost'
group by ot.closed_lost_reason
order by Reasons_count desc


-- Account Ratings and no of Closed Won opportunities
select a.Account_ID, a.Account_Name, a.Account_Rating,a.Billing_Country,count(ot.opportunity_id) as No_of_opportunities
from Account as a inner join OpportunityTable as ot
on a.account_id = ot.Account_id
where ot.stage = 'Closed Won'
group by a.Account_ID, a.Account_Name, a.Account_Rating,a.Billing_Country
order by No_of_opportunities desc 


--Oportunity Table
-- Win Rate
select closed_won/t.total * 100 as Win_Rate
from(select convert(float,(select count(ot.opportunity_id) from OpportunityTable as ot 
where ot.stage = 'Closed Won')) as closed_won,
convert(float,count(opportunity_id)) as total
from OpportunityTable
) as t

-- Opportunities By Industry
select industry,count(opportunity_id)as No_of_Opportunity
from OpportunityTable
group by industry
order by No_of_Opportunity desc

-- Active Opportunities
select count(ot.opportunity_id) as Active_opportunities
from OpportunityTable as ot
where ot.stage not in ('Closed Won','Closed Lost')

--Running Total Expected vs Commit Forecast Amount over time
select Opportunity_ID,[Expected Amount],[Created Date],sum([Expected Amount]) over(order by [Created Date],Opportunity_id) as Running_total
from OpportunityTable

select Opportunity_id,[Created Date],Amount
from OpportunityTable
where [Forecast Category1] = 'Commit'
order by [Created Date]

--Leads
--Total Leads
go
create view Total_Leads as 
select count([Lead ID]) as Total_Leads from Leads;
go
--Conversion Rates
create view Conversion_Rates as
select convert(float,(select count(l.[Lead ID]) from Leads as l where l.Converted = 'True'))
/convert(float,count([Lead ID])) * 100 as Conversion_Rates
from Leads
go

--Converted Accounts
create view Converted_Accounts as
select count([Converted_Account_ID]) as Converted_Accounts
from Leads where [Converted_Account_ID] is not NULL
go

--Converted Opportunities
create view Converted_Oppotunities as
select count([Converted_Opportunity_ID]) as Converted_Oppotunities
from Leads where [Converted_Opportunity_ID] is not NULL
go

--Lead By Source
create view No_of_Leads_by_source as
select case when [Lead Source] is Null then 'Other' else [Lead Source] end as Lead_Source,count([Lead ID]) as No_of_Leads
from Leads
group by [Lead Source]
go

--Lead By Industry
create view No_of_Leads_by_Industry as
select case when [Industry] is Null then 'Other' else [Industry] end as Industry,count([Lead ID]) as No_of_Leads
from Leads
group by [Industry]
go


--Expected Amount from converted leads
create view Expected_Amount_from_converted_leads as
select ot.[Account_ID],ot.[Opportunity_ID],ot.[Industry],l.[Lead Source],
case when ot.[Expected Amount] is Null then 0 else ot.[Expected Amount]end as Expected_Amount
from Leads as l inner join OpportunityTable as ot
on l.[Converted_Account_ID] = ot.[Account_ID]
and l.[Converted_Opportunity_ID] = ot.[Opportunity_ID]
go




/*CRM DATA ANALYSIS*/

/*LEADS JOINED WITH OPPORRUNITY VIEW*/
create view Leads_joined_Opportunity as
select ROW_NUMBER() over(order by l.[Lead ID]) as row_num,
l.[Lead ID],l.[Converted],YEAR(l.[Created Date]) as [Created Year],l.[Converted_Account_ID],l.[Converted_Opportunity_ID],ot.[Account_ID],ot.[Opportunity_ID],
coalesce(l.[Industry],'Other') as [Industry],
coalesce(l.[Lead Source],'Other') as [Lead Source],
coalesce(ot.[Expected Amount],0) as [Expected Amount]
from Leads as l left join OpportunityTable as ot
on l.[Converted_Account_ID] = ot.[Account_ID]
and l.[Converted_Opportunity_ID] = ot.[Opportunity_ID]
go

/*OPPORTUNITY VIEW*/
create View Opportunity_View as 
select ROW_NUMBER() over(order by ot.[Opportunity_ID]) as row_num ,ot.[Opportunity_ID],ot.[Created Date],ot.[Closed],
ot.[Created by Lead Conversion],ot.[Stage],ot.[Forecast Category1],
coalesce(ot.[Amount],0) as [Amount],
coalesce(ot.[Expected Amount],0) as [Expected Amount],
coalesce(ot.[Opportunity Type],'Other') as [Opportunity Type],
coalesce(ot.[Industry],'Other') as [Industry]
from OpportunityTable as ot
go
 
