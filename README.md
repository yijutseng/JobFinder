# JobFinder
Help you find faculty jobs available in Taiwan


JobFinder is an app run on Shiny: https://yijutseng.shinyapps.io/JobFinder

The main idea of this app is rearching all the webpages in JobList based on keywords in Keywords.txt. 

Please feel free to add new webpages which include hiring messages from universities or academic institutes in Taiwan.

<h2>JobList Format</h2>
Area(Space)Research_inteerests(Space)Webpage_name(Space)URL

<h3>Area Coding Book</h3>
* 1: Northen Taiwan
* 2: Central Taiwan
* 3: Southen Taiwan
* 4: Eastern Taiwan

<h3>Research Interests Coding Book</h3>
* 1: Medical Inforamtics
* 2: Health Managerment 
* 3: Informatics
* 4: Public Health
* 0: All (Data from HR)

<h2>Keywords.txt Format</h2>
'and' each line
In each line, use | to separate 'or'
