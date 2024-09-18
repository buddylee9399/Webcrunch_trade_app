def create_site_admin
  1.times do |a|
    User.create(email: "site_admin1@ex.com",
                password: 'asdfasdf',
                password_confirmation: 'asdfasdf',
                first_name: "Site",
                last_name: "Admin")
  end

  puts "1 site admin created"
end

def create_admin
  
  1.times do |a|
    User.create(email: "admin1@ex.com",
                password: 'asdfasdf',
                password_confirmation: 'asdfasdf',
                first_name: "Admin",
                last_name: "User")
  end

  puts "1 admin created"  

  user = User.find(2)
  user.add_role :admin

  puts "Added admin role to first user"
end

def create_users
  5.times do |u|
    User.create(email: "user#{u+1}@ex.com",
                password: 'asdfasdf',
                password_confirmation: 'asdfasdf',
                first_name: "User#{u+1}",
                last_name: "User")
  end

  puts "#{User.count} users created"
end

create_site_admin
create_admin
create_users