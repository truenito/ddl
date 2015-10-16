# ddl - Dominicana DotA League

![October15-Landing](http://s1.postimg.org/utxnyxojz/ddl_home.png)

DDL is a web based In-House ranking system built in Rails for the Dominican DotA 2 community and supported by the players from the Stomp Machine. 

The community has been playing In House games for more than 7 years without having a way to organize them easily, this application helps with the creation, balancing, game tracking and ranking of players. It also ensures accounts are valid using a combination of human moderator and the integration with Facebook (popular in our country). 

Steam doesn't provide an API for lobby games so the tracking used to be manual, ddl totally automates the process and as it evolves it will try to be as complex and useful as possible.

The application was built using Puma, PostgreSQL and Facebook's omniauth and it's tested with RSpec. 

You can check the web application running live by visiting http://ddl.do .

====

Todo lists:

**2015**:

- Divide gaming periods by seasons, in which we will offer prizes to members of the communities which lead in different categories.
- Smooth out UI and animations.
- Rework views, DRY some stuff (move code to the decorators)
- Improve player profiles.
- Finish the model tests and implement controller, routing and feature tests.
- **(more minor stuff)**

**2016**:
- Add support to mobile devices.
- Add public API.
- Add a live chat using ActionCable.
- Add support to other games.
- Implement a gem with its own DSL to easily manage different games under the same logic.
- **(much more)**
