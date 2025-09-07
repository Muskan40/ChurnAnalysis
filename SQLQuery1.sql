use db_Churn
select * from db_Churn.dbo.stg_churn
select Gender,COUNT(Gender) as TotalCount, COUNT(Gender)*100.0/(select count(*) from stg_churn) as Percentage from stg_churn group by Gender
select Contract,COUNT(Contract) as TotalCount, COUNT(Contract)*100.0/(select count(*) from stg_churn) as Percentage from stg_churn group by Contract
select Customer_Status,COUNT(Customer_Status) as TotalCount,SUM(Total_Revenue) as Total_Rev, SUM(Total_Revenue)/(select SUM(Total_Revenue) from stg_churn)*100.0 as RevPercentage from stg_churn group by Customer_Status
select State,COUNT(State) as TotalCount, COUNT(State)*100.0/(select count(*) from stg_churn) as Percentage from stg_churn group by State order by Percentage desc
select distinct Internet_Type from stg_churn