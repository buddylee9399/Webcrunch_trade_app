```
- in the application_helper.rb:
   11    end
   12  
   13:   def active?(path)
   14:     "active" if current_page?(path)
   15    end
   16  

- in the navbar.html.erb:
   14            <% end %>
   15           <% end %>     
   16:          <li class="<%= active?(root_path) %> nav-item">
   17:            <%= link_to 'Active Root', root_path, class: 'nav-link' %>
   18           </li>     
   19        </ul>
```