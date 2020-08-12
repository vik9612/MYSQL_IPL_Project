
create database pie_in_the_sky;

use pie_in_the_sky;

create table IPL_User
(
UserID varchar(20) primary key,
Password varchar(20) not null,
User_Type varchar(10) not null,
Remarks varchar (20)
)
;

create table IPL_Stadium
(
StadiumID integer primary key,
Stadium_name	VARCHAR(25) not null,
City	VARCHAR(15),
Capacity integer,	
Address	VARCHAR(35),
Contact_No integer,
Unique key (Stadium_name)
)
;

create table IPL_Team
(
TeamID	integer	primary key,
Team_Name	VARCHAR(29) Not null,
Team_City	VARCHAR(15),
Remarks	VARCHAR(20)	,
unique key(Team_Name)
)
;

create table IPL_Player
(
PlayerID integer primary key,
Player_Name VARCHAR(35) Not null,
Performance VARCHAR(15),
Remarks	VARCHAR(20),
unique key(Player_Name)
)
;

create table IPL_Team_Players
(
TeamID integer,
PlayerId integer,
Player_Role VARCHAR(10),
Remarks	VARCHAR(20),
primary key(TeamID,PlayerId)
)
;

create table IPL_Tournament
(
TournamentID integer primary key,
Tournament_Name	VARCHAR(30) not null,
From_Date DATE,	
To_Date DATE,	
Team_Count integer,	
Total_Matches integer,
Remarks	VARCHAR(20)
)
;

create table IPL_Match
(
MatchID	integer primary key,
TeamId1	integer not null,
TeamId2	integer not null,
TossWinner integer,
MatchWinner integer,
WinDetails VARCHAR(50),
Remarks	VARCHAR(30)
)
;

create table IPL_Match_Schedule
(
ScheduleID integer primary key,
TournamentID integer,                                         /*FK from Tournament table.*/
MatchID integer,										      /*FK from Match table. */
Match_Type VARCHAR(10),
Match_Date DATE,                                               /* check  IPL_Match_Schedule.Match_Date in (2020-03-29,2020-05-17), */
Start_Time TIME,
StadiumID integer,
Status	VARCHAR(10),
Remarks	VARCHAR(20)
)
;

create table IPL_Bidding_Details
(
BidderID integer,											/*FK from Bidder table. Composite Primary key*/
ScheduleID VARCHAR(20),										/*FK from Match_Schedule table. Composite Primary key.*/
Bid_Team integer,											/*One of the team ids of the match (1 or 2). Composite primary key.*/
Bid_Date DATETIME,											/*Exact date & time of placing the bid. Update this column if a bidder re-bids on the same team for the same match. Composite Primary key.*/
Bid_Status VARCHAR(10),
primary key(BidderID,ScheduleID,Bid_Team,Bid_Date)
)
;

create table IPL_Bidder_Points
(
BidderID integer primary key,								/*FK from Bidder table. */
TournamentID integer,										/*FK from Tournament table.*/ 
No_Of_Bids integer,											/*Total no. of bids placed by a bidder. Updated after completion of the match on which s/he placed the bid.*/
No_Of_Matches integer,										/*Total no. of matches on which s/he placed the bid. Updated as above.*/
Total_Points integer not null Default 0

)
;

create table IPL_Team_Standings
(
TeamID integer primary key,									/*FK from Team table. Primary key*/
TournamentID integer,          					            /*FK from Tournament table.*/ 
Matches_Played integer not null Default 0,
Matches_Won integer not null Default 0,
Matches_Lost integer not null Default 0,
Matches_Tied integer Default 0,
No_Result integer Default 0,
Points integer not null Default 0,
Remarks	VARCHAR(20)
)
;

/*Question 1*/

select a.BidderID,sum(b.Bid_Status="Won")/count(b.Bid_Status)*100'Winning Percentage' from IPL_Bidder_Points a,IPL_Bidding_Details b
group  by a.BidderID
order by 'Winning Percentage' desc;

/*Question 2*/

select
(select Bid_Team from IPL_Bidding_Details
group by Bid_Team
order by Bid_Team
limit 0,1) as 'Lowest Bid Team',
(select count(Bid_Team) as count from IPL_Bidding_Details
group by Bid_Team
order by count
limit 0,1) as 'Count'
;

/*Question 3*/

select s.StadiumID,sum(im.TossWinner=MatchWinner)/count(s.StadiumID)*100 as 'Win Percentage of Toss Winners' from IPL_Match im
join IPL_Match_Schedule ims
on im.MatchID=ims.MatchID
join IPL_Stadium s
on ims.StadiumID=s.StadiumID
group by s.StadiumID
order by s.StadiumID
;

/*Question 4*/

select Bid_Team,count(Bid_Team) from IPL_Bidding_Details
where Bid_Team=
(
select TeamID from IPL_Team_Standings
order by Matches_Won desc
limit 0,1
)
;

/*Question 5*/

select x.TeamID,((y.Points-x.Points)/x.Points)*100 as percentage
from IPL_Team_Standings x
join IPL_Team_Standings y
on x.TeamID=y.TeamID
and y.TournamentID=2018
where x.TournamentID=2017
order by Percentage desc
limit 0,1
;