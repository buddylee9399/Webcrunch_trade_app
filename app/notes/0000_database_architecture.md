# #57 Database Architecture 101: Building an ERD (Entity Relationship Diagram) for UberEats clone
- https://www.youtube.com/watch?v=NZlN73NEgWM
- https://dbdiagram.io/d/restaurant-614cd4f2825b5b014610c1de
- HOW TO CREATE THE DATABASE STRUCTURE FROM A SKETCH OF A RESTAURANT WEBSITE

# Dropping tables
- rails db:schema:dump - delete all tables
- rails db:drop:all
- rails db:version
- rails db:migrate:status
- rails db:drop
- rails db:create
- rails db:reset
- rails db:migrate VERSION=20240818042354
- rails db:rollback
- rails db:rollback STEP=1