[Dreamatic](http://dreamatic.org) is a website where users can share dreams (project ideas, proposals etc.) that they need help with. Others can help with resources they are willing to donate or encourage these dreamers with kind words.


#######Rails 3.1.1 (w. Ruby 1.8.7)
####### DB: SQLite 3.7.3
####### CSS3 + HTML (updating to 5)

###### Project status: 
running (hosted on dreamhost.com) <br/>
70+ registered users



####Project MVC info:
Models: User, Dream, Comment, Friend, Request, Like <br/>

| User  | Dream | Comment | Like  |
| --- | --- | --- | --- |
| id (PK) | id(PK)  | id(PK)  | id(PK)  |
| email | user_id (FK)  | user_id(FK) | liker_id  |
| password  | content | dream_id (FK) | dream_id  |
| name  | . | content |   |
| pic |   |   |   |




A user has many non-user objects
A dream belongs to a user & can have many comments and likes
A comment belongs to a user
Friend and Request are association tables. 
Friend 

*db files, gem files and other misc files are not uploaded to github. 
